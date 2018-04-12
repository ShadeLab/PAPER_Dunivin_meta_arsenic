##########################
#READ IN DATA, SET UP ENV#
##########################

#read dependencies
library(phyloseq)
library(vegan)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(taxize)
library(psych)

#print working directory for future references
#note the GitHub directory for this script is as follows
#https://github.com/ShadeLab/Arsenic_Growth_Analysis/tree/master/As_metaG
wd <- print(getwd())

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data/", sep = ""))

#read in abundance data
names <- list.files(pattern="*_45_taxonabund.txt")
data <- do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read_delim(X, delim = "\t"))}))

#move back up a directory to proceed with analysis
setwd("../")

#change cen13 titles to more meaningful
data$id <- gsub("cen13_", "independent_1_", data$id)
data$id <- gsub("cen13-ct_", "dependent_1_", data$id)

#split columns and tidy dataset
data <- data %>%
  separate(col = id, into = c("Site", "junk"), sep = "_1_", remove = TRUE) %>%
  separate(col = junk, into = c("Gene", "junk"), sep = "_45_", remove = TRUE) %>%
  select(-junk)

#remove _ in front of gene name
data$Gene <- gsub("_", "", data$Gene)

#separate out rplB data for normalization
rplB <- data[which(data$Gene == "rplB"),]
data <- data[-which(data$Gene == "rplB"),]

##prep rlpB information (ie get genome estimates)
#split columns 
rplB.summarised <- rplB %>%
  group_by(Site) %>%
  summarise(Total = sum(Fraction.Abundance), rplB = sum(Abundance))

#Tidy gene data
data.tidy <- data %>%
  separate(col = Taxon, into = c("Code", "Organism"), sep = "organism=") %>%
  separate(col = Organism, into = c("Organism", "Definition"), sep = ",definition=") %>%
  select(Site, Gene, Organism:Fraction.Abundance) %>%
  group_by(Gene, Site)

#make sure abundance and fraction abundance are numbers
#R will think it's a char since it started w taxon name
data.tidy$Fraction.Abundance <- as.numeric(data.tidy$Fraction.Abundance)
data.tidy$Abundance <- as.numeric(data.tidy$Abundance)

#double check that all fraction abundances = 1
#slightly above or below is okay (Xander rounds)
summarised.total <- data.tidy %>%
  summarise(N = length(Site), Total = sum(Fraction.Abundance))

#make column for organism name and join with microbe census data and normalize to it
data.annotated <- data.tidy %>%
  left_join(rplB.summarised, by = "Site") %>%
  mutate(Normalized.Abundance.rplB = Abundance / rplB)

#summarise data to get number of genes per gene per site
data.site <- data.annotated %>%
  group_by(Gene, Site) %>%
  summarise(Count = sum(Abundance), 
            Count.rplB = sum(Normalized.Abundance.rplB))

#add taxanomic information 
#data.ncbi <- tax_name(query = data.annotated$Organism, 
#                      get = c("genus", "class", "phylum"), db = "ncbi")


#label query "Organism" for joining purposes
#data.ncbi$Organism <- data.ncbi$query

#save ncbi data for future use
#write.table(data.ncbi, file = paste(wd, "/output/ncbi_results.txt", sep = ""), sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)

#read in ncbi data (need to do above ## steps first)
data.ncbi <- read.delim(paste(wd, "/output/ncbi_results.txt", sep = ""), sep = "\t", header = TRUE)
  
#add ncbi information to data
data.annotated <- data.annotated %>%
  left_join(data.ncbi, by = "Organism") %>%
  unique()

#replace NA in phylum with uncultured bacterium
#and change proteobacteria to class
data.annotated <- data.annotated %>% 
  mutate(phylum = as.character(phylum), 
         phylum = ifelse(is.na(phylum), "uncultured bacterium", phylum),
         class = as.character(class),
         phylum = ifelse(phylum == "Proteobacteria", class, phylum)) %>%
  select(Site, Gene, phylum, Normalized.Abundance.rplB)

