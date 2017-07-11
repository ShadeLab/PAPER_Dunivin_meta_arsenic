#load dependencies 
library(phyloseq)
library(vegan)
library(tidyverse)
library(reshape2)
library(RColorBrewer)

setwd("C:/Users/susan/Documents/arsenic")

wd <- print(getwd())

#make color pallette
GnYlOrRd <- colorRampPalette(colors=c("green", "yellow", "orange","red"), bias=2)

#read in microbe census data
census <- read_delim(file = paste(wd, "/microbe_census.txt", sep = ""),
                     delim = "\t", col_types = list(col_character(), col_number(),
                                                    col_number(), col_number()))

#make colores for rarefaction curves (n=12)
rarecol <- c("black", "black", "darkred", "darkred", "forestgreen", "forestgreen",
             "orange", "orange", "blue", "blue", "blue", "yellow", "yellow", "yellow",
             "hotpink", "hotpink", "green", "green", "red", "red", "brown", "brown", 
             "grey", "grey", "purple", "purple", "violet", "violet")

##################################
#PHYLUM_LEVEL_RESPONSES_WITH_RPLB#
##################################

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data", sep = ""))

#read in abundance data
names=list.files(pattern="*rplB_45_taxonabund.txt")
data <- do.call(rbind, lapply(names, function(X) {
data.frame(id = basename(X), read.csv(X))}))


#move back up a directory to proceed with analysis
setwd("../")
wd <- print(getwd())

#remove rows that include lineage match name (only need taxon)
#aka remove duplicate data
data <- data[!grepl(";", data$Taxon.Abundance.Fraction.Abundance),]
data <- data[!grepl("Lineage", data$Taxon.Abundance.Fraction.Abundance),]

#split columns 
data <- data %>%
  separate(col = id, into = c("Sample", "junk"), sep = "_rplB") %>%
  separate(col = Taxon.Abundance.Fraction.Abundance, 
           into = c("Taxon", "Abundance", "Fraction.Abundance"), 
           sep = "\t") %>%
  select(-junk) %>%
  group_by(Sample)

#make sure abundance and fraction abundance are numbers
#R will think it's a char since it started w taxon name
data$Fraction.Abundance <- as.numeric(data$Fraction.Abundance)
data$Abundance <- as.numeric(data$Abundance)


#double check that all fraction abundances = 1
#slightly above or below is okay (Xander rounds)
summarised <- data %>%
  summarise(Total = sum(Fraction.Abundance), rplB = sum(Abundance))


#save summarised data for future analyses
write.table(x = summarised, file = paste(wd, "/output/rplB.summary.scg.txt", 
                                         sep = ""), row.names = FALSE)
#decast for abundance check
dcast=acast(data, Taxon ~ Sample, value.var = "Fraction.Abundance")

#call na's zeros
dcast[is.na(dcast)] =0

#order based on abundance
order.dcast=dcast[order(rowSums(dcast),decreasing=TRUE),]

#melt data
melt=melt(order.dcast,id.vars=row.names(order.dcast), variable.name= "Site", 
          value.name="Fraction.Abundance" )

#adjust colnames of melt
colnames(melt)=c("Taxon", "Site", "Fraction.Abundance")


#########################################################
#########################
#aioA DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
aioA0.1=read.delim(file = paste(wd, "/data/aioA_rformat_dist_0.1.txt", sep=""))

#add row names back
rownames(aioA0.1)=aioA0.1[,1]

#remove first column
aioA0.1=aioA0.1[,-1]

#make data matrix
aioA0.1=data.matrix(aioA0.1)

#i did not remove first column, it is OTU_01

#make an output of total gene count per site
aioA0.1.gcounts=rowSums(aioA0.1)

#otu table
otu_aioA0.1=otu_table(aioA0.1, taxa_are_rows = FALSE)
col <- c("black", "darkred", "forestgreen", "orange", 
         "blue", "yellow", "hotpink")
#see rarefaction curve
rarecurve(otu_aioA0.1, step=1, col=col, label = TRUE, cex=0.5)

#rarefy
rare_aioA0.1=rarefy_even_depth(otu_aioA0.1, sample.size = min(sample_sums(otu_aioA0.1)), 
                       rngseed = TRUE)

#check curve
rarecurve(rare_aioA0.1, step=1, col = c("black", "darkred", "forestgreen", 
                                "orange", "blue", "yellow", "hotpink"), 
          label = FALSE)

#make an output of total OTUs per site
aioA0.1[aioA0.1 > 0]  <- 1
aioA0.1.OTUcounts=rowSums(aioA0.1)

#########################
#arsC_glut DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arsC_glut0.1=read.delim(file = paste(wd, 
                                     "/data/arsC_glut_rformat_dist_0.1.txt", 
                                     sep=""))

#add row names back
rownames(arsC_glut0.1)=arsC_glut0.1[,1]

#remove first column
arsC_glut0.1=arsC_glut0.1[,-1]

#make data matrix
arsC_glut0.1=data.matrix(arsC_glut0.1)

