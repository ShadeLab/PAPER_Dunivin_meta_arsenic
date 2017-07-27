#from Taylor's meta_arg_rplB.R: https://github.com/ShadeLab/Xander_arsenic/tree/master/diversity_analysis
#read dependencies
library(phyloseq)
library(vegan)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(taxize)
library(psych)

setwd("C:/Users/susan/Documents/arsenic")
wd <- print(getwd())

#read in metadata
meta <- data.frame(read_delim(file = paste(wd, "/data/metadata.txt", sep = ""), delim = "\t"))

#read in microbe census data
census <- read_delim(file = paste(wd, "/microbe_census_wo.3.txt", sep = ""),
                     delim = "\t", col_types = list(col_character(), col_number(),
                                                    col_number(), col_number()))

#read in gene classification data
gene <- read_delim(paste(wd, "/data/gene_classification.txt",  sep=""), 
                   delim = "\t", col_names = TRUE)

####################################
#READ IN AND SET UP DATA#
####################################

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data", sep = ""))

#read in abundance data
names <- list.files(pattern="*_45_taxonabund.txt")
data <- do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read_delim(X, delim = "\t"))}))


#move back up a directory to proceed with analysis
setwd("../")
wd <- print(getwd())

#split columns and tidy dataset
data <- data %>%
  separate(col = id, into = c("Sample", "junk"), sep = "[.]3_", fixed=TRUE) %>%
  separate(col = junk, into = c("Gene", "junk"), sep = "_45_", remove = TRUE) %>%
  select(-junk) 

#separate out rplB data (not needed for gene-centric analysis)
rplB <- data[which(data$Gene == "rplB"),]
data <- data[-which(data$Gene == "rplB"),]

####################################
#EXAMINE rplB ACROSS CHRONOSEQUENCE#
####################################

#split columns 
rplB <- rplB %>%
  select(Sample, Taxon:Fraction.Abundance) %>%
  group_by(Sample)

#make sure abundance and fraction abundance are numbers
#R will think it's a char since it started w taxon name
rplB$Fraction.Abundance <- as.numeric(rplB$Fraction.Abundance)
rplB$Abundance <- as.numeric(rplB$Abundance)

#double check that all fraction abundances = 1
#slightly above or below is okay (Xander rounds)
summarised.rplB <- rplB %>%
  summarise(Total = sum(Fraction.Abundance), rplB = sum(Abundance))

#save summarised data for future analyses
write.table(x = summarised.rplB, file = paste(wd, "/output/rplB.summary.scg.txt", sep = ""), 
            row.names = FALSE)

#decast for abundance check
dcast <- acast(rplB, Taxon ~ Sample, value.var = "Fraction.Abundance")

#call na's zeros
dcast[is.na(dcast)] = 0

#order based on abundance
order.dcast <- dcast[order(rowSums(dcast),decreasing=TRUE),]

#melt data
melt <- melt(order.dcast,id.vars=row.names(order.dcast), 
             variable.name= "Sample", value.name="Fraction.Abundance" )

#adjust colnames of melt
colnames(melt) <- c("Taxon", "Sample", "Fraction.Abundance")

#join metadata with regular data
history <- melt %>%
  left_join(meta, by="Sample") %>%
  group_by(Taxon) %>%
  summarise(N = length(Fraction.Abundance),
            Average = mean(Fraction.Abundance))

#plot
(phylum.plot=(ggplot(history, aes(x=Taxon, y=Average)) +
                geom_point(size=2) +
                labs(x="Phylum", y="Mean relative abundance")+
                theme(axis.text.x = element_text(angle = 90, size = 10, 
                                                 hjust=0.95,vjust=0.2))))

#save plot
ggsave(phylum.plot, filename = paste(wd, "/figures/phylum.responses.png", sep=""), 
       width = 5, height = 5)
###################################################
#EXAMINE As resistance genes ACROSS CHRONOSEQUENCE#
###################################################

#Tidy gene data
data.tidy <- data %>%
  separate(col = Taxon, into = c("Code", "Organism"), sep = "organism=") %>%
  separate(col = Organism, into = c("Organism", "Definition"), sep = ",definition=") %>%
  select(Sample, Gene, Organism:Fraction.Abundance) %>%
  group_by(Gene, Sample)

#make sure abundance and fraction abundance are numbers
#R will think it's a char since it started w taxon name
data.tidy$Fraction.Abundance <- as.numeric(data.tidy$Fraction.Abundance)
data.tidy$Abundance <- as.numeric(data.tidy$Abundance)

