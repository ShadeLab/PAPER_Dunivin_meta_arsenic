#change gene name!!!
#load required packages
library(tidyverse)

#set up environment
wd <- paste(getwd())

colnames(labels) <- c("Label", "OTU")
labels$OTU <- gsub(" ", "", labels$OTU)

#read in OTU table 
arsD.table <- read.delim(paste(wd, "/data/arsD_rformat_dist_0.1.txt", sep = ""), header = TRUE)
arsD.table <- rename(arsD.table, Sample = X)

#read in metadata
meta <- data.frame(read.delim(paste(wd, "/data/metadata_map.txt", 
                                    sep=""), sep="\t", header=TRUE))

#read in rplB data
rplB <- read.delim(paste(wd, "/output/rplB.summary.scg.txt", sep = ""), header = TRUE, sep = " ")

#add census data for normalization purposes
table.census <- arsD.table %>%
  left_join(rplB, by = "Sample")

#normalize data
table.normalized <- cbind(table.census$Sample, 
      data.frame(apply(table.census[,2:ncol(table.census)], 2, function(x) x/table.census$sum.rplB)))

#rename Sample column
table.normalized$Sample <- table.normalized$`table.census$Sample`
table.normalized <- table.normalized[,-1]

#order based on temperature
table.normalized <- table.normalized %>%
  left_join(meta, by = "Sample") %>%
  select(-c(Biome, Site, sum.rplB))

#transform otu table
table.normalized.t = setNames(data.frame(t(table.normalized[,-ncol(table.normalized)])), 
                              table.normalized[,ncol(table.normalized)])
#make OTUs a column
table.normalized.t$OTU <- rownames(table.normalized.t)

#add name to first column
table.normalized.t$OTU <- gsub(" ", "", table.normalized.t$OTU)

#fix OTU names with weird # before them
#table.normalized.t$OTU <- gsub(".OTU_", "OTU_", table.normalized.t$OTU)

#fix label names
#labels$OTU <- gsub("TU_0003", "OTU_0003", labels$OTU)
#labels$OTU <- gsub("TU_0005", "OTU_0005", labels$OTU)
#labels$OTU <- gsub(".OTU_", "OTU_", labels$OTU)

#add leading zero to 4 digits
library(stringr)
rownames(table.normalized.t) <- gsub("OTU_", "", rownames(table.normalized.t))
rownames(table.normalized.t) <- sprintf("%04s", rownames(table.normalized.t))
rownames(table.normalized.t) <- paste("OTU_", rownames(table.normalized.t), sep="")
table.normalized.t$OTU <- rownames(table.normalized.t)

#remove OTU information
label.abund <- select(label.abund, -OTU)
m <- ncol(table.normalized.t) -1
label.abund <- table.normalized.t[,c(ncol(table.normalized.t), 1:m)]

#save file
write.csv(label.abund, paste(wd, "/../phylogenetic_analysis/arsD_0.1_abund_label.csv", sep = ""), row.names = FALSE, quote = FALSE)




