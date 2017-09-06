#load required packages
library(tidyverse)
library(reshape2)
library(zoo)

##############
#PREPARE DATA#
##############

#print working directory
wd <- print(getwd())

#read in data for isolate and metagenome COG counts
data <- read.delim(file = paste(wd, "/data/coglist64105_01-may-2017.txt", sep = ""))

#read in COG functional categories
func <- read.delim(file = paste(wd, "/data/cog.categories.txt", sep = ""))

#add func data & column for total isolate genomes
#5/1/17 there are 44979 isolate genomes
#ignore metaG since JGI already normalizes to metaG
data <- data %>%
  mutate(isolates = 51515) %>%
  inner_join(func, by = "COG.ID")
  

#calculate number of each COG per genome
data <- mutate(data, 
               Genomes = Isolate.Genome.Count / isolates)

########################
#TEST SINGLE COPY GENES#
########################
#list scgs used by microbe census
census <- c("COG0052", "COG0081", "COG0532", "COG0091", 'COG0088', 'COG0090', "COG0103", 'COG0087', "COG0072", "COG0093", "COG0098", "COG0185", "COG0049", "COG0197", "COG0099", "COG0016", "COG0200", "COG0097", "COG0080", "COG0094", "COG0048", "COG0092", "COG0100", "COG0244", "COG0096", "COG0256", "COG0184", "COG0186", "COG0102", "COG0198")

#extract COGs with microbeCensus scgs
scg <- data[which(data$COG.ID %in% census),]

#plot different scgs to compare
(scg.var <- ggplot(scg, aes(x = Catergory, y= Genomes)) + 
    geom_boxplot() +
    geom_jitter() + 
    xlab("Single copy gene source") +
    ylab("COG count per genome"))

#save plot for future reference/ discussion of scgs
ggsave(scg.var, filename = paste(wd, "/figures/scg.variation.png", sep=""), width = 4, height = 3)

#continue with microbe census single copy genes for normalization

###################################################
#COMPARE ABUNDANCE IN GENOMES VS IN METAGENOME GEs#
###################################################

##prep metagenome data
#read in all metaG files with counts of genes of interest
#written to incorporate date files were downloaded
#change if you have unwanted files with same date specifications
names=list.files(path = paste(wd, "/data/", sep = ""), pattern="*02-may-2017*")
setwd(paste(wd, "/data/", sep = ""))
metag=do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read.delim(X))}))
setwd("../")

#remove all metatranscriptome data as we are only
#interested in metagenomes in this analysis
metag <- metag[!grepl("transcriptome", metag$Genome),]

#get Gene.Count sums for each gene of interest
metag.abund <- metag %>%
  separate(id, into = c("id", "COG.ID", "end"), sep = c(13, -23)) %>%
  group_by(COG.ID) %>%
  summarise(Abundance = sum(Gene.Count), StDev = sd(Gene.Count)) 

#Extract COG0052 count for normalization is 4616128
n <- metag.abund$Abundance[metag.abund$COG.ID == "COG0052"]

#normalize abundance to abundance of single copy gene
metag.abund <- metag.abund %>%
  mutate(scg = n, 
         Metagenomes = Abundance / scg, 
         StDeV = StDev / n)

##prep isolate genome data
#select AsRG COGs and chosen single copy gene (COG0052)
ars <- c("COG0798", "COG1393", "COG0003", "COG0052")

#subset data based on AsRG cogs
ars <- data[which(data$COG.ID %in% ars),]

#join isolate data with metagenome dataset
abund <- ars %>%
  select(COG.ID, COG.Name, Genomes) %>%
  inner_join(y = metag.abund, by = "COG.ID") 

#tidy final data
abund <- melt(abund, id.vars = c("COG.ID", "COG.Name"), measure.vars = c("Genomes", "Metagenomes"), variable.name = "Source", value.name = "Abundance")

#plot AsRG COG proportions in genomes and metagenomes
(ars.plot <- ggplot(abund, aes(x = COG.Name, y = Abundance, fill = Source)) +
    geom_bar(stat = "identity", position = "dodge", color = "black") +
    guides(fill=guide_legend(title="Dataset")) +
    scale_fill_manual(values = c("grey49", "grey89")) +
    ylab("COG Proportion (count per genome)") + 
    xlab("COG Name") +
    theme_bw(base_size = 12) +
    scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 15)))

#save comparison plot
#note these comparisons do NOT account for multiple AsRG copies per genome
#this is purposeful since we cannot know that for metaG. 
#see files created later (perc.GENE) for +/- genome percentages
ggsave(ars.plot, filename = paste(wd, "/figures/AsRG.proportions.png", sep=""))

############################################################
#WHAT IS THE DISTRIBUTION OF acr3 IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG0798: Arsenite efflux pump arsB, ACR3 family