#double check that all fraction abundances = 1
#slightly above or below is okay (Xander rounds)
summarised.total <- data.tidy %>%
  summarise(N = length(Sample), Total = sum(Fraction.Abundance))

#read in metadata
meta <- data.frame(read_delim(file = paste(wd, "/data/metadata.txt", sep = ""), delim = "\t"))

data.annotated <- data.tidy %>%
  left_join(meta, by = "Sample")

data.annotated <- data.annotated %>%
  left_join(gene, by = "Gene")

#make column for organism name and join with microbe census data and normalize to it
data.annotated <- data.annotated %>%
  left_join(census, by = "Sample") %>%
  left_join(summarised.rplB, by = "Sample") %>%
  select(Sample:GE, rplB) %>%
  mutate(Normalized.Abundance.census = Abundance / GE, 
         Normalized.Abundance.rplB = Abundance / rplB)

#summarise data to get number of genes per gene per site
#data.site <- data.annotated %>%
  #group_by(Gene, Sample) %>%
  #summarise(Count = sum(Abundance), 
      #      Count.rplB = sum(Normalized.Abundance.rplB),
       #     Count.census = sum(Normalized.Abundance.census)) %>%
  #left_join(meta, by = "Sample")

##############################
#EXAMINE PHYLUM LEVEL CHANGES#
##############################

##Plot relative abundances for all the genes, must summarize by SAMPLE to count the normalized abundance
data.count <- data.annotated %>%
  group_by(Gene, Sample, Group) %>%
  summarise(count = sum(Normalized.Abundance.rplB))

#read in metadata (for all the genes and sites)
meta <- data.frame(read_delim(file = paste(wd, "/data/metadata_with_removed_data.txt", sep = ""), delim = "\t"))

data.count <- data.count %>%
  left_join(meta, by="Sample")

#separate out arsC_glut and arsM
data.count <- data.count[-which(data.count$Gene == "aioA"),]
data.count <- data.count[-which(data.count$Gene == "acr3"),]
data.count <- data.count[-which(data.count$Gene == "arsC_thio"),]
data.count <- data.count[-which(data.count$Gene == "arsD"),]
data.count <- data.count[-which(data.count$Gene == "arxA"),]
data.count <- data.count[-which(data.count$Gene == "arsB"),]
data.count <- data.count[-which(data.count$Gene == "arrA"),]

data.count <- na.omit(data.count)

#summarize by site, then count up
data.summarised <- data.count %>%
  group_by(Gene, Site, Biome) %>%
  summarise(count = mean(count))

#order genes by group
data.summarised$Gene <- factor(data.summarised$Gene)
levels(data.summarised$Gene)
data.summarised$Gene <- reorder(data.summarised$Gene, data.summarised$Group)

#plot to wrap per gene: (facet_wrap(~ Gene, scales="free_y") +)
(gene.bar.census <- ggplot(data.summarised, 
                           aes(x = Site, y = count*100, fill=Gene)) +
    geom_bar(stat="identity", position="stack") +
    ylab("Gene per rplB (%)") +
    theme_bw()  +
    theme(text = element_text(size=34)) +
    scale_fill_manual(values=c("#81C784", "#388E3C", "#FFEB3B",
                               "#29B6F6", "#00838F", "#9575CD",
                               "#D500F9", "#FF5733", "#F48FB1")) +
    theme(axis.text.x = element_text(angle = 30, hjust=1, size=20)))

#save plot
ggsave(gene.bar.census, 
       filename = paste(wd, "/figures/phylum.abundance.rplB.arC_glut_arsM.png", 
                        sep=""), height = 10, width = 18)

##Plot just arsM and arsC_glut on X and Y Axis to compare their abundances:
#read data.summarized for arsM and arsC_glut
data.summarised.arsC_glut.arsM=read.delim(file = paste(wd, 
                                "/data/data.summarized.arsC_glut.arsM.txt", 
                                sep=""))
colnames(data.summarised.arsC_glut.arsM) = c("Site", "Biome", "arsC_glut","arsM")

#plot x axis arsM, y axis arsC_glut
(gene.bar.census <- ggplot(data.summarised.arsC_glut.arsM, 
                           aes(x = arsC_glut, y = arsM, color=Site)) +
    geom_point(size=2) +
    scale_fill_manual(values = color) +
    ylab("arsM per rplB (%)") +
    xlab("arsC_glut per rplB (%)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, size = 10, hjust=0.95,vjust=0.2)))
