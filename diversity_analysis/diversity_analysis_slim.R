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
