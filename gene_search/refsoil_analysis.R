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

#arxA must have a score > 1000 so it doesnt
#pick up thiosulfate reductases
data <- data[-which(data$Gene == "arxA" & data$score1 < 1000),]

#remove plasmid data
#this will be added back later
plasmid <- data[which(data$Sample == "refseq.plasmid2.fa"),]
data <- data[-which(data$Sample == "refseq.plasmid2.fa"),]

#read in taxanomic information
ncbi <- read_delim(file = paste(wd, "/data/ismej2016168x6.csv", sep = ""), delim = ",")

#separate out extra NCBI ID's and
#remove version number on NCBI ID (.##)
ncbi <- ncbi %>%
  separate(col = NCBI.ID, into = c("NCBI.ID", "NCBI.ID2", "NCBI.ID3"), sep = ",") %>%
  separate(col = NCBI.ID, into = c("NCBI.ID", "Vs"), sep = -3) %>%
  separate(col = NCBI.ID2, into = c("NCBI.ID2", "Vs2"), sep = -3) %>%
  separate(col = NCBI.ID3, into = c("NCBI.ID3", "Vs3"), sep = -3) 

#join AsRG information with taxanomic data that match NCBI.ID #1, 2, 3
data.tax.ncbi1 <- ncbi %>%
  inner_join(data, by = "NCBI.ID") 

data.tax.ncbi2 <- ncbi %>%
  rename(ncbi.id = NCBI.ID, NCBI.ID = NCBI.ID2) %>%
  inner_join(data, by = "NCBI.ID") 

data.tax.ncbi3 <- ncbi %>%
  rename(ncbi.id = NCBI.ID, NCBI.ID = NCBI.ID3) %>%
  inner_join(data, by = "NCBI.ID")

#extract genomes with NO AsRG 
ncbi.NONE <- ncbi %>%
  anti_join(data, by = "NCBI.ID")
ncbi.NONE <- ncbi.NONE[!ncbi.NONE$NCBI.ID2 %in% data$NCBI.ID,]
ncbi.NONE <- ncbi.NONE[!ncbi.NONE$NCBI.ID3 %in% data$NCBI.ID,]
ncbi.NONE <- ncbi.NONE %>%
  left_join(data, by = "NCBI.ID")

#make colnames of all three datasets match
colnames(data.tax.ncbi2) <- colnames(data.tax.ncbi1)
colnames(data.tax.ncbi3) <- colnames(data.tax.ncbi1)

#combine all three datasets
data.tax <- rbind(data.tax.ncbi1, data.tax.ncbi2, data.tax.ncbi3)

#add back NAs
data.tax <- rbind(data.tax, ncbi.NONE)

#change NA gene to "None"
data.tax$Gene[is.na(data.tax$Gene)] <- "None"

#read in plasmid taxanomic information
plasmid.tax <- read_delim(paste(wd, "/data/plasmid.tax.txt", sep = ""), delim = "\t", col_names = c("NCBI.ID4", "Taxon ID"), trim_ws = TRUE)

#trim plasmid info based on hmm 
plasmid.tax <- plasmid.tax[plasmid.tax$NCBI.ID4 %in% plasmid$t.name,]

#trim plasmid info based on taxonomy
plasmid.tax <- plasmid.tax[plasmid.tax$`Taxon ID` %in% ncbi$`Taxon ID`,]

