#load dependencies
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(psych)

#######################################
#READ IN AND PREPARE DATA FOR ANALYSIS#
#######################################

#print working directory for future references
wd <- print(getwd())

#read in quality data from data_preparation.R
data <- read_delim(file = paste(wd, "/output/AsRG_summary.txt", sep = ""), delim = "\t")


#read in taxanomic information
ncbi <- read_delim(file = paste(wd, "/data/ismej2016168x6_plasmid.csv", sep = ""), delim = ",")

#separate out extra NCBI ID's and
#remove version number on NCBI ID (.##)
ncbi.tidy <- ncbi %>%
  separate(col = NCBI.ID, into = c("NCBI.ID", "NCBI.ID2", "NCBI.ID3"), sep = ",") %>%
  mutate(Contains.plasmid = !is.na(Plasmid.ID)) %>%
  separate(col = Plasmid.ID, into = c("plasmid1", "plasmid2","plasmid3","plasmid4","plasmid5","plasmid6","plasmid7","plasmid8","plasmid9","plasmid10","plasmid11","plasmid12","plasmid13","plasmid14"), sep = ",") %>%
  mutate(NCBI.ID = gsub("\\..*","",NCBI.ID),
         NCBI.ID2 = gsub("\\..*","",NCBI.ID2),
         NCBI.ID3 = gsub("\\..*","",NCBI.ID3)) %>%
  select(`RefSoil ID`, `Taxon ID`, Phylum, Contains.plasmid, NCBI.ID, NCBI.ID2, NCBI.ID3, plasmid1:plasmid14) %>%
  melt(id = c("RefSoil ID", "Taxon ID", "Phylum", "Contains.plasmid"), variable.name = "Source", value.name = "NCBI.ID")


#remove all rows where value = NA
ncbi.tidy <- ncbi.tidy[!is.na(ncbi.tidy$NCBI.ID),]

#join AsRG data with RefSoi IDs
data.tax <- ncbi.tidy %>%
  group_by(`RefSoil ID`) %>%
  mutate(Elements = length(`RefSoil ID`)) %>%
  left_join(data, by = "NCBI.ID")

#change NA gene to "None"
data.tax$Gene[is.na(data.tax$Gene)] <- "None"

#extract genome accession for tree comparison
unique.id <- ncbi.tidy[!duplicated(ncbi.tidy$`RefSoil ID`), ]
id.tree.comp <- data.tax %>%
  left_join(unique.id, by = "RefSoil ID") %>%
  rename(main.id = NCBI.ID.y) %>%
  ungroup() %>%
  select(t.name, main.id) %>%
  drop_na() %>%
  mutate(t.name = paste(t.name, ":", sep = ""),
         main.id = paste(main.id, ":", sep = ""))

#save file for export
#write.table(id.tree.comp, file = paste(wd, "/output/id.tree.comp.txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

#cast data
data.tax.cast <- data.tax %>%
  select(`RefSoil ID`, Phylum, Source, NCBI.ID, Contains.plasmid, Elements, Gene) %>%
  mutate(Source = gsub("plasmid.", "plasmid", Source),
         Source = gsub("plasmid.", "plasmid", Source),
         Source = gsub("NCBI.ID.", "chromosome", Source),
         Source = gsub("NCBI.ID", "chromosome", Source)) %>%
  dcast(`RefSoil ID` + Phylum + Contains.plasmid + Elements + Gene ~ Source, fun.aggregate = length, value.var = "Gene")

#further, remove if none = total elements
data.tax.cast <- data.tax.cast[-which(data.tax.cast$Gene == "None" & data.tax.cast$Elements > data.tax.cast$chromosome + data.tax.cast$plasmid),]

#calculate relative hits (gene/genome)
data.taxREL <- data.tax.cast %>%
  mutate(Total = chromosome + plasmid,
         Rel = Total/length(unique(data.tax.cast$`RefSoil ID`)))

#save table 
write.table(data.taxREL, file = paste(wd, "/output/RefSoil_count.txt", sep = ""), sep = "\t", row.names = FALSE)

