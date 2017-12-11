#load dependencies
library(tidyverse)
library(reshape2)
library(RColorBrewer)


########################################
#READ IN AND PREPARE DATA FOR ANALYSIS#
#######################################

#print working directory for future references
#note the GitHub directory for this script is as follows
#https://github.com/ShadeLab/meta_arsenic/tree/master/refsoil_analysis
wd <- print(getwd())

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data", sep = ""))

#read in abundance data
names=list.files(pattern="*.dom.txt")
data <- do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read.table(X))}))

#move back up a directory to proceed with analysis
setwd("../")

#read in AsRG hmm length data
hmm <- read_delim(file = paste(wd, "/data/all_hmm.txt", sep = ""), 
                  delim = "\t")

#remove unnecessary columns
data$id <- as.character(data$id)
data <- data %>%
  separate(id, into = c("Gene", "refsoil"), sep = ".refsoil.E-10.dom.txt") %>%
  select(-c(refsoil, V2, V5, V23))

#add column names
#known from http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf
colnames(data) <- c("Gene", "t.name", "t.length", "query.name", "q.length", 
                    "e.value", "score1", "bias1", "#", "of", "c.evalue", 
                    "i.evalue", "score2", "bias2", "from.hmm", "to.hmm", 
                    "from.ali", "to.ali", "from.env", "to.env", "acc", "NCBI.ID")

#Calculate the length of the alignment
data <- data %>%
  mutate(length = to.ali - from.ali) %>%
  left_join(hmm, by = "Gene") %>%
  mutate(perc.ali = length / hmm.length, perc.t = t.length/q.length)

#remove rows that do not have at least 70% of hmm length (std)
data.90 <- data[which(data$perc.ali > 0.90 & data$perc.t < 1.4 & 
                        data$perc.t > 0.65 & data$score1 > 50),]

#read in taxanomic information
ncbi <- read_delim(file = paste(wd, "/data/ismej2016168x6.csv", sep = ""), 
                   delim = ",")

#separate out extra NCBI ID's
ncbi <- ncbi %>%
  separate(col = NCBI.ID, into = c("NCBI.ID", "NCBI.ID2", "NCBI.ID3"), 
           sep = ",")

#remove version number on NCBI ID (.##)
ncbi <- ncbi %>%
  separate(col = NCBI.ID, into = c("NCBI.ID", "Vs"), sep = -3) %>%
  separate(col = NCBI.ID2, into = c("NCBI.ID2", "Vs2"), sep = -3) %>%
  separate(col = NCBI.ID3, into = c("NCBI.ID3", "Vs3"), sep = -3) 

#join AsRG information with taxanomic data that match NCBI.ID #1, 2, 3
data.tax.ncbi1 <- ncbi %>%
  inner_join(data.90, by = "NCBI.ID") 

data.tax.ncbi2 <- ncbi %>%
  rename(ncbi.id = NCBI.ID, NCBI.ID = NCBI.ID2) %>%
  inner_join(data.90, by = "NCBI.ID") 

data.tax.ncbi3 <- ncbi %>%
  rename(ncbi.id = NCBI.ID, NCBI.ID = NCBI.ID3) %>%
  inner_join(data.90, by = "NCBI.ID")

#extract genomes with NO AsRG 
ncbi.NONE <- ncbi %>%
  anti_join(data.90, by = "NCBI.ID")
ncbi.NONE <- ncbi.NONE[!ncbi.NONE$NCBI.ID2 %in% data.90$NCBI.ID,]
ncbi.NONE <- ncbi.NONE[!ncbi.NONE$NCBI.ID3 %in% data.90$NCBI.ID,]
ncbi.NONE <- ncbi.NONE %>%
  left_join(data.90, by = "NCBI.ID")

#make colnames of all three datasets match
colnames(data.tax.ncbi2) <- colnames(data.tax.ncbi1)
colnames(data.tax.ncbi3) <- colnames(data.tax.ncbi1)

#combine all three datasets
data.tax <- rbind(data.tax.ncbi1, data.tax.ncbi2, data.tax.ncbi3)

#examine if any HMM hits apply to two genes
duplicates <- data.tax[duplicated(data.tax$t.name),]
#192 hits are duplicates

#of the duplicates, all are arrA/aioA mixed hits
#we will accept the one with a higher score
#arrange data by score
data.tax <- data.tax[order(data.tax$t.name, abs(data.tax$score1), decreasing = TRUE), ] 

#remove duplicates that have the lower score
duplicates <- data.tax[duplicated(data.tax$t.name),]
data.tax <- data.tax[!duplicated(data.tax$t.name),]

#add back NAs
data.tax <- rbind(data.tax, ncbi.NONE)

#change NA gene to "None"
data.tax$Gene[is.na(data.tax$Gene)] <- "None"

#export final names for tree
dissim.data.tax <- data.tax %>% subset(Gene == c("aioA","arrA","arxA"))
write(as.character(dissim.data.tax$t.name), file = paste(wd, "/output/dissim_target_names.txt", sep = ""))

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
  theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.bar, filename = paste(wd, "/figures/numberhits.gene.png", 
                                        sep = ""), width = 10)
ggsave(asrg.phyla.bar, filename = paste(wd, "/figures/numberhits.gene.png", 
                                        sep = ""), width = 10)

