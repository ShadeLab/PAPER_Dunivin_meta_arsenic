#from Taylor's meta_arg_rplB.R: https://github.com/ShadeLab/Xander_arsenic/tree/master/diversity_analysis
#read dependencies
library(phyloseq)
library(vegan)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(taxize)
library(psych)

wd <- print(getwd())

#read in metadata
meta <- data.frame(read_delim(file = paste(wd, "/data/metadata.txt", sep = ""), delim = "\t"))

#read in microbe census data
census <- read_delim(file = paste(wd, "/microbe_census.txt", sep = ""),
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

#fix russia name by removing "_"
data$Sample <- gsub("Russia_", "Russia", data$Sample)

#fix iowa prarie76 sample name
data$Sample <- gsub("IowaPr76", "Iowa_prairie76", data$Sample)


#remove sites with low rplB (ie low seq depth/ confidence)
data <- data[-which(data$Sample == "Iowa_agricultural01"),]
data <- data[-which(data$Sample == "Illinois_soybean42"),]
data <- data[-which(data$Sample == "Illinois_soybean40"),]

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

#join rlpB summarsied data with metadata for plotting
summarised.rplB.meta <- summarised.rplB %>%
  left_join(meta, by = "Sample") 

#plot rplB differences
ggplot(summarised.rplB.meta, aes(x = Site, y = rplB, fill= Sample)) +
  geom_bar(stat = "identity", position = "dodge", color = "black")

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
  group_by(Site, Taxon) %>%
  summarise(N = length(Fraction.Abundance),
            Average = mean(Fraction.Abundance))

#plot
(phylum.plot=(ggplot(history, aes(x=Taxon, y=Average)) +
                geom_point(size=2) +
                labs(x="Phylum", y="Mean relative abundance") +
                facet_wrap(~Site) +
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
  left_join(meta, by = "Sample") %>%
  separate(col = Taxon, into = c("Code", "Organism"), sep = "organism=") %>%
  separate(col = Organism, into = c("Organism", "Definition"), sep = ",definition=") %>%
  group_by(Gene, Sample)

#make sure abundance and fraction abundance are numbers
#R will think it's a char since it started w taxon name
data.tidy$Fraction.Abundance <- as.numeric(data.tidy$Fraction.Abundance)
data.tidy$Abundance <- as.numeric(data.tidy$Abundance)

#double check that all fraction abundances = 1
#slightly above or below is okay (Xander rounds)
summarised.total <- data.tidy %>%
  summarise(N = length(Sample), Total = sum(Fraction.Abundance))

#make column for organism name and join 
#with microbe census data and normalize to it
data.annotated <- data.tidy %>%
  left_join(summarised.rplB, by = "Sample") %>%
  left_join(gene, by = "Gene") %>%
  mutate(Normalized.Abundance.rplB = Abundance / rplB)

#order genes by group
data.annotated$Gene <- factor(data.annotated$Gene)
levels(data.annotated$Gene)
data.annotated$Gene <- reorder(data.annotated$Gene, data.annotated$Group)

#plot mean abundance per site
data.annotated.summarised <- data.annotated %>%
  ungroup() %>%
  group_by(Sample, Site, Gene) %>%
  summarise(Total.normalized.rplB = sum(Normalized.Abundance.rplB)) %>%
  ungroup() %>%
  group_by(Site, Gene) %>%
  summarise(Avg.norm.rplB = mean(Total.normalized.rplB),
            sd = sd(Total.normalized.rplB), 
                    N = length(Site))

(gene.bar <- ggplot(data.annotated.summarised, 
                    aes(x = Site, y = Avg.norm.rplB*100, 
                               fill=Gene)) +
    geom_bar(stat="identity", position="stack") +
    ylab("Average gene per rplB (%)") +
    theme_bw()  +
    theme(text = element_text(size=12)) +
    scale_fill_manual(values=c("#81C784", "#388E3C", "#FFEB3B",
                               "#29B6F6", "#00838F", "#9575CD",
                               "#D500F9", "#FF5733", "#F48FB1")) +
    theme(axis.text.x = element_text(angle = 30, hjust=1, size=12)))

#save plot
ggsave(gene.bar, 
       filename = paste(wd, "/figures/phylum.abundance.rplB.png", 
                        sep=""), height = 10, width = 18)

#plot to wrap per gene: (facet_wrap(~ Gene, scales="free_y") +)
(gene.bar.se <- ggplot(data.annotated.summarised, 
                    aes(x = Site, y = Avg.norm.rplB*100, 
                        fill=Site)) +
    geom_bar(stat="identity", position="dodge") +
    ylab("Average gene per rplB (%)") +
    geom_errorbar(aes(ymin = 100*(Avg.norm.rplB - sd/N), 
                      ymax = 100*(Avg.norm.rplB + sd/N))) +
    theme_bw()  +
    theme(text = element_text(size=12)) +
    facet_wrap(~Gene, scales = "free_y") +
    theme(axis.text.x = element_text(angle = 30, hjust=1, size=12)))

#save plot
ggsave(gene.bar.se, 
       filename = paste(wd, "/figures/phylum.abundance.rplB_byGene.png", 
                        sep=""), height = 10, width = 18)


##Plot just arsM and arsC_glut on X and Y Axis to compare their abundances:
#read data.summarized for arsM and arsC_glut
#data.summarised.arsC_glut.arsM=read.delim(file = paste(wd, 
#                                "/data/data.summarized.arsC_glut.arsM.txt", 
#                                sep=""))
#colnames(data.summarised.arsC_glut.arsM) = c("Site", "Biome", "arsC_glut","arsM")

#plot x axis arsM, y axis arsC_glut
#(gene.bar.census <- ggplot(data.summarised.arsC_glut.arsM, 
#                           aes(x = arsC_glut, y = arsM, color=Site)) +
#    geom_point(size=2) +
#    scale_fill_manual(values = color) +
#    ylab("arsM per rplB (%)") +
#    xlab("arsC_glut per rplB (%)") +
#    theme_bw() +
#    theme(axis.text.x = element_text(angle = 90, size = 10, hjust=0.95,vjust=0.2)))

####################################
#Add taxanomic information to plots#
####################################

#add taxanomic information 
org.info <- unique(data.annotated$Organism)
data.ncbi <- tax_name(query = org.info, 
                      get = c("genus", "class", "phylum"), db = "ncbi")


#label query "Organism" for joining purposes
data.ncbi$Organism <- data.ncbi$query

#save this table since the above step takes a long time
write.table(data.ncbi, file = paste(wd, "/output/ncbi.taxonomy.txt", sep = ""), 
            row.names = FALSE)

#read in NCBI data
data.ncbi <- read_delim(paste(wd, "/output/ncbi.taxonomy.txt", sep = ""), delim = " ")

#join ncbi information with annotated data
#output should have same number of rows 
data.annotated.ncbi <- data.annotated %>%
  left_join(data.ncbi, by = "Organism") %>%
  unique()

#replace NA in phylum with unknown
data.annotated.ncbi$phylum[is.na(data.annotated.ncbi$phylum)] = "Unknown"

#call NA class by phyla
data.annotated.ncbi$class[is.na(data.annotated.ncbi$class)] <- as.character(data.annotated.ncbi$phylum[is.na(data.annotated.ncbi$class)])

#call NA genus by class (may be phyla in cases where class was NA)
data.annotated.ncbi$genus[is.na(data.annotated.ncbi$genus)] <- as.character(data.annotated.ncbi$class[is.na(data.annotated.ncbi$genus)])

#plot by taxa (phylum)
(bar.phylum.acr3 <- subset(data.annotated.ncbi, Gene == "acr3") %>%
    group_by(Sample, Gene, phylum) %>%
    summarise(sum = sum(Normalized.Abundance.rplB)) %>%
    ggplot(aes(x = Sample, y = sum)) +
  geom_bar(stat = "identity", aes(fill = phylum)) +
  facet_wrap(~Gene) +
    theme(axis.text.x = element_text(angle = 30, hjust=1, size=12)))



