#change gene name!!!
#load required packages
library(tidyverse)

#set up environment
wd <- paste(getwd())

#read in OTU table 
arsC_thio.table <- read.delim(paste(wd, "/data/arsC_thio_rformat_dist_0.1.txt", sep = ""), header = TRUE)
arsC_thio.table <- rename(arsC_thio.table, Sample = X)

#read in metadata
meta <- data.frame(read.delim(paste(wd, "/data/sample_map.txt", 
                                    sep=""), sep="\t", header=TRUE))

#read in rplB data
rplB <- read.delim(paste(wd, "/output/rplB.summary.scg.txt", sep = ""), header = TRUE, sep = " ")

#add census data for normalization purposes
table.census <- arsC_thio.table %>%
  right_join(rplB, by = "Sample")

#replace NA values with zero
table.census[is.na(table.census)] <- 0

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
#table.normalized.t$OTU <- rownames(table.normalized.t)

#add name to first column
#table.normalized.t$OTU <- gsub(" ", "", table.normalized.t$OTU)

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

#save file
write.csv(table.normalized.t, paste(wd, "/../../phylogenetic_analysis/arsC_thio_0.1_abund_label.csv", sep = ""), row.names = TRUE, quote = FALSE)