#make color scheme
#n <- 25
#qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
#col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
#phy.color <- print(sample(col_vector, n))
color <- c("#FDB462", "#F4CAE4", "#DECBE4", "#6A3D9A", "black", "#B15928", "#1F78B4", "#999999", "#E78AC3", "#B3CDE3", "#CCCCCC", "#E31A1C", "#FB9A99", "#E6AB02","#66A61E",  "#B3DE69", "#A6CEE3", "#1B9E77", "#7FC97F", "#F0027F", "#FF7F00", "#CCEBC5", "#A65628","#FFFFCC", "#666666")

#plot bar chart with filled phyla RELATIVE
(asrg.phyla.barREL <- ggplot(data.taxREL, aes(x = Gene, y = Rel, fill = Phylum, color = Phylum)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = color) +
    scale_color_manual(values = color) +
    ylab("Count proportion (number per genome)") +
    xlab("Gene") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.barREL, filename = paste(wd, "/figures/numberhits.geneREL.eps", sep = ""), width = 10)

#join phy count information with data.tax
data.tax.sum <- data.taxREL %>%
  ungroup() %>%
  group_by(Gene, Phylum) %>%
  summarise(gene.count = length(Gene))

#plot bar chart with filled phyla (+/- gene)
(asrg.phyla.bar <- ggplot(data = data.tax.sum, aes(x = Gene, fill = Phylum, y = gene.count)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = color) +
    ylab("Number of genomes") +
    xlab("Gene") +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.bar, filename = paste(wd, "/figures/hits.gene.png", sep = ""), width = 10)

#plot bar chart with filled phyla (+/- gene)
data.taxREL.PA <- data.tax.sum %>%
  group_by(Gene, Phylum) %>%
  #summarise(Count = length(Gene)) %>%
  mutate(RelCount = gene.count / length(unique(data.taxREL$`RefSoil ID`)))

(asrg.logi.phyla.barREL <- ggplot(data.taxREL.PA, aes(x = Gene, y = RelCount, fill = Phylum)) +
    geom_bar(stat = "identity") +
    ylab("Proportion of genomes containing gene") +
    xlab("Gene") +
    scale_fill_manual(values = color) +
    theme_bw(base_size = 10) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.logi.phyla.barREL, filename = paste(wd, "/figures/PA.geneREL.eps", sep = ""), width = 8, height = 4)

#genomes from Refsoil
ncbi.sum <- ncbi %>%
  distinct(`RefSoil ID`, .keep_all = TRUE) %>%
  group_by(Phylum) %>%
  summarise(phy.n = length(Phylum)) %>%
  mutate(RefSoil = "RefSoil")