#remove samples with <5 OTUs (Illinois_soybean40.3 (row 8), California_grasland62.3 (row16),
#Illinois_soybean42.3(row 20), Iowa_agricultural01.3(row19))
arsC_glut0.1 <- arsC_glut0.1[-c(8,16,20,19), ]


#make an output of total gene count per site
arsC_glut0.1.gcounts=rowSums(arsC_glut0.1)

#otu table for aioA0.3
otu_arsC_glut0.1=otu_table(arsC_glut0.1, taxa_are_rows = FALSE)

#see rarefaction curve
rarecurve(otu_arsC_glut0.1, step=5, col=rarecol, label = FALSE, cex=0.5)

#rarefy
rare_arsC_glut0.1=rarefy_even_depth(otu_arsC_glut0.1, 
                               sample.size = min(sample_sums(otu_arsC_glut0.1)), 
                               rngseed = TRUE)

#check curve
rarecurve(rare_arsC_glut0.1, step=1, col = c("black", "red", "forestgreen", 
                                        "orange", "blue", "yellow", "hotpink"), 
          label = TRUE, cex=0.4)

#make an output of total OTUs per site
arsC_glut0.1[arsC_glut0.1 > 0]  <- 1
arsC_glut0.1.OTUcounts=rowSums(arsC_glut0.1)

#########################
#arsC_thio DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arsC_thio0.1=read.delim(file = paste(wd, 
                                     "/data/arsC_thio_rformat_dist_0.1.txt", 
                                     sep=""))

#add row names back
rownames(arsC_thio0.1)=arsC_thio0.1[,1]

#remove first column
arsC_thio0.1=arsC_thio0.1[,-1]

#make data matrix
arsC_thio0.1=data.matrix(arsC_thio0.1)

#i did not remove first column

#make an output of total gene count per site
arsC_thio0.1.gcounts=rowSums(arsC_thio0.1)

#otu table for aioA0.3
otu_arsC_thio0.1=otu_table(arsC_thio0.1, taxa_are_rows = FALSE)
head(otu_arsC_thio0.1)
#see rarefaction curve
rarecurve(otu_arsC_thio0.1, step=5, col=col, label = FALSE, cex=0.5)

#rarefy
rare_arsC_thio0.1=rarefy_even_depth(otu_arsC_thio0.1, 
                                    sample.size = min(sample_sums(otu_arsC_thio0.1)), 
                                    rngseed = TRUE)

#check curve
rarecurve(rare_arsC_thio0.1, step=1, col = c("black", "red", "forestgreen", 
                                             "orange", "blue", "yellow", "hotpink"), 
          label = TRUE, cex=0.4)

#########################
#arrA DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arrA0.1=read.delim(file = paste(wd, 
                                     "/data/arrA_rformat_dist_0.1.txt", 
                                     sep=""))

#add row names back
rownames(arrA0.1)=arrA0.1[,1]

#remove first column
arrA0.1=arrA0.1[,-1]

#make data matrix
arrA0.1=data.matrix(arrA0.1)

#i removed first column, it is "X"
arrA0.1=arrA0.1[,-1]

#make an output of total gene count per site
arrA0.1.gcounts=rowSums(arrA0.1)

#otu table for aioA0.3
otu_arrA0.1=otu_table(arrA0.1, taxa_are_rows = FALSE)
head(otu_arrA0.1)
#see rarefaction curve
rarecurve(otu_arrA0.1, step=5, col=col, label = TRUE, cex=0.5)

#rarefy
rare_arrA0.1=rarefy_even_depth(otu_arrA0.1, 
                                    sample.size = min(sample_sums(otu_arrA0.1)), 
                                    rngseed = TRUE)

#check curve
rarecurve(rare_arrA0.1, step=1, col = c("black", "red", "forestgreen", 
                                             "orange", "blue", "yellow", "hotpink"), 
          label = TRUE, cex=0.4)

#########################
#arsD DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arsD0.1=read.delim(file = paste(wd, 
                                "/data/arsD_rformat_dist_0.1.txt", 
                                sep=""))

#add row names back
rownames(arsD0.1)=arsD0.1[,1]

#remove first column
arsD0.1=arsD0.1[,-1]

#make data matrix
arsD0.1=data.matrix(arsD0.1)

#i removed first column, it is "X"
arsD0.1=arsD0.1[,-1]

#make an output of total gene count per site
arsD0.1.gcounts=rowSums(arsD0.1)

#otu table for aioA0.3
otu_arsD0.1=otu_table(arsD0.1, taxa_are_rows = FALSE)
head(otu_arsD0.1)
#see rarefaction curve
rarecurve(otu_arsD0.1, step=5, col=col, label = TRUE, cex=0.5)

#rarefy
rare_arsD0.1=rarefy_even_depth(otu_arsD0.1, 
                               sample.size = min(sample_sums(otu_arsD0.1)), 
                               rngseed = TRUE)

#check curve
rarecurve(rare_arsD0.1, step=1, col = c("black", "red", "forestgreen", 
                                        "orange", "blue", "yellow", "hotpink"), 
          label = TRUE, cex=0.4)
