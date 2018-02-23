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
ncbi <- ncbi %>%
  separate(col = NCBI.ID, into = c("NCBI.ID", "NCBI.ID2", "NCBI.ID3"), sep = ",") %>%
  mutate(Contains.plasmid = !is.na(Plasmid.ID)) %>%
  separate(col = Plasmid.ID, into = c("plasmid1", "plasmid2","plasmid3","plasmid4","plasmid5","plasmid6","plasmid7","plasmid8","plasmid9","plasmid10","plasmid11","plasmid12","plasmid13","plasmid14"), sep = ",") %>%
  mutate(NCBI.ID = gsub("\\..*","",NCBI.ID),
         NCBI.ID2 = gsub("\\..*","",NCBI.ID2),
         NCBI.ID3 = gsub("\\..*","",NCBI.ID3)) %>%
  select(`RefSoil ID`, `Taxon ID`, Phylum, Contains.plasmid, NCBI.ID, NCBI.ID2, NCBI.ID3, plasmid1:plasmid14) %>%
  melt(id = c("RefSoil ID", "Taxon ID", "Phylum", "Contains.plasmid"), variable.name = "Source", value.name = "NCBI.ID")


#remove all rows where value = NA
ncbi <- ncbi[!is.na(ncbi$NCBI.ID),]

#join AsRG data with RefSoi IDs
data.tax <- ncbi %>%
  group_by(`RefSoil ID`) %>%
  mutate(Elements = length(`RefSoil ID`)) %>%
  left_join(data, by = "NCBI.ID")

#change NA gene to "None"
data.tax$Gene[is.na(data.tax$Gene)] <- "None"

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
 
#plot bar chart with filled phyla RELATIVE
(asrg.phyla.barREL <- ggplot(data.taxREL, aes(x = Gene, y = Rel)) +
    geom_bar(stat = "identity", color = "black", fill = "grey49") +
    ylab("Count proportion (number per genome)") +
    xlab("Gene") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.barREL, filename = paste(wd, "/figures/numberhits.geneREL.png", sep = ""), width = 10)

#join phy count information with data.tax
data.tax.sum <- data.taxREL %>%
  ungroup() %>%
  group_by(Gene, Phylum) %>%
  summarise(gene.count = length(Gene))
  
#make color scheme
#n <- 25
#qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
#col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
#phy.color <- print(sample(col_vector, n))
color <- c("#FDB462", "#F4CAE4", "#DECBE4", "#6A3D9A", "black", "#B15928", "#1F78B4", "#999999", "#E78AC3", "#B3CDE3", "#CCCCCC", "#E31A1C", "#FB9A99", "#E6AB02","#66A61E",  "#B3DE69", "#A6CEE3", "#1B9E77", "#7FC97F", "#F0027F", "#FF7F00", "#CCEBC5", "#A65628","#FFFFCC", "#666666")

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

