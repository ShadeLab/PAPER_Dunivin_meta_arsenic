#load required packages
library(tidyverse)
library(reshape2)
library(zoo)

##############
#PREPARE DATA#
##############

#print working directory
wd=print(getwd())

#read in data
data <- read.delim(file = paste(wd, "/data/coglist64105_01-may-2017.txt", sep = ""))

#read in functional categories
func <- read.delim(file = paste(wd, "/data/cog.categories.txt", sep = ""))

#add func data & column for total isolate genomes
#5/1/17 there are 44979 isolate genomes
#ignore metaG since JGI already normalizes to metaG
data <- data %>%
  mutate(isolates = 51515) %>%
  inner_join(func, by = "COG.ID")
  

#calculate number of each COG per genome/ metagenome
data <- mutate(data, 
               Genomes = Isolate.Genome.Count / isolates)

########################
#TEST SINGLE COPY GENES#
########################
#list single copy genes (scgs) from tringe paper
tringe <- c("COG0016","COG0048","COG0049","COG0051","COG0052","COG0072","COG0080","COG0081","COG0087","COG0088", "COG0090", "COG0091","COG0092","COG0093","COG0094","COG0096","COG0097","COG0098","COG0099","COG0100","COG0103","COG0127","COG0149","COG0164","COG0184","COG0185","COG0186","COG0197","COG0200","COG0244","COG0256","COG0343","COG0481","COG0504","COG0532","COG0533","COG0541")

#list scgs used by microbe census
census <- c("COG0052", "COG0081", "COG0532", "COG0091", 'COG0088', 'COG0090', "COG0103", 'COG0087', "COG0072", "COG0093", "COG0098", "COG0185", "COG0049", "COG0197", "COG0099", "COG0016", "COG0200", "COG0097", "COG0080", "COG0094", "COG0048", "COG0092", "COG0100", "COG0244", "COG0096", "COG0256", "COG0184", "COG0186", "COG0102", "COG0198")

#look at COGs with tring and microbeCensus scgs
tringe <- data[which(data$COG.ID %in% tringe),]
census <- data[which(data$COG.ID %in% census),]

#join tringe and census data to compare
#but label which COGs are which
tringe <- mutate(tringe, source = "tringe")
census <- mutate(census, source = "census")
scgs <- rbind(tringe, census)

#plot different scgs to compare
(scg.var <- ggplot(scgs, aes(x = source, y= Genomes)) + 
    geom_boxplot() +
    geom_jitter(aes(color = Catergory)) + 
    xlab("Single copy gene source") +
    ylab("COG count per genome"))

#save plot for future reference/ discussion of scgs
ggsave(scg.var, filename = paste(wd, "/figures/scg.variation.png", sep=""), width = 7, height = 5)

#microbeCensus scg choices show less variation than Tringe's
#Both sets average around 1.1 copies per genome, which is acceptable
#microbeCensus uses all 1 func catergory while Tringe has several 


####################################################
#WHICH GENES ARE OVERREPRESENTED IN ISOLATE GENOMES#
####################################################

#view variation in COG genome representation by functional group
(func.abund <- ggplot(data, aes(x = Catergory, y = Genomes)) +
   geom_boxplot() + 
   geom_jitter() + 
   coord_flip())

#not particularly useful plots
#does show scg pattern of ~1 (translation, ribosomal struct &biogen)
#lots of variation by COG



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

#get Gene.Count sums for each gene of interest
metag.abund <- metag %>%
  separate(id, into = c("id", "COG.ID", "end"), sep = c(13, -23)) %>%
  group_by(COG.ID) %>%
  summarise(Abundance = sum(Gene.Count), StDev = sd(Gene.Count)) 

#COG0052 count is 4945293
#normalize abundance to abundance of single copy gene
metag.abund <- metag.abund %>%
  mutate(scg = 4945293, 
         Metagenomes = Abundance / scg, 
         StDeV = StDev / 4945293)