#read in COG0798 data
acr3 <- read.delim(file = paste(wd, "/data/arsB_COG0798_01-may-2017.txt", sep = ""))

#read in taxonomy data
taxa <- read_delim(file = paste(wd, "/data/taxontable51515_04-may-2017.xls", sep = ""), col_names = TRUE, delim = "\t")

#change sample name to genome
taxa.acr3 <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  right_join(acr3, by = "Genome") %>%
  mutate(Gene = "acr3")

#remove any duplicate rows 
taxa.acr3 <- taxa.acr3[!duplicated(taxa.acr3$Genome),]

#calculate the actual percentage of genomes with >=1 copy of acr3
perc.acr3 <- count(acr3) / 51515

#plot COG0798 data (acr3)
(acr3.hist <- ggplot(acr3, aes(x = Gene.Count)) +
    geom_bar(fill = "#8DD3C7", color= "black") +
    ylab("Genome count") +
    xlab("Arsenite efflux pump genes / genome") +
    xlim(0,18) +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(acr3.hist, filename = paste(wd, "/figures/acr3.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

############################################################
#WHAT IS THE DISTRIBUTION OF arsC IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG1393: Arsenate reductase and related proteins, glutaredoxin family

#read in COG1393 data
arsC <- read.delim(file = paste(wd, "/data/arsC_COG1393_03-may-2017.txt", sep = ""))

#change sample name to genome and join with arsC data
taxa.arsC <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  right_join(arsC, by = "Genome") %>%
  mutate(Gene = "arsC")

#remove any duplicate genomes
taxa.arsC <- taxa.arsC[!duplicated(taxa.arsC$Genome),]

#calculate actual percent of orgs with >=1 copy arsC_glut
perc.arsC <- count(taxa.arsC) / 51515

#plot COG1393 data (arsC)
(arsC.hist <- ggplot(taxa.arsC, aes(x = Gene.Count)) +
    geom_bar(fill = "#80B1D3", color = "black") +
    ylab("Genome count") +
    xlab("Arsenate reductase, glutaredoxin family / genome") +
    xlim(0,18) +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(arsC.hist, filename = paste(wd, "/figures/arsC.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

############################################################
#WHAT IS THE DISTRIBUTION OF arsA IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG0003: Arsenate reductase and related proteins, glutaredoxin family

#read in COG0003 data
arsA <- read.delim(file = paste(wd, "/data/arsA_COG0003_04-may-2017.txt", sep = ""))

#change sample name to genome and join with arsA data
taxa.arsA <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  right_join(arsA, by = "Genome") %>%
  mutate(Gene = "arsA")

#remove duplicated rows
taxa.arsA <- taxa.arsA[!duplicated(taxa.arsA$Genome),]

#calculate actual percent of orgs with >=1 copy arsA
perc.arsA <- count(arsA) / 51515

#plot COG0003 data (arsA)
(arsA.hist <- ggplot(taxa.arsA, aes(x = Gene.Count)) +
    geom_bar(fill = "#BC80BD", color = "black") +
    ylab("Genome count") +
    xlab("arsA / genome") +
    xlim(0,18) +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(arsA.hist, filename = paste(wd, "/figures/arsA.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

################################################
#IS THERE DATABASE BIAS IN THE PHYLA WITH ASRG?#
################################################
#More specifically, do proteobacteria actually have 
#lots of AsRG (arsC in particular)? Or are they just
#over represented in the current database? 

#Calculate the number of genomes from each phyla
db.phyla <- taxa %>%
  group_by(Phylum) %>%
  summarise(total = length(Phylum))

#Calculate the proportion of phyla with AsRGs
phyla.summary <- taxa.asrg %>%
  left_join(db.phyla, by = "Phylum") %>%
  group_by(Phylum, Gene) %>%
  select(Phylum, Gene, N, total) %>%
  mutate(Proportion = N/total)

#remove duplicated values
phyla.summary <- phyla.summary[!duplicated(phyla.summary),]

#make a slim version of dataset (only abundant phyla for plotting)
phyla.summary.top <- phyla.summary[which(phyla.summary$total > 100),]

#order by number of phylum representatives
phyla.summary.top$Phylum <- factor(phyla.summary.top$Phylum, levels = phyla.summary.top$Phylum[order(phyla.summary.top$total, decreasing = TRUE)])

#Plot proportions of phyla with AsRGs
(prop.asrg.phyla <- ggplot(phyla.summary.top, 
                           aes(x = Phylum, y = Proportion, fill = Gene)) +
    geom_bar(stat="identity", position = "dodge", color = "black") +
    xlab("Phylum") +
    ylab("Proportion of Genomes with Arsenic Resistance Gene") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(prop.asrg.phyla, filename = paste(wd, "/figures/AsRG.proportions.phyla.png", sep=""), width = 20, height = 12)
