#load dependencies
library(tidyverse)
library(reshape2)
library(RColorBrewer)

#print working directory for future references
#note the GitHub directory for this script is as follows
#https://github.com/ShadeLab/meta_arsenic/tree/master/refsoil_analysis
wd <- print(getwd())

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data", sep = ""))

#read in abundance data
names=list.files(pattern="*r.txt")
data <- do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read.table(X))}))

#move back up a directory to proceed with analysis
setwd("../")
wd <- print(getwd())

#read in AsRG hmm length data
hmm <- read_delim(file = paste(wd, "/data/asrg_hmm_length.txt", sep = ""), 
                  delim = "\t")

#remove unnecessary columns
data <- data %>%
  select(-c(id,V23)) 

#add column names
#known from http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf
colnames(data) <- c("t.name", "t.accession", "t.length", "gene", 
                    "accession", "q.length", "e.value", "score1", "bias1", 
                    "#", "of", "c.evalue", "i.evalue", "score2", "bias2", 
                    "from.hmm", "to.hmm", "from.ali", "to.ali", "from.env", 
                    "to.env", "acc", "NCBI.ID")

#Calculate the length of the alignment
data <- data %>%
  mutate(length = to.ali - from.ali) %>%
  left_join(hmm, by = "gene") %>%
  mutate(perc.ali = length / hmm.length, perc.t = t.length/q.length)

#remove rows that do not have at least 70% of hmm length (std)
data.70 <- data[which(data$perc.ali > 0.70 & data$perc.t < 1.4 & 
                        data$perc.t > 0.6),]

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


#check that all AsRG hits match the first NCBI.ID
check <- data.70 %>%
  anti_join(ncbi, by = "NCBI.ID")
#151 hits do not match NCBI.ID #1


#join AsRG information with taxanomic data that match NCBI.ID #1, 2, 3
data.tax.ncbi1 <- ncbi %>%
  left_join(data.70, by = "NCBI.ID") 

data.tax.ncbi2 <- ncbi %>%
  rename(ncbi.id = NCBI.ID, NCBI.ID = NCBI.ID2) %>%
  left_join(data.70, by = "NCBI.ID") 

data.tax.ncbi3 <- ncbi %>%
  rename(ncbi.id = NCBI.ID, NCBI.ID = NCBI.ID3) %>%
  left_join(data.70, by = "NCBI.ID") 

#remove NA t.name rows from ncbi data.frames 2 and 3
#note do not officially remove NA from ncbi1 (need NAs downstream
#to note which orgs do NOT have AsRG)
data.tax.ncbi1.1 <- data.tax.ncbi1[!is.na(data.tax.ncbi1$t.name),]
data.tax.ncbi2 <- data.tax.ncbi2[!is.na(data.tax.ncbi2$t.name),]
data.tax.ncbi3 <- data.tax.ncbi3[!is.na(data.tax.ncbi3$t.name),]

#make sure number of matches is equal to total number (3385)
check <- nrow(data.tax.ncbi1.1) + nrow(data.tax.ncbi2) + nrow(data.tax.ncbi3)

#make colnames of all three datasets match
colnames(data.tax.ncbi2) <- colnames(data.tax.ncbi1)
colnames(data.tax.ncbi3) <- colnames(data.tax.ncbi1)

#combine all three datasets
data.tax <- rbind(data.tax.ncbi1, data.tax.ncbi2, data.tax.ncbi3)

#group data
data.tax <- data.tax %>%
  group_by(gene, Phylum, Class, Order, Family, Genus)

#change NA gene to "None"
data.tax$gene[is.na(data.tax$gene)] <- "None"

#remove NA's to protect them from duplicate removal step
data.tax.na <- data.tax[is.na(data.tax$t.length),]
data.tax <- data.tax[!is.na(data.tax$t.length),]

#examine if any HMM hits apply to two genes
duplicates <- data.tax[duplicated(data.tax$t.name),]
#4 hits are duplicates

#of the duplicates, all are arrA/aioA mixed hits
#we will accept the one with a higher score
#arrange data by score
data.tax <- data.tax[order(data.tax$t.name, abs(data.tax$score1), decreasing = TRUE), ] 