##prep isolate genome data
#select AsRG COGs and chosen single copy gene (COG0052)
ars <- c("COG0798", "COG1055", "COG1393", "COG0003", "COG0640", "COG2345", "COG4860", "COG0052")

#subset data based on AsRG cogs
ars <- data[which(data$COG.ID %in% ars),]

#tidy isolate data and join with metagenome dataset
abund <- ars %>%
  select(COG.ID, COG.Name, Genomes) %>%
  inner_join(y = metag.abund, by = "COG.ID") 

#tidy final data
abund <- melt(abund, id.vars = c("COG.ID", "COG.Name"), measure.vars = c("Genomes", "Metagenomes"), variable.name = "Source", value.name = "Abundance")

#plot AsRG COG proportions in genomes and metagenomes
(ars.plot <- ggplot(abund, aes(x = COG.Name, y = Abundance, fill = Source)) +
    geom_bar(stat = "identity", position = "dodge") +
    guides(fill=guide_legend(title="Dataset")) +
    ylab("COG Proportion (count per genome)") + 
    xlab("COG Name") +
    theme_bw(base_size = 12) +
    scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 15)))

#save comparison plot
ggsave(ars.plot, filename = paste(wd, "/figures/AsRG.proportions.png", sep=""), height = 6, width = 13)

#Some AsRG appear underrepresented in isolate genomes while 
#arsC-glut is over-represented; arsC_glut is in E.coli, which
#may explain some of this discrepancy 
#metaG data makes more sense since it has higher arsenite efflux pump 
#abundance than arsenate redcutase; an arsenate reductase is not useful
#without an arsenite efflux pump 
#as always, I do not really trust arsR COG data


############################################################
#WHAT IS THE DISTRIBUTION OF arsB IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG0798: Arsenite efflux pump ArsB, ACR3 family

#read in COG0798 data
arsB <- read.delim(file = paste(wd, "/data/arsB_COG0798_01-may-2017.txt", sep = ""))

#read in taxonomy data
taxa <- read_delim(file = paste(wd, "/data/taxontable51515_04-may-2017.xls", sep = ""), col_names = TRUE, delim = "\t")

#change sample name to genome
taxa.arsB <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  right_join(arsB, by = "Genome") %>%
  mutate(Gene = "arsB")

#remove rows with no taxon ID
taxa.arsB <- taxa.arsB[!is.na(taxa.arsB$taxon_oid),]

#remove any duplicate rows 
taxa.arsB <- taxa.arsB[!duplicated(taxa.arsB$Genome),]

#calculate the actual percentage of genomes with >=1 copy of arsB
perc.arsB <- count(arsB) / 51515
#output: 0.3049209 have 1 copy of arsB