#tidy rplB data
rplB.tidy <-  rplB %>%
  rename(Normalized.Abundance.rplB = Fraction.Abundance, 
         phylum = Taxon) %>%
  mutate(phylum = ifelse(phylum == "candidate_division_Zixibacteria", "candidate division Zixibacteria", phylum)) %>%
  select(-Abundance)

#join rplB and AsRG data
data.annotated.full <- rbind(data.frame(data.annotated), data.frame(rplB.tidy))


#make color list
color <- c("#FF7F00", "#7570B3", "#CAB2D6", "#F0027F", "#FBB4AE", "#BEBADA", "#E78AC3", "#A6D854", "#46f0f0", "#386CB0", "#BC80BD", "#FFFFCC", "#984EA3", "black", "#FFFF99", "#B15928", "#F781BF", "#FDC086", "#A6CEE3", "#FCCDE5","#B2DF8A", "#377EB8", "#E31A1C", "#80B1D3", "#FFD92F", "#33A02C", "#66C2A5", "#666666", "#E6AB02", "grey90", "#000080", "#aaffc3", "grey55", "#d2f53c")

data.annotated.full$Genef <- factor(data.annotated.full$Gene, levels = c("acr3", "arsB","arsD", "arsCglut", "arsCthio",  "arsM","arrA", "aioA", "arxA", "rplB"), ordered = TRUE)

data.annotated.summary <- data.annotated.full %>%
  group_by(Genef, Site) %>%
  summarise(Total = sum(Normalized.Abundance.rplB))
no <- c("rplB", "arsA")
#plot genes by abund
(RefSoil_comp <- ggplot(subset(data.annotated.summary, !Genef %in% no), aes(x = Genef, y = Total)) +
  geom_bar(stat = "identity", position = "dodge", aes(fill = Site)) +
    scale_fill_manual(values = c("black", "grey")) +
    ylab("Normalized abundance") +
    theme_bw(base_size = 16) +
    xlab("Gene") + 
    theme(axis.text.x = element_text(angle = 45,
                                     hjust=0.99,vjust=0.99)))

ggsave(RefSoil_comp, filename = paste(wd, "/figures/culture_comparison.eps", sep = ""), width = 8.5, height = 4.5, units = "in")

#plot abundancy by phylum
 (AsRG_phylum <-data.annotated.full %>%
  subset(Gene != "rplB") %>%
  group_by(Site, Gene, phylum) %>%
  summarise(Total = sum(Normalized.Abundance.rplB)) %>%
  ungroup() %>%
  mutate(Gene = gsub("arsCglut", "arsC (grx)", Gene),
         Gene = gsub("arsCthio", "arsC (trx)", Gene),
         name = paste(Gene, phylum, sep = " ")) %>%
ggplot(aes(x = Site, y = name, color = phylum)) +
  geom_point(aes(size = 2*Total)) +
  geom_point(aes(size = 2*Total), shape = 1, color = "black") +
  scale_color_manual(values = color) +
  theme_bw(base_size = 10) +
  scale_size_continuous(breaks = c(0.3, 0.5, 0.7, 0.9)) +
  ylab("Phylum") +
  xlab("Metagenome") +
  labs(size = "rplB-normalized abundance") +
     coord_flip() +
     theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)))
ggsave(AsRG_phylum, filename = paste(wd, "/figures/AsRG_phylum.eps", sep = ""),  width = 15, height = 2.5, units = "in")

ggsave(AsRG_phylum, filename = paste(wd, "/figures/AsRG_phylum_labels.eps", sep = ""),  width = 5, height = 7, units = "in")


#examine rplB
(rplB_phylum <- data.annotated.full %>%
  subset(Gene =="rplB") %>%
  group_by(Site, Gene, phylum) %>%
  summarise(Total = sum(Normalized.Abundance.rplB)) %>%
  ggplot(aes(x = Site, y = phylum)) +
  geom_point(aes(size = Total)) +
  theme_bw(base_size = 10) +
  scale_size_continuous(breaks = c(0.3, 0.5, 0.7, 0.9)) +
  ylab("Phylum") +
  xlab("Metagenome") +
  labs(size = "rplB-normalized abundance"))