#remove duplicates that have the lower score
data.tax <- data.tax[!duplicated(data.tax$t.name),]

#make color scheme
n <- 25
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
phy.color <- print(sample(col_vector, n))

#plot bar chart with filled phyla
(asrg.phyla.bar <- ggplot(data = data.tax, aes(x = gene, fill = Phylum)) +
  geom_bar(stat = "count") +
  scale_fill_manual(values = phy.color) +
  ylab("Number of model hits") +
  xlab("gene") +
  theme_classic(base_size = 12))

#save plot
ggsave(asrg.phyla.bar, filename = paste(wd, "/figures/asrg.phyla.bar.png", 
                                        sep = ""), width = 10)

#summarise NCBI so that we know how many of each phyla are in the 922 
#genomes from Refsoil
ncbi.sum <- ncbi %>%
  group_by(Phylum) %>%
  summarise(phy.n = length(Phylum))

#join phy count information with data.tax
data.tax.sum <- data.tax %>%
  ungroup() %>%
  group_by(gene, Phylum) %>%
  summarise(gene.count = length(Phylum)) %>%
  left_join(ncbi.sum, by = "Phylum") %>%
  mutate(rel.count = gene.count / phy.n)
  

#order based on phylum abundance
data.tax.sum$Phylum <- factor(data.tax.sum$Phylum, 
                         levels = data.tax.sum$Phylum[order(data.tax.sum$rel.count)])

#plot proportional bar chart with filled phyla
(asrg.phyla.bar <- ggplot(data = data.tax.sum, aes(x = Phylum, y = rel.count, fill = Phylum)) +
    geom_bar(stat = "identity", color = "black") +
    scale_fill_manual(values = phy.color) +
    ylab("Proportion of Phyla with AsRG") +
    xlab("Phylum") +
    facet_wrap(~gene) +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90, size = 12, hjust=0.95,vjust=0.2), legend.position = "none"))

#save plot
ggsave(asrg.phyla.bar, filename = paste(wd, "/figures/asrg.rel.phyla.bar.png", sep = ""), width = 10)


#############################
#EXAMINE LOGICAL GENE COUNTS#
#############################

#remove rows resulting from more than one copy/ genome
data.tax.uniq <- data.tax[!duplicated(data.tax[c(2,21)]),]

#plot bar chart with filled phyla (+/- gene)
(asrg.logi.phyla.bar <- ggplot(data = data.tax.uniq, aes(x = gene, fill = Phylum)) +
    geom_bar(stat = "count") +
    scale_fill_manual(values = phy.color) +
    ylab("Number of genomes with gene (logical)") +
    xlab("gene") +
    theme_classic(base_size = 12))

#save plot
ggsave(asrg.logi.phyla.bar, filename = paste(wd, "/figures/asrg.logi.phyla.bar.png", sep = ""), width = 10)

#join phy count information with data.tax
data.tax.uniq.logi <- data.tax.uniq %>%
  group_by(gene, Phylum) %>%
  summarise(logi.count = length(Phylum)) %>%
  left_join(ncbi.sum, by = "Phylum") %>%
  mutate(rel.logi.count = logi.count / phy.n)

#order based on phylum abundance
data.tax.uniq.logi$Phylum <- factor(data.tax.uniq.logi$Phylum, 
                              levels = data.tax.uniq.logi$Phylum[order(data.tax.uniq.logi$rel.logi.count)])

#plot proportional bar chart (logical) with filled phyla
(asrg.logi.rel.phyla.bar <- ggplot(data = data.tax.uniq.logi, aes(x = Phylum, y = rel.logi.count, fill = Phylum)) +
    geom_bar(stat = "identity", color = "black") +
    scale_fill_manual(values = phy.color) +
    ylab("Proportion of of genomes with gene (logical)") +
    xlab("Phylum") +
    facet_wrap(~gene) +
    theme_classic(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90, size = 12, hjust=0.95,vjust=0.2), legend.position = "none"))

ggsave(asrg.logi.rel.phyla.bar, filename = paste(wd, "/figures/asrg.logi.rel.phyla.bar.png", sep = ""), width = 10)

