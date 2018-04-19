#load required packages
library(tidyverse)
library(stringr)

#set up environment
wd <- paste(getwd())

#read in OTU table 
filenames <- c("aioA_rformat_dist_0.1.txt", "arrA_rformat_dist_0.1.txt", "arxA_rformat_dist_0.1.txt")

#make dataframes of all OTU tables
for(i in filenames){
  filepath <- file.path(paste(wd, "/data", sep = ""),paste(i,sep=""))
  assign(gsub("_rformat_dist_0.1.txt", "", i), read.delim(filepath,sep = "\t"))
}

#write OTU naming function
naming <- function(i) {
  #add leading zero to 4 digits
  colnames(i) <- gsub("OTU_", "", colnames(i))
  colnames(i) <- sprintf("%04s", colnames(i))
  colnames(i) <- paste("OTU", colnames(i), sep="")
}

#change OTU to gene name
colnames(arrA) <- naming(arrA)
colnames(arrA) <- gsub("OTU", "arrA_", colnames(arrA))
arrA <- rename(arrA, Site = `arrA_000X`)
colnames(aioA) <- naming(aioA)
colnames(aioA) <- gsub("OTU", "aioA_", colnames(aioA))
aioA <- rename(aioA, Site = `aioA_000X`)
colnames(arxA) <- naming(arxA)
colnames(arxA) <- gsub("OTU", "arxA_", colnames(arxA))
arxA <- rename(arxA, Site = `arxA_000X`)


#join together all files
otu_table <- aioA %>%
  left_join(arrA, by = "Site") %>%
  left_join(arxA, by = "Site")

#adjust table 
otu_table$Site <- gsub("cen", "Cen", otu_table$Site)

#read in metadata
meta <- data.frame(read.delim(paste(wd, "/data/sample_map.txt", sep=""), sep=" ", header=TRUE))

#read in rplB data
rplB <- read.delim(paste(wd, "/output/rplB.summary.scg.txt", sep = ""), header = TRUE, sep = " ")

#add census data for normalization purposes
table.census <- rplB %>%
  rename(Site = Sample) %>%
  mutate(Site = gsub("cen", "Cen", Site)) %>%
  right_join(otu_table, by = "Site") %>%
  rename(rplB = sum.rplB)

#normalize data
table.normalized <- cbind(Site = table.census$Site, 
                          data.frame(apply(table.census[,3:ncol(table.census)], 2, function(x) x/table.census$rplB)))

#transform otu table
table.normalized.t = setNames(data.frame(t(table.normalized[,-c(1,ncol(table.normalized))])), 
                              table.normalized[,1])
#replace all NAs with zeros
table.normalized.t[is.na(table.normalized.t)] <- 0

#remove columns that are empty
table.normalized.t <- table.normalized.t %>%
  select(Permafrost_Russia13.3, Mangrove70.3, Mangrove02.3, Cen13, Cen16, Cen05)

#remove rows where sum = 0
table.normalized.t <- table.normalized.t[!rowSums(table.normalized.t) == 0,]

#save file
write.csv(table.normalized.t, paste(wd, "/output/dissim_abund_label.csv", sep = ""),row.names = TRUE, quote = FALSE)

print(max(rowSums(table.normalized.t)))
print(min(rowSums(table.normalized.t)))
print(mean(rowSums(table.normalized.t)))



