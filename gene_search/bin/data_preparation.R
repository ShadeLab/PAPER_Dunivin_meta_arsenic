#######################################
#READ IN AND PREPARE DATA FOR ANALYSIS#
#######################################

#load dependencies or install 
library(tidyverse)

#print working directory for future references
wd <- print(getwd())

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data", sep = ""))

#read in abundance data
names=list.files(pattern="*.tbl.txt")
data <- do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read.table(X))}))

#remove unnecessary columns
data <- data %>%
  mutate(id = gsub(".0.0000000001.tbl.txt", "", id)) %>%
  separate(col = id, into = c("Gene", "Sample"), sep = "[.]", extra = "merge") %>%
  select(-c(V2, V5, V23))

#add column names
#known from http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf
colnames(data) <- c("Gene", "Sample", "t.name", "t.length", "q.name", "q.length", "e.value", "score1", "bias1", "#", "of", "c.evalue", "i.evalue", "score2", "bias2", "from.hmm", "to.hmm", "from.ali", "to.ali", "from.env", "to.env", "acc", "NCBI.ID")

#Calculate the length of the alignment
data <- data %>%
  mutate(length = to.ali - from.ali) %>%
  mutate(perc.ali = length / q.length)

#remove rows that do not have at least 70% of hmm length (std)
data.90 <- data[which(data$perc.ali > 0.90 & data$score1 > 90 & data$acc > 0.80),]


#examine if any HMM hits apply to two genes
duplicates <- data.90[duplicated(data.90$t.name),]
#12 hits are duplicates

#of the duplicates, all are arrA/aioA mixed hits
#we will accept the one with a higher score
#arrange data by score
data.90 <- data.90[order(data.90$t.name, abs(data.90$score1), decreasing = TRUE), ] 

#remove duplicates that have the lower score
data.90 <- data.90[!duplicated(data.90$t.name),]

#save table to output
write.table(data.90, paste(wd, "/output/AsRG_summary.txt", sep = ""), sep = "\t", quote = FALSE, row.names = FALSE)