(asrg.logi.phyla.barREL <- ggplot(data.taxREL.PA, aes(x = Gene, y = RelCount)) +
    geom_bar(stat = "identity") +
    ylab("Proportion of genomes containing gene") +
    xlab("Gene") +
    #scale_fill_manual(values = color) +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.logi.phyla.barREL, filename = paste(wd, "/figures/PA.geneREL_grey.eps", sep = ""), width = 6.4, height = 4.3)


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
  theme_bw(base_size = 12) +
  ylab("Proportion of Genomes") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(refsoil.tot, filename = paste(wd, "/figures/RefSoil.comp.eps", sep = ""), width = 5)

#######################################################
#HOW MANY COPIES OF ASRGS ARE PRESENT IN SOIL GENOMES?#
#######################################################
data.sum <- data.tax %>%
  group_by(Phylum,`RefSoil ID`, Gene) %>%
  summarise(Gene.count = length(Gene))

(gene.hist <- ggplot(subset(data.sum, Gene !="None"), aes(x = Gene.count, fill = Gene)) +
  geom_bar(color = "black") +
  facet_wrap(~Gene, scales = "free_y") +
  scale_fill_brewer(palette = "Set3") +
  scale_x_continuous(breaks = c(1,3,5,7,9,11)) +
  ylab("Number of genomes") +
  xlab("Number of gene copies") +
  theme_bw(base_size = 12))

#save plot
ggsave(gene.hist, filename = paste(wd, "/figures/gene.historgram.eps", sep = ""), width = 10)

#####################################################
#WHAT IS THE CO-OCCURRENCE OF AsRGs IN SOIL GENOMES?#
#####################################################
library(qgraph)

#make matrix of information
data.tax.sum <- data.tax %>%
  group_by(Gene, Phylum, `RefSoil ID`) %>%
  summarise(Occurrence = (length(Gene) > 0)*1)

#cast data
data.tax.cast <- dcast(data.tax.sum, `RefSoil ID`~Gene+Phylum, value.var = "Occurrence")
rownames(data.tax.cast) <- data.tax.cast$`RefSoil ID`
data.tax.cast[is.na(data.tax.cast)] = 0
data.tax.cast <- data.tax.cast[,-1]

#remove all columns (RefSoil genomes) with only one gene
#data.tax.cast.2 <- data.tax.cast[which(colSums(data.tax.cast) > 0),]

#test pairwise correlations
data.tax.corr <- corr.test(data.tax.cast, method = "spearman", adjust = "fdr", alpha = 0.01)

#label shapes
#shape = c(rep("circle", 17), rep("square", 4), rep("star", 9), rep("circle", 13), rep("triangle", 23), rep("star", 6), rep("diamond", 12), "square", rep("heart", 11))

#make network of AsRGs
data.tax.corr$r <- ifelse(data.tax.corr$r<0,0,data.tax.corr$r)

qgraph(data.tax.corr$r, minimum = "sig", graph = "cor", sampleSize = 922, alpha = 0.05, layout = "spring",  threshold = "fdr",  labels = rownames(data.tax.cast$r), posCol = "black", negCol = "red", label.cex = 0.5, label.scale = FALSE, fade = FALSE,  vsize = log(colSums(data.tax.cast)+1), node.width = 1, node.height = 1, width = 7, height = 5, border.color = "grey30")

############################
#EXTRACT GENE INFO FOR iTOL#
############################

#read in iTOL labels
itol <- read_delim(paste(wd, "/iTOL_labels.txt", sep = ""), delim = ",", col_names = c("NCBI.ID", "Name"))

#summarise by RefSoil ID (ie join chromosome and plasmid info)
data.sum.ncbi <- data.taxREL %>%
  group_by(Phylum,`RefSoil ID`, Gene) %>%
  select(Phylum,`RefSoil ID`, Gene, chromosome, plasmid) %>%
  melt(id.vars = c("RefSoil ID", "Phylum", "Gene"), variable.name = "Element", value.name = "Gene.count") %>%
  dcast(`RefSoil ID` ~ Gene+Element, value.var = "Gene.count")

#get refsoil ids for all itol leaves
ncbi.itol <- ncbi[ncbi$NCBI.ID %in% itol$NCBI.ID,]

itol.annotated <- itol %>%
  left_join(ncbi.itol, by = "NCBI.ID") %>%
  left_join(data.sum.ncbi, by = "RefSoil ID")

#replace values for iTOL
#0 = open shape, 1 = closed shape; -1 = nothing
#closed shapes
itol.annotated$acr3_chromosome <- replace(itol.annotated$acr3_chromosome, itol.annotated$acr3_chromosome > 0, 1)
itol.annotated$arsC_thio_chromosome <- replace(itol.annotated$arsC_thio_chromosome, itol.annotated$arsC_thio_chromosome > 0, 1)
itol.annotated$aioA_chromosome <- replace(itol.annotated$aioA_chromosome, itol.annotated$aioA_chromosome > 0, 1)
itol.annotated$arsB_chromosome <- replace(itol.annotated$arsB_chromosome, itol.annotated$arsB_chromosome > 0, 1)
itol.annotated$arsM_chromosome <- replace(itol.annotated$arsM_chromosome, itol.annotated$arsM_chromosome > 0, 1)
itol.annotated$arxA_chromosome <- replace(itol.annotated$arxA_chromosome, itol.annotated$arxA_chromosome > 0, 1)
itol.annotated$arsC_glut_chromosome <- replace(itol.annotated$arsC_glut_chromosome, itol.annotated$arsC_glut_chromosome > 0, 1)
itol.annotated$arrA_chromosome <- replace(itol.annotated$arrA_chromosome, itol.annotated$arrA_chromosome > 0, 1)

#make all zeros -1
itol.annotated[is.na(itol.annotated)] <- -1
itol.annotated[itol.annotated==0]<- -1

#make plasmids open shapes
itol.annotated$acr3_plasmid <- replace(itol.annotated$acr3_plasmid, itol.annotated$acr3_plasmid > 0, 0)
itol.annotated$arsC_thio_plasmid <- replace(itol.annotated$arsC_thio_plasmid, itol.annotated$arsC_thio_plasmid > 0, 0)
itol.annotated$aioA_plasmid <- replace(itol.annotated$aioA_plasmid, itol.annotated$aioA_plasmid > 0, 0)
itol.annotated$arsB_plasmid <- replace(itol.annotated$arsB_plasmid, itol.annotated$arsB_plasmid > 0, 0)
itol.annotated$arsM_plasmid <- replace(itol.annotated$arsM_plasmid, itol.annotated$arsM_plasmid > 0, 0)
itol.annotated$arxA_plasmid <- replace(itol.annotated$arxA_plasmid, itol.annotated$arxA_plasmid > 0, 0)
itol.annotated$arsC_glut_plasmid <- replace(itol.annotated$arsC_glut_plasmid, itol.annotated$arsC_glut_plasmid > 0, 0)
itol.annotated$arrA_plasmid <- replace(itol.annotated$arrA_plasmid, itol.annotated$arrA_plasmid > 0, 0)

itol.annotated.shapes <- itol.annotated %>%
  select(NCBI.ID, arsB_chromosome, acr3_chromosome, arsC_glut_chromosome, arsC_thio_chromosome, arsM_chromosome, aioA_chromosome, arxA_chromosome, arrA_chromosome,arsB_plasmid, acr3_plasmid, arsC_glut_plasmid, arsC_thio_plasmid, arsM_plasmid, aioA_plasmid, arxA_plasmid, arrA_plasmid)

#save as output
write.table(itol.annotated.shapes, paste(wd, "/output/iTOL_shapes.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

#read in phylum colors
colors.phy <- read_delim(paste(wd, "/data/colors_phylum.txt", sep = ""), delim = "\t", col_names = c("Color", "Phylum"))

#make itol dataframe for leaf colors
itol.annotated.color <- itol.annotated %>%
  select(-c(Contains.plasmid:None_plasmid)) %>%
  left_join(data.tax, by = "RefSoil ID") %>%
  select(NCBI.ID.x, Phylum.x) %>%
  rename(Phylum = Phylum.x) %>%
  left_join(colors.phy, by = "Phylum") %>%
  mutate(Type = "label") %>%
  select(NCBI.ID.x,Type,Color)
  
#save as output
write.table(itol.annotated.color, paste(wd, "/output/iTOL_node_color.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

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
         arsC_glut_Andisols = arsC_glut * Andisols,
         arsC_thio_Andisols = arsC_thio * Andisols,
         arsM_Andisols = arsM * Andisols,
         arxA_Andisols = arxA * Andisols,
         acr3_Gelisols = acr3 * Gelisols,
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
         arsC_glut_Vertisols = arsC_glut * Vertisols,
         arsC_thio_Vertisols = arsC_thio * Vertisols,
         arsM_Vertisols = arsM * Vertisols,
         arxA_Vertisols = arxA * Vertisols,
         acr3_Mollisols = acr3 * Mollisols,
         aioA_Mollisols = aioA * Mollisols,
         arrA_Mollisols = arrA * Mollisols,
         arsB_Mollisols = arsB * Mollisols,
         arsC_glut_Mollisols = arsC_glut * Mollisols,
         arsC_thio_Mollisols = arsC_thio * Mollisols,
         arsM_Mollisols = arsM * Mollisols,
         arxA_Mollisols = arxA * Mollisols,
         acr3_Inceptisols = acr3 * Inceptisols,
         aioA_Inceptisols = aioA * Inceptisols,
         arrA_Inceptisols = arrA * Inceptisols,
         arsB_Inceptisols = arsB * Inceptisols,
         arsC_glut_Inceptisols = arsC_glut * Inceptisols,
         arsC_thio_Inceptisols = arsC_thio * Inceptisols,
         arsM_Inceptisols = arsM * Inceptisols,
         arxA_Inceptisols = arxA * Inceptisols,
         acr3_Alfisols = acr3 * Alfisols,
         aioA_Alfisols = aioA * Alfisols,
         arrA_Alfisols = arrA * Alfisols,
         arsB_Alfisols = arsB * Alfisols,
         arsC_glut_Alfisols = arsC_glut * Alfisols,
         arsC_thio_Alfisols = arsC_thio * Alfisols,
         arsM_Alfisols = arsM * Alfisols,
         arxA_Alfisols = arxA * Alfisols,
         acr3_Ultisols = acr3 * Ultisols,
         aioA_Ultisols = aioA * Ultisols,
         arrA_Ultisols = arrA * Ultisols,
         arsB_Ultisols = arsB * Ultisols,
         arsC_glut_Ultisols = arsC_glut * Ultisols,
         arsC_thio_Ultisols = arsC_thio * Ultisols,
         arsM_Ultisols = arsM * Ultisols,
         arxA_Ultisols = arxA * Ultisols,
         `acr3_Sand,Rock,Ice` = acr3 * `Sand,Rock,Ice`,
         `aioA_Sand,Rock,Ice` = aioA * `Sand,Rock,Ice`,
         `arrA_Sand,Rock,Ice` = arrA * `Sand,Rock,Ice`,
         `arsB_Sand,Rock,Ice` = arsB * `Sand,Rock,Ice`,
         `arsC_glut_Sand,Rock,Ice` = arsC_glut *`Sand,Rock,Ice`,
         `arsC_thio_Sand,Rock,Ice` = arsC_thio *`Sand,Rock,Ice`,
         `arsM_Sand,Rock,Ice` = arsM *`Sand,Rock,Ice`,
         `arxA_Sand,Rock,Ice` = arxA *`Sand,Rock,Ice`,
         acr3_Entisols = acr3 * Entisols,
         aioA_Entisols = aioA * Entisols,
         arrA_Entisols = arrA * Entisols,
         arsB_Entisols = arsB * Entisols,
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
         Gene = factor(Gene, levels = c("arsB", "acr3", "arsC (grx)", "arsC (trx)", "arsM", "aioA", "arxA", "arrA")
))

#plot AsRG content by soil type
ggplot(type.ars.abund.norm, aes(x = Gene, y = NormMean, fill = Phylum)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~ SoilType) +
  scale_fill_manual(values = color) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