#calculate relative hits (gene/genome) for COG comparison
data.taxREL <- data.tax %>%
  group_by(Gene) %>%
  summarise(Count = length(Gene)) %>%
  mutate(RelCount = Count / 922)

#plot bar chart with filled phyla RELATIVE
(asrg.phyla.barREL <- ggplot(data = subset(data.taxREL, Gene !="None"), aes(x = Gene, y = RelCount)) +
    geom_bar(stat = "identity", color = "black", fill = "grey49") +
    ylab("Count proportion (number per genome)") +
    xlab("Gene") +
    theme_bw(base_size = 12) +
    ylim(0,1.6) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla.barREL, filename = paste(wd, "/figures/numberhits.geneREL.png", 
                                        sep = ""), width = 10)
ggsave(asrg.phyla.barREL, filename = paste(wd, "/figures/numberhits.geneREL.eps", 
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

#save plot
ggsave(asrg.logi.phyla.bar, filename = paste(wd, "/figures/PA.gene.eps", sep = ""), width = 10)

#plot bar chart with filled phyla (+/- gene)
data.tax.uniqREL <- data.tax.uniq %>%
  group_by(Gene, Phylum) %>%
  summarise(Count = length(Gene)) %>%
  mutate(RelCount = Count / 922)

(asrg.logi.phyla.barREL <- ggplot(data = data.tax.uniqREL, aes(x = Gene, y = RelCount)) +
    geom_bar(stat = "identity", aes(fill = Phylum)) +
    ylab("Proportion of genomes containing gene") +
    xlab("Gene") +
    scale_fill_manual(values = color) +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.logi.phyla.barREL, filename = paste(wd, "/figures/PA.geneREL.png", sep = ""), width = 10)

ggsave(asrg.logi.phyla.barREL, filename = paste(wd, "/figures/PA.geneREL.png.eps", sep = ""), width = 10)

#join phy count information with data.tax
data.tax.uniq.logi <- data.tax.uniq %>%
  group_by(Gene, Phylum) %>%
  summarise(logi.count = length(Phylum)) %>%
  left_join(ncbi.sum, by = "Phylum") %>%
  mutate(rel.logi.count = logi.count / phy.n) %>%
  ungroup()

#order based on phylum abundance
data.tax.uniq.logi$Phylum <- factor(data.tax.uniq.logi$Phylum, 
                              levels = data.tax.uniq.logi$Phylum[order(data.tax.uniq.logi$phy.n, decreasing = TRUE)])

#remove phyla with less than 3 representatives
data.tax.uniq.logi.slim <- data.tax.uniq.logi[which(data.tax.uniq.logi$phy.n >10),]

cog.comp <- c("acr3","arsA", "arsC_glut", "arsB")
cog.phyla <- c("Actinobacteria", "Proteobacteria", "Bacteroidetes", "Chlamydiae", 
               "Chloroflexi", "Firmicutes", "Fusobacteria", "Planctomycetes", 
               "Spirochaetes", "Tenericutes", "Verrucomicrobia", "Cyanobacteria")
data.cog.comp <- data.tax.uniq.logi[which(data.tax.uniq.logi$Gene %in% cog.comp),]
data.cog.comp <- data.cog.comp[which(data.cog.comp$Phylum %in% cog.phyla),]

#order based on phylum abundance
data.cog.comp$Phylum <- factor(data.cog.comp$Phylum, 
                                    levels = data.cog.comp$Phylum[order(data.cog.comp$phy.n, decreasing = TRUE)])


#plot proportional bar chart (logical) with filled phyla
(asrg.logi.rel.phyla.bar <- ggplot(data.cog.comp, aes(x = Phylum, y = rel.logi.count, fill = Gene)) +
    geom_bar(stat = "identity", color = "black", position = "dodge") +
    ylab("Proportion of of genomes with gene (logical)") +
    scale_fill_manual(values = c("#8DD3C7","#BC80BD","#80B1D3", "grey")) +
    xlab("Phylum") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90, size = 12, hjust=0.95,vjust=0.2)))

ggsave(asrg.logi.rel.phyla.bar, filename = paste(wd, "/figures/PA.phylumREL.COG.png", sep = ""), width = 10)
ggsave(asrg.logi.rel.phyla.bar, filename = paste(wd, "/figures/PA.phylumREL.COG.eps", sep = ""), width = 10)

#######################################################
#HOW MANY COPIES OF ASRGS ARE PRESENT IN SOIL GENOMES?#
#######################################################
data.sum <- data.tax %>%
  group_by(Phylum,`Taxon ID`, Gene) %>%
  summarise(Gene.count = length(Gene))

ggplot(data.sum, aes(x = Gene.count, fill = Gene)) +
  geom_bar(color = "black") +
  facet_wrap(~Gene, scales = "free_y") +
  scale_fill_brewer(palette = "Set3") +
  scale_x_continuous(breaks = c(1,3,5,7,9,11)) +
  theme_bw(base_size = 12)

data.sum.cast <- dcast(data.sum, Gene~`Taxon ID`, fill = 0, value.var = "Gene.count")
data.sum.melt <- melt(data.sum.cast, id.vars = "Gene")

data.sum.melt.summary <- data.sum.melt %>%
  group_by(Gene) %>%
  summarise(N = length(Gene), Mean = mean(value), StErr = sd(value)/sqrt(N))

ggplot(subset(data.sum.melt, Gene !="None"), aes(x = Gene, y = value)) +
  geom_boxplot() +
  theme_bw()