#plot RefSoil database phylum-level distribution
(refsoil.tot <- ggplot(ncbi.sum, aes(x = RefSoil, 
                                     y = phy.n/922)) +
  geom_bar(stat = "identity", aes(fill = Phylum)) +
  scale_fill_manual(values = color) +
  theme_bw(base_size = 10) +
  ylab("Proportion of Genomes") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(refsoil.tot, filename = paste(wd, "/figures/RefSoil.comp.eps", sep = ""), width = 4.5, height = 4)

#######################################################
#HOW MANY COPIES OF ASRGS ARE PRESENT IN SOIL GENOMES?#
#######################################################
data.sum <- data.tax %>%
  group_by(Phylum,`RefSoil ID`, Gene) %>%
  summarise(Gene.count = length(Gene))

(gene.hist <- ggplot(subset(data.sum, Gene !="None"), aes(x = Gene.count)) +
  geom_bar(fill = "black") +
  facet_wrap(~Gene, scales = "free_y") +
  scale_x_continuous(breaks = c(1,3,5,7,9,11)) +
  ylab("Number of genomes") +
  xlab("Number of gene copies") +
  theme_bw(base_size = 12))

#save plot
ggsave(gene.hist, filename = paste(wd, "/figures/gene.historgram.eps", sep = ""), width = 5.5, height = 4, units = "in")

############################
#EXTRACT GENE INFO FOR iTOL#
############################

#read in iTOL labels
itol <- read_delim(paste(wd, "/phylogenetic_analysis/labels_final.txt", sep = ""), delim = ",", col_names = c("NCBI.ID", "Name"), skip = 4)

#summarise by RefSoil ID (ie join chromosome and plasmid info)
data.sum.ncbi <- data.taxREL %>%
  group_by(Phylum,`RefSoil ID`, Gene) %>%
  select(Phylum,`RefSoil ID`, Gene, chromosome, plasmid) %>%
  melt(id.vars = c("RefSoil ID", "Phylum", "Gene"), variable.name = "Element", value.name = "Gene.count") %>%
  dcast(`RefSoil ID` ~ Gene+Element, value.var = "Gene.count")

#get refsoil ids for all itol leaves
ncbi.itol <- ncbi.tidy[ncbi.tidy$NCBI.ID %in% itol$NCBI.ID,]

itol.annotated <- itol %>%
  left_join(ncbi.itol, by = "NCBI.ID") %>%
  left_join(data.sum.ncbi, by = "RefSoil ID")

#summarise for table export to go along with tree
itol.phy.summary <- itol.annotated %>%
  group_by(Phylum) %>%
  summarise(phy.n = length(Phylum))

itol.summary <- itol.annotated %>%
  left_join(itol.phy.summary, by = "Phylum") %>%
  select(Phylum, phy.n, acr3_chromosome:None_plasmid) %>%
  melt(id.vars = c("Phylum", "phy.n")) %>%
  mutate(value = ifelse(is.na(value), 0, value),
         value= ifelse(value > 0, 1, value)) %>%
  group_by(Phylum, phy.n, variable) %>%
  summarise(Total = sum(value)) %>%
  ungroup() %>%
  mutate(Proportion = Total/phy.n * 100,
         Phylum = paste(Phylum, " (", phy.n, ")", sep = "")) %>%
  dcast(Phylum ~ variable) 

write.table(itol.summary, file = paste(wd, "/output/itol_summary.csv", sep = ""), quote = FALSE, sep = ",", col.names = TRUE, row.names = FALSE)

#extract chromosome PA for iTOL
itol.annotated.shapes <- itol.annotated
itol.annotated.shapes[,c(8:27)][itol.annotated.shapes[,c(8:27)] > 0] <- 1
itol.annotated.shapes[,c(8:27)][is.na(itol.annotated.shapes[,c(8:27)])] <- 0

#save chromosome info as output
write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, arsB_chromosome, acr3_chromosome, arsD_chromosome, arsC_glut_chromosome, arsC_thio_chromosome, arsM_chromosome, aioA_chromosome, arxA_chromosome, arrA_chromosome)), paste(wd, "/output/iTOL_chromosome.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

#individually save plasmid outputs
write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, arsB_plasmid), subset = arsB_plasmid > 0), paste(wd, "/output/iTOL_arsB_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, acr3_plasmid), subset = acr3_plasmid >0), paste(wd, "/output/iTOL_acr3_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, arsC_glut_plasmid), subset = arsC_glut_plasmid >0), paste(wd, "/output/iTOL_arsC_glut_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, arsC_thio_plasmid), subset = arsC_thio_plasmid >0), paste(wd, "/output/iTOL_arsC_thio_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, arsM_plasmid), subset = arsM_plasmid >0), paste(wd, "/output/iTOL_arsM_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, aioA_plasmid), subset = aioA_plasmid >0), paste(wd, "/output/iTOL_aioA_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

write.table(subset(itol.annotated.shapes, select = c(NCBI.ID, arsD_plasmid), subset = arsD_plasmid >0), paste(wd, "/output/iTOL_arsD_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")


#read in phylum colors
colors.phy <- read_delim(paste(wd, "/data/colors_phylum.txt", sep = ""), delim = "\t", col_names = c("Color", "Phylum"))

#make itol dataframe for leaf colors
itol.annotated.color <- itol.annotated %>%
  select(-c(Contains.plasmid:None_plasmid)) %>%
  left_join(data.tax, by = "RefSoil ID") %>%
  select(NCBI.ID.x, Phylum.x) %>%
  rename(Phylum = Phylum.x) %>%
  left_join(colors.phy, by = "Phylum") %>%
  mutate(Type = "label",
         outside = -1, 
         font = "normal",
         size = 1)
  
#save as output (clade color)
write.table(subset(itol.annotated.color, select = c(NCBI.ID.x,Type,Color)), paste(wd, "/output/iTOL_node_color.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

#save as output (branch color)
write.table(subset(itol.annotated.color, select = c(NCBI.ID.x,Color,Phylum)), paste(wd, "/output/iTOL_branch_color.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

#save as output (outside label & color)
write.table(subset(itol.annotated.color, select = c(NCBI.ID.x,Phylum, outside,Color, font,size)), paste(wd, "/output/iTOL_branch_label_color.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

##################################
#SET UP GENE-SPECIFIC PHYLOGENIES#
##################################

#select labels
AsRG.labels <- data.tax %>%
  ungroup() %>%
  left_join(ncbi, by = c("RefSoil ID", "Taxon ID", "Phylum")) %>%
  select(Gene, t.name, Organism) %>%
  mutate(Organism = paste(Organism, " (", t.name, ")", sep = ""))

dissim <- c("arxA", "arrA", "aioA")

#write file with labels for each gene
write.table(subset(AsRG.labels, Gene == "arsD", select = c(t.name, Organism)), file = paste(wd, "/output/arsD.labels.txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = ",")

#get label colors for all genes  
AsRG.color <- data.tax %>%
  ungroup() %>%
  left_join(colors.phy, by = "Phylum") %>%
  mutate(label = "label") %>%
  select(Gene, t.name, label, Color) 

#save each gene as output
write.table(subset(AsRG.color, Gene %in% dissim, select = c(t.name, label, Color)), paste(wd, "/output/iTOL_dissim_node_color.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

#make plasmid/genome denotation for iTOL
#AsRG trees
location <- data.tax %>%
  ungroup() %>%
  select(Gene, t.name, Source) %>%
  mutate(Source = ifelse(Source == "NCBI.ID", -1, 0))

#save each gene as output
write.table(subset(location, select = c(t.name, Source)), paste(wd, "/output/iTOL_gene_plasmid.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

####################
#Soil type analysis#
####################

#read in data
type <- read_delim(paste(wd, "/data/ismej2016168x12_soiltype.csv", sep = ""), delim = ",", n_max = 381)

#tidy type data
type.tidy <- type %>%
  separate(`RefSoil ID`, into = c("R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15", "R16", "R17", "R18", "R19", "R20", "R21", "R22", "R23", "R24", "R25", "R26", "R27", "R28", "R29", "R30", "R31", "R32", "R33", "R34", "R35", "R36", "R37", "R38", "R39", "R40", "R41", "R42", "R43"), sep = ",") %>%
  melt(id.vars = c("OTU ID in (Rideout et al., 2014)", "Phylum", "Andisols", "Gelisols", "Vertisols", "Mollisols", "Inceptisols","Alfisols","Ultisols","Sand,Rock,Ice","Entisols"), value.name = "RefSoil ID", na.rm = TRUE) %>%
  select(-variable)

#join tidy data with AsRG data
type.ars <- data.taxREL %>%
  select(`RefSoil ID`, Gene, Total) %>%
  dcast(`RefSoil ID` ~ Gene, value.var = "Total") %>%
  select(-None)  %>%
  replace(is.na(.), 0) %>%
  inner_join(type.tidy, by = "RefSoil ID")

#calculate AsRG abundance
type.ars.abund <- type.ars %>%
  mutate(acr3_Andisols = acr3 * Andisols,
         aioA_Andisols = aioA * Andisols,
         arrA_Andisols = arrA * Andisols,
         arsB_Andisols = arsB * Andisols,
         arsD_Andisols = arsD * Andisols,
         arsC_glut_Andisols = arsC_glut * Andisols,
         arsC_thio_Andisols = arsC_thio * Andisols,
         arsM_Andisols = arsM * Andisols,
         arxA_Andisols = arxA * Andisols,
         acr3_Gelisols = acr3 * Gelisols,
         arsD_Gelisols = arsD * Gelisols,
         aioA_Gelisols = aioA * Gelisols,
         arrA_Gelisols = arrA * Gelisols,
         arsB_Gelisols = arsB * Gelisols,
         arsC_glut_Gelisols = arsC_glut * Gelisols,
         arsC_thio_Gelisols = arsC_thio * Gelisols,
         arsM_Gelisols = arsM * Gelisols,
         arxA_Gelisols = arxA * Gelisols,
         acr3_Vertisols = acr3 * Vertisols,
         aioA_Vertisols = aioA * Vertisols,
         arrA_Vertisols = arrA * Vertisols,
         arsB_Vertisols = arsB * Vertisols,
         arsD_Vertisols = arsD * Vertisols,
         arsC_glut_Vertisols = arsC_glut * Vertisols,
         arsC_thio_Vertisols = arsC_thio * Vertisols,
         arsM_Vertisols = arsM * Vertisols,
         arxA_Vertisols = arxA * Vertisols,
         acr3_Mollisols = acr3 * Mollisols,
         aioA_Mollisols = aioA * Mollisols,
         arrA_Mollisols = arrA * Mollisols,
         arsB_Mollisols = arsB * Mollisols,
         arsD_Mollisols = arsD * Mollisols,
         arsC_glut_Mollisols = arsC_glut * Mollisols,
         arsC_thio_Mollisols = arsC_thio * Mollisols,
         arsM_Mollisols = arsM * Mollisols,
         arxA_Mollisols = arxA * Mollisols,
         acr3_Inceptisols = acr3 * Inceptisols,
         aioA_Inceptisols = aioA * Inceptisols,
         arrA_Inceptisols = arrA * Inceptisols,
         arsB_Inceptisols = arsB * Inceptisols,
         arsD_Inceptisols = arsD * Inceptisols,
         arsC_glut_Inceptisols = arsC_glut * Inceptisols,
         arsC_thio_Inceptisols = arsC_thio * Inceptisols,
         arsM_Inceptisols = arsM * Inceptisols,
         arxA_Inceptisols = arxA * Inceptisols,
         acr3_Alfisols = acr3 * Alfisols,
         aioA_Alfisols = aioA * Alfisols,
         arrA_Alfisols = arrA * Alfisols,
         arsB_Alfisols = arsB * Alfisols,
         arsD_Alfisols = arsD * Alfisols,
         arsC_glut_Alfisols = arsC_glut * Alfisols,
         arsC_thio_Alfisols = arsC_thio * Alfisols,
         arsM_Alfisols = arsM * Alfisols,
         arxA_Alfisols = arxA * Alfisols,
         acr3_Ultisols = acr3 * Ultisols,
         aioA_Ultisols = aioA * Ultisols,
         arrA_Ultisols = arrA * Ultisols,
         arsB_Ultisols = arsB * Ultisols,
         arsD_Ultisols = arsD * Ultisols,
         arsC_glut_Ultisols = arsC_glut * Ultisols,
         arsC_thio_Ultisols = arsC_thio * Ultisols,
         arsM_Ultisols = arsM * Ultisols,
         arxA_Ultisols = arxA * Ultisols,
         `acr3_Sand,Rock,Ice` = acr3 * `Sand,Rock,Ice`,
         `aioA_Sand,Rock,Ice` = aioA * `Sand,Rock,Ice`,
         `arrA_Sand,Rock,Ice` = arrA * `Sand,Rock,Ice`,
         `arsB_Sand,Rock,Ice` = arsB * `Sand,Rock,Ice`,
         `arsD_Sand,Rock,Ice` = arsD * `Sand,Rock,Ice`,
         `arsC_glut_Sand,Rock,Ice` = arsC_glut *`Sand,Rock,Ice`,
         `arsC_thio_Sand,Rock,Ice` = arsC_thio *`Sand,Rock,Ice`,
         `arsM_Sand,Rock,Ice` = arsM *`Sand,Rock,Ice`,
         `arxA_Sand,Rock,Ice` = arxA *`Sand,Rock,Ice`,
         acr3_Entisols = acr3 * Entisols,
         aioA_Entisols = aioA * Entisols,
         arrA_Entisols = arrA * Entisols,
         arsB_Entisols = arsB * Entisols,
         arsD_Entisols = arsD * Entisols,
         arsC_glut_Entisols = arsC_glut * Entisols,
         arsC_thio_Entisols = arsC_thio * Entisols,
         arsM_Entisols = arsM * Entisols,
         arxA_Entisols = arxA * Entisols) %>%
  select(`RefSoil ID`, `OTU ID in (Rideout et al., 2014)`, acr3_Andisols:arxA_Entisols, Phylum) %>%
  group_by(`OTU ID in (Rideout et al., 2014)`, Phylum) %>%
  summarise_each(funs(mean) , acr3_Andisols:arxA_Entisols) %>%
  melt(id.vars = c("OTU ID in (Rideout et al., 2014)", "Phylum"), variable.name = "Content", value.name = "Mean") %>%
  mutate(Content = gsub("arsC_glut", "arsC (grx)", Content),
         Content = gsub("arsC_thio", "arsC (trx)", Content)) %>%
  separate(Content, into = c("Gene", "SoilType"), sep = "_")

#normalize data to total abundance in site
site.total <-  data.frame(colSums(type[,c(4:12)]))

#tidy
site.total <- site.total %>%
  rename(SiteTotal = colSums.type...c.4.12...) %>%
  rownames_to_column(var = "SoilType")

#join site total with AsRG abund info 
#and normalize
type.ars.abund.norm <- type.ars.abund %>%
  left_join(site.total, by = "SoilType") %>%
  mutate(NormMean = Mean/SiteTotal,
         Gene = factor(Gene, levels = c("acr3", "arsB","arsD", "arsC (grx)", "arsC (trx)", "arsM", "aioA", "arxA", "arrA")
)) %>%
  group_by(Gene, SoilType) %>%
  summarise(Total = sum(NormMean))

#plot AsRG content by soil type
(soil.type <- ggplot(type.ars.abund.norm, aes(x = Gene, y = Total)) +
  geom_boxplot() +
  geom_jitter(aes(color = SoilType), height = 0, width = 0.1) + 
  scale_color_brewer(palette = "Set1") +
  theme_bw(base_size = 10) +
  ylab("Mean normalized abundance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)))

ggsave(soil.type, filename = paste(wd, "/figures/abund.soil.type.eps", sep = ""))
write.table(type.ars.abund.norm, file = "output/refsoil_abundance.txt", quote = FALSE, sep = "\t", row.names = FALSE)

#calculate stats

refsoil_wilcox <- tidy(pairwise.wilcox.test( type.ars.abund.norm$Total, type.ars.abund.norm$Gene, p.adjust.method = "fdr"))

groups <- read.delim("../../gene_targeted_assembly/metagenome_analysis/data/detox_metab.txt", sep = "\t")
groups <- groups %>%
  mutate(Gene = gsub("_glut", " (grx)", Gene),
         Gene = gsub("_thio", " (trx)", Gene))

type.ars.abund.norm2 <- type.ars.abund.norm %>%
  ungroup() %>%
  mutate(Gene = as.character(Gene)) %>%
  left_join(groups, by = "Gene")

wilcox.test(type.ars.abund.norm2$Total~type.ars.abund.norm2$Category, alternative = "greater")

################################
#CALCULATE PHYLOGENETIC SIGNALS#
################################
library(ape)
library(picante)

#read in 16S phylogeny
tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.refsoil_bac_arch_16s_RAxML_GTRCAT.nwk", sep = ""))
tree.f <- multi2di(tree)

#prep tree labels
tree.data <- data.frame("NCBI.ID" = tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  mutate(order = as.numeric(order))

#add gene information
tree.data.annotated <- itol.annotated %>%
  left_join(tree.data, by = "NCBI.ID") %>%
  arrange(order) %>%
  column_to_rownames("NCBI.ID") %>%
  select(-c(Name:Source, order, arsB_plasmid, arrA_plasmid, arxA_plasmid, None_chromosome, None_plasmid))
tree.data.annotated <- data.frame(tree.data.annotated)

#convert to presence absence
tree.data.annotated[tree.data.annotated > 0] <- 1

#replace NA with zero since we are confident in P/A
tree.data.annotated[is.na(tree.data.annotated)] <- 0

#test phylogenetic signal
phy.signal <- multiPhylosignal(x = tree.data.annotated, phy = tree.f, reps = 999)

#fdr adjust p values
phy.signal$p.adjust <- p.adjust(phy.signal$PIC.variance.P, method = "fdr")

#############################################################
#EXPORT TREES WITH LABEL CHANGES FOR PHYLOGENETIC CONGRUENCE#
#############################################################
library(phytools)

#read 16s tree
tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.refsoil_bac_arch_16s_RAxML_GTRCAT.nwk", sep = ""))

#prep 16S
phylo.labels <- data.frame("NCBI.ID" = tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  left_join(ncbi.tidy, by = "NCBI.ID") 

tree$tip.label[tree$tip.label %in% phylo.labels$NCBI.ID] <- phylo.labels$`RefSoil ID`

write.tree(tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/16S_refsoil.nwk", sep = ""))

path.dist(arsM.tree, tree)

#arsM
arsM.tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.arsM_refsoil_RAxML_PROTGAMMAWAG.nwk", sep = ""))

arsM.labels <- data.frame(arsM.tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  rename(t.name = arsM.tree.tip.label) %>%
  left_join(data.tax, by = "t.name")

arsM.tree$tip.label[arsM.tree$tip.label %in% arsM.labels$t.name] <- arsM.labels$`RefSoil ID`

write.tree(arsM.tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/arsM_refsoil.nwk", sep = ""))

#arsD
arsD.tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.arsD_refsoil_RAxML_PROTGAMMAWAG.nwk", sep = ""))

arsD.labels <- data.frame(arsD.tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  rename(t.name = arsD.tree.tip.label) %>%
  left_join(data.tax, by = "t.name")

arsD.tree$tip.label[arsD.tree$tip.label %in% arsD.labels$t.name] <- arsD.labels$`RefSoil ID`

write.tree(arsD.tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/arsD_refsoil.nwk", sep = ""))

#arsC_thio
arsC_thio.tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.arsC_thio_refsoil_RAxML_PROTGAMMAWAG.nwk", sep = ""))

arsC_thio.labels <- data.frame(arsC_thio.tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  rename(t.name = arsC_thio.tree.tip.label) %>%
  left_join(data.tax, by = "t.name")

arsC_thio.tree$tip.label[arsC_thio.tree$tip.label %in% arsC_thio.labels$t.name] <- arsC_thio.labels$`RefSoil ID`

write.tree(arsC_thio.tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/arsC_thio_refsoil.nwk", sep = ""))

#arsC_glut
arsC_glut.tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.arsC_glut_refsoil_RAxML_PROTGAMMAWAG.nwk", sep = ""))

arsC_glut.labels <- data.frame(arsC_glut.tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  rename(t.name = arsC_glut.tree.tip.label) %>%
  left_join(data.tax, by = "t.name")

arsC_glut.tree$tip.label[arsC_glut.tree$tip.label %in% arsC_glut.labels$t.name] <- arsC_glut.labels$`RefSoil ID`

write.tree(arsC_glut.tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/arsC_glut_refsoil.nwk", sep = ""))

#arsB
arsB.tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.arsB_refsoil_RAxML_PROTGAMMAWAG.nwk", sep = ""))

arsB.labels <- data.frame(arsB.tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  rename(t.name = arsB.tree.tip.label) %>%
  left_join(data.tax, by = "t.name")

arsB.tree$tip.label[arsB.tree$tip.label %in% arsB.labels$t.name] <- arsB.labels$`RefSoil ID`

write.tree(arsB.tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/arsB_refsoil.nwk", sep = ""))

#acr3
acr3.tree <- read.tree(paste(wd, "/phylogenetic_analysis/RAxML_bipartitionsBranchLabels.acr3_refsoil_RAxML_PROTGAMMAWAG.nwk", sep = ""))

acr3.labels <- data.frame(acr3.tree$tip.label) %>%
  rownames_to_column(var = "order") %>%
  rename(t.name = acr3.tree.tip.label) %>%
  left_join(data.tax, by = "t.name")

acr3.tree$tip.label[acr3.tree$tip.label %in% acr3.labels$t.name] <- acr3.labels$`RefSoil ID`

write.tree(acr3.tree, file = paste(wd, "/phylogenetic_analysis/refsoil_labels/acr3_refsoil.nwk", sep = ""))