#plot COG0798 data (arsB)
(arsB.hist <- ggplot(arsB, aes(x = Gene.Count)) +
    geom_bar(fill = "black") +
    ylab("Genome count") +
    xlab("Arsenite efflux pump genes / genome") +
    scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7)) + 
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(arsB.hist, filename = paste(wd, "/figures/arsB.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

#plot a histogram of isolates from different phyla with arsB
(arsB.phyla <- ggplot(taxa.arsB, aes(x = reorder(Phylum, Phylum, function(x)-length(x)))) +
    geom_histogram(stat="count") +
    xlab("Phylum") +
    ylab("Number of Isolate Genomes") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(arsB.phyla, filename = paste(wd, "/figures/arsB.isolates.phyla.png", sep=""), width = 8.5, height = 7)

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

#remove rows with no taxon ID
taxa.arsC <- taxa.arsC[!is.na(taxa.arsC$taxon_oid),]

#remove any duplicate genomes
taxa.arsC <- taxa.arsC[!duplicated(taxa.arsC$Genome),]

#calculate actual percent of orgs with >=1 copy arsC_glut
perc.arsC <- count(taxa.arsC) / 51515
#output = 0.7394545

#plot COG1393 data (arsC)
(arsC.hist <- ggplot(taxa.arsC, aes(x = Gene.Count)) +
    geom_bar(fill = "black") +
    ylab("Genome count") +
    xlab("Arsenate reductase, glutaredoxin family / genome") +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(arsC.hist, filename = paste(wd, "/figures/arsC.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

#plot a histogram of isolates from different phyla with arsB
(arsC.phyla <- ggplot(taxa.arsC, aes(x = reorder(Phylum, Phylum, function(x)-length(x)))) +
    geom_histogram(stat="count") +
    xlab("Phylum") +
    ylab("Number of Isolate Genomes") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(arsC.phyla, filename = paste(wd, "/figures/arsC.isolates.phyla.png", sep=""), width = 8.5, height = 7)

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

#remove rows with no taxon ID
taxa.arsA <- taxa.arsA[!is.na(taxa.arsA$taxon_oid),]

#remove duplicated rows
taxa.arsA <- taxa.arsA[!duplicated(taxa.arsA$Genome),]

#calculate actual percent of orgs with >=1 copy arsA
perc.arsA <- count(arsA) / 51515
#output = 0.1974765

#plot COG0003 data (arsA)
(arsA.hist <- ggplot(taxa.arsA, aes(x = Gene.Count)) +
    geom_bar(fill = "black") +
    ylab("Genome count") +
    xlab("arsA / genome") +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(arsA.hist, filename = paste(wd, "/figures/arsA.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

#plot a histogram of isolates from different phyla with arsA
(arsA.phyla <- ggplot(taxa.arsA, aes(x = reorder(Phylum, Phylum, function(x)-length(x)))) +
    geom_histogram(stat="count") +
    xlab("Phylum") +
    ylab("Number of Isolate Genomes") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(arsA.phyla, filename = paste(wd, "/figures/arsA.isolates.phyla.png", sep=""), width = 8.5, height = 7)

#########################################################################
#WHAT IS THE DISTRIBUTION OF arsnite premeases IN EACH GENOME (#/GENOME)#
#########################################################################

##COG1055: ArsB Na+/H+ antiporter NhaD and related arsenite permeases

#read in COG1055 data
asp <- read.delim(file = paste(wd, "/data/asp_COG1055_05-may-2017.txt", sep = ""))

#change sample name to genome and join with arsA data
taxa.asp <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  right_join(asp, by = "Genome") %>%
  mutate(Gene = "asp")

#remove rows with no taxon ID
taxa.asp <- taxa.asp[!is.na(taxa.asp$taxon_oid),]

#remove duplicated rows
taxa.asp <- taxa.asp[!duplicated(taxa.asp$Genome),]

#calculate actual percent of orgs with >=1 copy arsA
perc.asp <- count(asp) / 51515
#output = 0.6037271

#plot COG0003 data (asp)
(asp.hist <- ggplot(taxa.asp, aes(x = Gene.Count)) +
    geom_bar(fill = "black") +
    ylab("Genome count") +
    xlab("Arsenite permease COGs / genome") +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(asp.hist, filename = paste(wd, "/figures/asp.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)

#plot a histogram of isolates from different phyla with arsA
(asp.phyla <- ggplot(taxa.asp, aes(x = reorder(Phylum, Phylum, function(x)-length(x)))) +
    geom_histogram(stat="count") +
    xlab("Phylum") +
    ylab("Number of Isolate Genomes") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asp.phyla, filename = paste(wd, "/figures/asp.isolates.phyla.png", sep=""), width = 8.5, height = 7)
####################################################################
#WHAT IS THE DISTRIBUTION OF arsA,B,C IN GENOMES OF DIFFERENT PHYLA#
####################################################################

#join together all AsRG phylum data
taxa.asrg <- rbind(taxa.arsA, taxa.arsB, taxa.arsC, taxa.asp)

#trim file so it only contains phyla with highest abundance
taxa.asrg <- taxa.asrg %>%
  group_by(Gene, Phylum) %>%
  mutate(N = length(Phylum))

#make a slim version of dataset (only abundant phyla for plotting)
taxa.asrg.slim <- taxa.asrg[which(taxa.asrg$N > 100),]

#plot a histogram of isolates from different phyla with arsA
(asrg.phyla <- ggplot(taxa.asrg.slim, aes(x = reorder(Phylum, Phylum, function(x)-length(x)), fill = Gene)) +
    geom_histogram(stat="count", position = "dodge", color = "black") +
    xlab("Phylum") +
    ylab("Number of Isolate Genomes") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(asrg.phyla, filename = paste(wd, "/figures/AsRG.isolates.abundant.phyla.png", sep=""), height = 5, width = 7)


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

#Plot proportions of phyla with AsRGs
(prop.asrg.phyla <- ggplot(phyla.summary, 
                           aes(x = Phylum, y = Proportion, fill = Gene)) +
    geom_bar(stat="identity") +
    xlab("Phylum") +
    ylab("Proportion of Genomes with Arsenic Resistance Gene") +
    facet_wrap(~Gene, ncol = 1) +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(prop.asrg.phyla, filename = paste(wd, "/figures/AsRG.proportions.phyla.png", sep=""), width = 20, height = 12)


###########################################
#ARE ASRG COMMON IN THERMOPHILIC LINEAGES?#
###########################################

#Read in name of all thermophiles from JGI
#only includes genomes with GOLD information
thermo.all <- read_delim(file = paste(wd, "/data/taxontable.thermophiles.04-may-2017.txt", sep = ""), col_names = TRUE, delim = "\t")

#count number of each phylum
thermo.all <- thermo.all %>%
  group_by(Phylum) %>%
  mutate(Total = length(Phylum))

#check how many thermophile genomes have arsA, B, C
thermo.all.asrg <- thermo.all %>%
  select(Genome, Total, Phylum) %>%
  right_join(taxa.asrg, by = "Genome")
thermo.all.asrg <- thermo.all.asrg[!is.na(thermo.all.asrg$Phylum.x),]

#Plot number of thermophiles with AsRGs
(thermo.all.asrg.phyla <- ggplot(thermo.all.asrg, aes(x = Phylum.x, fill = Gene)) +
    geom_histogram(stat="count") +
    xlab("Phylum") +
    ylab("Thermophilic Genomes with Arsenic Resistance Gene") +
    facet_wrap(~Gene, ncol = 1) +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(thermo.all.asrg.phyla, filename = paste(wd, "/figures/thermo.AsRG.phyla.png", sep=""))

#calculate the proportion of each phylum that has arsA, B, C
thermo.all.asrg <- thermo.all.asrg %>%
  group_by(Gene, Phylum.x) %>%
  mutate(With = length(Phylum.x), Proportion = With/Total, 
         Classification = "Thermophile") %>%
  rename(Phylum = Phylum.x) %>%
  select(Phylum, Gene, Total, With, Proportion, Classification) 

thermo.all.asrg  <- thermo.all.asrg[!duplicated(thermo.all.asrg),]

#plot proportion of thermophiles with AsRGs
(prop.asrg.phyla.thermo.all <- ggplot(thermo.all.asrg, aes(x = Phylum, y = Proportion, fill = Gene)) +
    geom_bar(stat="identity") +
    xlab("Phylum") +
    ylab("Thermophilic Genomes with AsRGs (%)") +
    facet_wrap(~Gene, ncol = 1) +
    theme_bw(base_size = 20) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

ggsave(prop.asrg.phyla.thermo.all, filename = paste(wd, "/figures/thermo.AsRG.proportions.phyla.png", sep=""), height = 15)

#############################################################
#ARE THERMOPHILES MORE LIKELY TO HAVE ASRGS THAN MESOPHILES?#
#############################################################
#read in data from thermophiles, mesophiles, and hyperthermophiles
#GOLD database entries only
thermo <- read_delim(file = paste(wd, "/data/thermo_gold_taxontable_05-may-2017.txt", sep = ""), col_names = TRUE, delim = "\t")

hyperthermo <- read_delim(file = paste(wd, "/data/hyperthermo_gold_taxontable_05-may-2017.txt", sep = ""), col_names = TRUE, delim = "\t")

meso <- read_delim(file = paste(wd, "/data/meso_gold_taxontable_05-may-2017.txt", sep = ""), col_names = TRUE, delim = "\t")

#add naming column to each file before binding
thermo <- thermo %>%
  mutate(Classification = "Thermophile") %>%
  group_by(Classification, Phylum) 


hyperthermo <- hyperthermo %>%
  mutate(Classification = "Hyperthermophile") %>%
  group_by(Classification, Phylum)


meso <- meso %>%
  mutate(Classification = "Mesophile") %>%
  group_by(Classification, Phylum)


#join together all three datasets
thermo.group.c <- rbind(meso, thermo, hyperthermo)

#select important columns only
thermo.group <- thermo.group.c %>%
  left_join(taxa.asrg, by = "Genome") %>%
  group_by(Classification, Gene, Phylum.x) %>%
  mutate(Count = sum(Gene.Count)) %>%
  rename(Phylum = Phylum.x) %>%
  select(Genome, Phylum.y:Species.y, Classification, Gene.Count)

#replace NAs for zeros
thermo.group$Gene.Count[is.na(thermo.group$Gene.Count)] = 0

#replace NAs for "none" in gene column 
thermo.group$Gene[is.na(thermo.group$Gene)] = "None"

thermo.group <- thermo.group %>%
  ungroup() %>%
  group_by(Classification, Gene, Phylum) 

thermo.group <- thermo.group %>%
  mutate(Phylum.count = length(Phylum)) %>%
  mutate(Gene.per.genome = Gene.Count/Phylum.count) %>%
  group_by(Classification, Gene, Phylum) %>%
  select(Gene, Phylum, Classification:Gene.per.genome)

#order classification levels
thermo.group$Classification <- ordered(thermo.group$Classification, levels = c("Hyperthermophile", "Thermophile", "Mesophile"))

#plot  
(thermo.plot <- ggplot(thermo.group, aes(x = Phylum, y = Gene.per.genome, fill = Gene)) +
    geom_bar(stat="identity") +
    xlab("Phylum") +
    ylab("Thermophilic Genomes with AsRGs (%)") +
    facet_wrap(~Classification) +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))


scale_fill_manual(values=c("red", "orange", "khaki")) + 
  



#broken...
thermo.group <- thermo.group.c %>%
  select(Phylum, Phylum.count) %>%
  right_join(thermo.group, by = "Phylum")

thermo.group <- thermo.group[!duplicated(thermo.group),]

#widen dataset to make appropriate zeros
thermo.group.wide <- thermo.group %>%
  spread(Gene, value = Count, fill = 0) %>%
  rename(Classification = Classification.x)
  group_by(Classification, Phylum) %>%
  rename(None = `<NA>`)

#tidy the data once again
thermo.group.final <- melt(thermo.group.wide, id.vars = c("Classification", "Phylum", "Phylum.count"), measure.vars = c("arsA", "arsB", "arsC", "asp"), variable.name = "Gene", value.name = "Count")

#add a true false variable
thermo.group.final$Count <- gsub(0, NA, thermo.group.final$Count)
thermo.group.final.tf <- thermo.group.final %>%
  group_by(Classification, Phylum, Gene) %>%
  mutate(Present = paste(is.na(Count)))

thermo.group.final.tf$Present <- gsub("FALSE", "Present", thermo.group.final.tf$Present)
thermo.group.final.tf$Present <- gsub("TRUE", "Absent", thermo.group.final.tf$Present)

thermo.group.final.tf$Classification <- ordered(thermo.group.final.tf$Classification, levels = c("Hyperthermophile", "Thermophile", "Mesophile"))
#plot  
(thermo.group.plot <- ggplot(thermo.group.final.tf, aes(x = Present, fill = Classification)) +
    geom_histogram(stat="count") +
    scale_fill_manual(values=c("red", "orange", "khaki")) + 
    xlab("Phylum") +
    ylab("Thermophilic Genomes with AsRGs (%)") +
    facet_wrap(~Gene) +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))
  
  
  
  
  
  
  
  