#export plasmid taxonomy information and add refsoil info manually
write.table(plasmid.tax, paste(wd, "/output/plasmid.tax.trimmed.txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE)

#merge plasmid information with plasmid
#hmm search data
ncbi.plasmid.annotated <- plasmid.tax %>%
  dcast(`Taxon ID`, value.var = "NCBI.ID4")

  merge(plasmid.tax, by = "Taxon ID")
#############################################
#EXAMINE NUMBER OF MODEL HITS (not relative)#
#############################################

#make color scheme
#n <- 25
#qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
#col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
#phy.color <- print(sample(col_vector, n))
color <- c("#FDB462", "#F4CAE4", "#DECBE4", "#6A3D9A", "black", "#B15928", "#1F78B4", "#999999", "#E78AC3", "#B3CDE3", "#CCCCCC", "#E31A1C", "#FB9A99", "#E6AB02","#66A61E",  "#B3DE69", "#A6CEE3", "#1B9E77", "#7FC97F", "#F0027F", "#FF7F00", "#CCEBC5", "#A65628","#FFFFCC", "#666666")

#plot bar chart with filled phyla
(asrg.phyla.bar <- ggplot(data = data.tax, aes(x = Gene, fill = Phylum)) +
  geom_bar(stat = "count") +
  scale_fill_manual(values = color) +
  ylab("Number of model hits") +
  xlab("Gene") +
  theme_bw(base_size = 12) +
  ylim(0, NA) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.bar, filename = paste(wd, "/figures/numberhits.gene.eps", 
                                        sep = ""), width = 10)

#save file with count information (to compare with metaG)
write.table(data.tax, file = paste(wd, "/output/RefSoil_count.txt", sep = ""), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")

#calculate relative hits (gene/genome) for COG comparison
data.taxREL <- data.tax %>%
  group_by(Gene) %>%
  summarise(Count = length(Gene)) %>%
  mutate(RelCount = Count / nrow(ncbi))

#plot bar chart with filled phyla RELATIVE
(asrg.phyla.barREL <- ggplot(data = subset(data.taxREL, Gene !="None"), aes(x = Gene, y = RelCount)) +
    geom_bar(stat = "identity", color = "black", fill = "grey49") +
    ylab("Count proportion (number per genome)") +
    xlab("Gene") +
    theme_bw(base_size = 12) +
    ylim(0,1) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.barREL, filename = paste(wd, "/figures/numberhits.geneREL.png", 
                                        sep = ""), width = 10)

#summarise NCBI so that we know how many of each phyla are in the 922 
#genomes from Refsoil
ncbi.sum <- ncbi %>%
  group_by(Phylum) %>%
  summarise(phy.n = length(Phylum))

#join phy count information with data.tax
data.tax.sum <- data.tax %>%
  ungroup() %>%
  group_by(Gene, Phylum) %>%
  summarise(gene.count = length(Phylum)) %>%
  left_join(ncbi.sum, by = "Phylum") %>%
  mutate(rel.count = gene.count / phy.n)
  
################################################
#EXAMINE PRESENCE ABSENCE (LOGICAL) GENE COUNTS#
################################################

#remove rows resulting from more than one copy/ genome
data.tax.uniq <- data.tax[!duplicated(data.tax[c(18,2)]),]

#plot bar chart with filled phyla (+/- gene)
(asrg.logi.phyla.bar <- ggplot(data = data.tax.uniq, aes(x = Gene, fill = Phylum)) +
    geom_bar(stat = "count") +
    scale_fill_manual(values = color) +
    ylab("Number of genomes") +
    xlab("Gene") +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.logi.phyla.bar, filename = paste(wd, "/figures/PA.gene.png", sep = ""), width = 10)

#plot bar chart with filled phyla (+/- gene)
data.tax.uniqREL <- data.tax.uniq %>%
  group_by(Gene, Phylum) %>%
  summarise(Count = length(Gene)) %>%
  mutate(RelCount = Count / nrow(ncbi))

(asrg.logi.phyla.barREL <- ggplot(data = subset(data.tax.uniqREL, Gene != "arsA"), aes(x = Gene, y = RelCount)) +
    geom_bar(stat = "identity") +
    ylab("Proportion of genomes containing gene") +
    xlab("Gene") +
    #scale_fill_manual(values = color) +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.logi.phyla.barREL, filename = paste(wd, "/figures/PA.geneREL_grey.eps", sep = ""), width = 6.4, height = 4.3)

#plot RefSoil database phylum-level distribution
ncbi.sum <- ncbi %>%
  group_by(Phylum) %>%
  summarise(Phy.Count = length(Phylum)) %>%
  mutate(RefSoil = "RefSoil")

(refsoil.tot <- ggplot(ncbi.sum, aes(x = RefSoil, y = Phy.Count/922)) +
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

(gene.hist <- ggplot(data.sum, aes(x = Gene.count, fill = Gene)) +
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
#####retry

#make matrix of information
data.tax.sum <- data.tax %>%
  group_by(Gene, Kingdom, Phylum, Class, Order, Family, Genus, `RefSoil ID`) %>%
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

#set up taxonomy data
data.sum.ncbi <- data.tax %>%
  group_by(Phylum,`RefSoil ID`, NCBI.ID, NCBI.ID2, NCBI.ID3, Gene) %>%
  summarise(Gene.count = length(Gene)) %>%
  dcast(`RefSoil ID` + NCBI.ID + NCBI.ID2 + NCBI.ID3 ~ Gene, value.var = "Gene.count")


#annotate itol data
#need to join based on three chromosomes 
itol.ncbi1 <- itol %>%
  left_join(data.sum.ncbi, by = "NCBI.ID") %>%
  select(NCBI.ID, Name, `RefSoil ID`, acr3:None)
itol.ncbi1 <- itol.ncbi1[-which(is.na(itol.ncbi1$`RefSoil ID`)),]

itol.ncbi2 <- itol %>%
  rename(NCBI.ID2 = NCBI.ID) %>%
  left_join(data.sum.ncbi, by = "NCBI.ID2") %>%
  select(NCBI.ID2, Name, `RefSoil ID`, acr3:None) %>%
  rename(NCBI.ID = NCBI.ID2)
itol.ncbi2 <- itol.ncbi2[-which(is.na(itol.ncbi2$`RefSoil ID`)),]

itol.ncbi3 <- itol %>%
  rename(NCBI.ID3 = NCBI.ID) %>%
  left_join(data.sum.ncbi, by = "NCBI.ID3") %>%
  select(NCBI.ID3, Name, `RefSoil ID`, acr3:None) %>%
  rename(NCBI.ID = NCBI.ID3)
itol.ncbi3 <- itol.ncbi3[-which(is.na(itol.ncbi3$`RefSoil ID`)),]

itol.annotated <- rbind(itol.ncbi1, itol.ncbi2, itol.ncbi3)

#replace NA values 
itol.annotated[is.na(itol.annotated)] <- -1

#replace values for iTOL
#0 = open shape, 1 = closed shape; -1 = nothing
#open shapes
itol.annotated$acr3 <- replace(itol.annotated$acr3, itol.annotated$acr3 > 0, 1)
itol.annotated$arsC_thio <- replace(itol.annotated$arsC_thio, itol.annotated$arsC_thio > 0, 1)
itol.annotated$aioA <- replace(itol.annotated$aioA, itol.annotated$aioA > 0, 1)

#closed shapes
itol.annotated$arsB <- replace(itol.annotated$arsB, itol.annotated$arsB > 0, 1)
itol.annotated$arsM <- replace(itol.annotated$arsM, itol.annotated$arsM > 0, 1)
itol.annotated$arxA <- replace(itol.annotated$arxA, itol.annotated$arxA > 0, 1)
itol.annotated$arsC_glut <- replace(itol.annotated$arsC_glut, itol.annotated$arsC_glut > 0, 1)
itol.annotated$arrA <- replace(itol.annotated$arrA, itol.annotated$arrA > 0, 1)

#trim dataframe
itol.annotated.shapes <- itol.annotated %>%
  select(-c(None, arsD, `RefSoil ID`,arsA)) %>%
  select(NCBI.ID, arsB, acr3, arsC_glut, arsC_thio, arsM, aioA, arxA, arrA)

#save as output
write.table(itol.annotated.shapes, paste(wd, "/output/iTOL_shapes.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

#read in phylum colors
colors.phy <- read_delim(paste(wd, "/data/colors_phylum.txt", sep = ""), delim = "\t", col_names = c("Color", "Phylum"))

#make itol dataframe for leaf colors
itol.annotated.color <- itol.annotated %>%
  select(-c(acr3:None)) %>%
  left_join(data.tax, by = "RefSoil ID") %>%
  select(NCBI.ID.x, Phylum) %>%
  left_join(colors.phy, by = "Phylum") %>%
  mutate(Type = "label") %>%
  select(NCBI.ID.x,Type,Color)
  
#save as output
write.table(itol.annotated.color, paste(wd, "/output/iTOL_node_color.csv", sep = ""), quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")
