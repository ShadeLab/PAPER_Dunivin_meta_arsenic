###################
#PREPARE WORKSPACE#
###################

#load required packages
library(tidyverse)
library(reshape2)
library(zoo)

#print working directory
wd <- print(getwd())

############################################################
#WHAT IS THE DISTRIBUTION OF acr3 IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG0798: Arsenite efflux pump arsB, ACR3 family

#read in COG0798 data
acr3 <- read.delim(file = paste(wd, "/data/acr3_COG0798_01-may-2017.txt", sep = ""))

#read in taxonomy data
taxa <- read_delim(file = paste(wd, "/data/taxontable51515_04-may-2017.xls", sep = ""), col_names = TRUE, delim = "\t")

#change sample name to genome
taxa.acr3 <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  left_join(acr3, by = "Genome") %>%
  mutate(Gene = "acr3")

#remove any duplicate rows 
taxa.acr3 <- taxa.acr3[!duplicated(taxa.acr3$taxon_oid),]

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
ggsave(acr3.hist, filename = paste(wd, "/figures/acr3.genome.hist.eps", sep = ""), 
       height = 3.51, width = 5.69)

#replace all NA Gene.Count values with zeros 
taxa.acr3$Gene.Count[is.na(taxa.acr3$Gene.Count)] <- 0

############################################################
#WHAT IS THE DISTRIBUTION OF arsC IN EACH GENOME (#/GENOME)#
############################################################

##COG1393: Arsenate reductase and related proteins, glutaredoxin family

#read in COG1393 data
arsC <- read.delim(file = paste(wd, "/data/arsC_COG1393_03-may-2017.txt", sep = ""))

#change sample name to genome and join with arsC data
taxa.arsC <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  left_join(arsC, by = "Genome") %>%
  mutate(Gene = "arsC")

#remove any duplicate genomes
taxa.arsC <- taxa.arsC[!duplicated(taxa.arsC$taxon_oid),]

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
ggsave(arsC.hist, filename = paste(wd, "/figures/arsC.genome.hist.eps", sep = ""), 
       height = 3.51, width = 5.69)

#replace all NA Gene.Count values with zeros 
taxa.arsC$Gene.Count[is.na(taxa.arsC$Gene.Count)] <- 0

############################################################
#WHAT IS THE DISTRIBUTION OF arsA IN EACH GENOME (#/GENOME)#
############################################################

##COG0003: Arsenate reductase and related proteins, glutaredoxin family

#read in COG0003 data
arsA <- read.delim(file = paste(wd, "/data/arsA_COG0003_04-may-2017.txt", sep = ""))

#change sample name to genome and join with arsA data
taxa.arsA <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  left_join(arsA, by = "Genome") %>%
  mutate(Gene = "arsA")

#remove duplicated rows
taxa.arsA <- taxa.arsA[!duplicated(taxa.arsA$taxon_oid),]

#calculate actual percent of orgs with >=1 copy arsA
perc.arsA <- count(arsA) / 51515

#plot COG0003 data (arsA)
(arsA.hist <- ggplot(taxa.arsA, aes(x = Gene.Count)) +
    geom_bar(fill = "#BC80BD", color = "black") +
    ylab("Genome count") +
    xlab("arsA / genome") +
    xlim(0,18) +
    theme_bw(base_size = 12))

#save bar chart of genes encoding arsA
ggsave(arsA.hist, filename = paste(wd, "/figures/arsA.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)
ggsave(arsA.hist, filename = paste(wd, "/figures/arsA.genome.hist.eps", sep = ""), 
       height = 3.51, width = 5.69)

#replace all NA Gene.Count values with zeros 
taxa.arsA$Gene.Count[is.na(taxa.arsA$Gene.Count)] <- 0

############################################################
#WHAT IS THE DISTRIBUTION OF arsB IN EACH GENOME (#/GENOME)#
############################################################

##COG1055: ArsB: Na+/H+ antiporter NhaD or related arsenite permease

#read in COG1055 data
arsB <- read.delim(file = paste(wd, "/data/asp_COG1055_05-may-2017.txt", sep = ""))

#read in taxonomy data
taxa <- read_delim(file = paste(wd, "/data/taxontable51515_04-may-2017.xls", sep = ""), col_names = TRUE, delim = "\t")

#change sample name to genome
taxa.arsB <- taxa %>%
  select(taxon_oid, Genome, Phylum:Species) %>%
  left_join(arsB, by = "Genome") %>%
  mutate(Gene = "arsB")

#remove any duplicate rows 
taxa.arsB <- taxa.arsB[!duplicated(taxa.arsB$taxon_oid),]

#calculate the actual percentage of genomes with >=1 copy of arsB
perc.arsB <- count(arsB) / 51515

#plot COG1055 data (arsB)
(arsB.hist <- ggplot(arsB, aes(x = Gene.Count)) +
    geom_bar(fill = "#8DD3C7", color= "black") +
    ylab("Genome count") +
    xlab("Arsenite efflux pump genes / genome") +
    xlim(0,18) +
    theme_bw(base_size = 12))

#save bar chart of genes encoding As efflux pumps / genome
ggsave(arsB.hist, filename = paste(wd, "/figures/arsB.genome.hist.png", sep = ""), 
       height = 3.51, width = 5.69)
ggsave(arsB.hist, filename = paste(wd, "/figures/arsB.genome.hist.eps", sep = ""), 
       height = 3.51, width = 5.69)

#replace all NA Gene.Count values with zeros 
taxa.arsB$Gene.Count[is.na(taxa.arsB$Gene.Count)] <- 0

########################################
#SUMMARISE ASRG COGS IN ALL JGI GENOMES#
########################################

#join together arsC, arsA, arsB, acr3 COG data
taxa.asrg <- rbind(taxa.acr3, taxa.arsA, taxa.arsB, taxa.arsC)
  
#Calculate the number of genomes from each phyla
db.phyla <- taxa %>%
  group_by(Phylum) %>%
  summarise(total = length(Phylum))

#plot asrg
ggplot(taxa.asrg, aes(x = Gene, y = Gene.Count)) +
  geom_boxplot()

#summarise AsRGs based on phyla
taxa.asrg.summary <- taxa.asrg %>%
  mutate(Gene.CountPA = Gene.Count)
taxa.asrg.summary$Gene.CountPA[taxa.asrg.summary$Gene.CountPA > 0] <- 1
taxa.asrg.summary <- taxa.asrg.summary %>%
  group_by(Phylum, Gene) %>%
  summarise(N = sum(Gene.Count), PA = sum(Gene.CountPA)) 


#Calculate the proportion of phyla with AsRGs
phyla.summary <- taxa.asrg.summary %>%
  left_join(db.phyla, by = "Phylum") %>%
  group_by(Phylum, Gene) %>%
  select(Phylum, Gene, N, PA, total) %>%
  mutate(Proportion = N/total, ProportionPA = PA/total)

#make a slim version of dataset (only abundant phyla for plotting)
phyla.summary.top <- phyla.summary[phyla.summary$total >100,]

#order by number of phylum representatives
phyla.summary.top$Phylum <- factor(phyla.summary.top$Phylum, levels = phyla.summary.top$Phylum[order(phyla.summary.top$total, decreasing = TRUE)])

#Plot proportions of phyla with AsRGs
(prop.asrg.phyla <- ggplot(phyla.summary.top, 
                           aes(x = Phylum, y = Proportion, fill = Gene)) +
    geom_bar(stat="identity", position = "dodge", color = "black") +
    scale_fill_manual(values = c("#8DD3C7", "#BC80BD", "#80B1D3", "grey")) +
    xlab("Phylum") +
    ylab("Proportion of Genomes with Arsenic Resistance Gene") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(prop.asrg.phyla, filename = paste(wd, "/figures/AsRG.proportions.phyla.png", sep=""), width = 20, height = 12)
ggsave(prop.asrg.phyla, filename = paste(wd, "/figures/AsRG.proportions.phyla.eps", sep=""), width = 20, height = 12)

#Plot PA proportions of phyla with AsRGs
(prop.asrg.phylaPA <- ggplot(phyla.summary.top, 
                           aes(x = Phylum, y = ProportionPA, fill = Gene)) +
    geom_bar(stat="identity", position = "dodge", color = "black") +
    scale_fill_manual(values = c("#8DD3C7", "#BC80BD", "#80B1D3", "grey")) +
    xlab("Phylum") +
    ylab("Proportion of Genomes with Arsenic Resistance Gene") +
    theme_bw(base_size = 13) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(prop.asrg.phylaPA, filename = paste(wd, "/figures/AsRG.proportions.phylaPA.png", sep=""), width = 20, height = 12)
ggsave(prop.asrg.phylaPA, filename = paste(wd, "/figures/AsRG.proportions.phylaPA.eps", sep=""), width = 20, height = 12)



#####################
#METAGENOME ANALYSIS#
#####################

#list files of metaG
filenames <- list.files(path = paste(wd, "/data", sep = ""), pattern = "abundance_cog")

#make dataframes of all COG tables
for(i in filenames){
  filepath <- file.path(paste(wd, "/data", sep = ""),paste(i,sep=""))
  assign(i, read.delim(filepath,sep = "\t"))
}

#join together all dataframes
metag <- abundance_cog_78107_20170909_01.tab.xls %>%
  left_join(abundance_cog_80774_20170909_02.tab.xls, by = c("Func_id", "Func_name")) %>%
  left_join(abundance_cog_82408_20170909_03.tab.xls, by = c("Func_id", "Func_name")) %>%
  left_join(abundance_cog_109190_20170909_04.tab.xls, by = c("Func_id", "Func_name")) %>%
  left_join(abundance_cog_111649_20170909_05.tab.xls, by = c("Func_id", "Func_name")) %>%
  left_join(abundance_cog_113978_20170909_06.tab.xls, by = c("Func_id", "Func_name"))
  
#list scgs used by microbe census
census <- c("COG0052", "COG0081", "COG0532", "COG0091", 'COG0088', 'COG0090', "COG0103", 'COG0087', "COG0072", "COG0093", "COG0098", "COG0185", "COG0049", "COG0197", "COG0099", "COG0016", "COG0200", "COG0097", "COG0080", "COG0094", "COG0048", "COG0092", "COG0100", "COG0244", "COG0096", "COG0256", "COG0184", "COG0186", "COG0102", "COG0198")

#list arsenic resistance COGs
ars <- c("COG0798", "COG1393", "COG0003", "COG1055")

#trim metaG data based on COGs of interest 
metag_trimmed <- metag[metag$Func_id %in% census | metag$Func_id %in% ars,]

#extract functional COG information
cog_funct <- metag_trimmed[,c(1,2)]
metag_trimmed <- metag_trimmed[,-2]

#transpose metag_trimmed
metag_trimmed.t <- setNames(data.frame(t(metag_trimmed[,-1])),metag_trimmed[,1])
metag_trimmed.t$SampleName <- rownames(metag_trimmed.t)
metag_trimmed.t$SampleName <- gsub("_", " ", metag_trimmed.t$SampleName)
metag_trimmed.t$SampleName <- gsub("-", " ", metag_trimmed.t$SampleName)
metag_trimmed.t$SampleName <- gsub("  ", " ", metag_trimmed.t$SampleName)
metag_trimmed.t$SampleName <- gsub("   ", " ", metag_trimmed.t$SampleName)

#read in metadata for JGI metaG
metag_map <- read_delim(paste(wd, "/data/taxontable53641_10-sep-2017.xls", sep = ""), delim = "\t")
metag_map <- metag_map %>%
  select(-c(X23, `Gene Count   * assembled`)) %>%
  rename(SampleName = `Genome Name / Sample Name`)
metag_map$SampleName <- gsub("_", " ", metag_map$SampleName)
metag_map$SampleName <- gsub("-", " ", metag_map$SampleName)
metag_map$SampleName <- gsub("  ", " ", metag_map$SampleName)
metag_map$SampleName <- gsub("   ", " ", metag_map$SampleName)

#join metadata with metag COG data
#unfortunately JGI does not export COGs with metaG ID but rather sample name
#sample names are slightly off, so we use fuzzy join
metag_annotated_rough <- metag_trimmed.t %>%
  stringdist_left_join(metag_map, by = "SampleName", max_dist = 10, distance_col = "distance")

metag_annotated_improved <- metag_annotated_rough %>%
  group_by(SampleName.x) %>%
  top_n(1, desc(distance)) %>%
  ungroup()

metag_annotated <- metag_annotated_improved %>%
  group_by(SampleName.y) %>%
  top_n(1, desc(distance)) %>%
  ungroup()

#remove datasets with < 1 G of assembled data
metag_annotated <- metag_annotated[metag_annotated$`Genome Size   * assembled` > 1000000000,]

#tidy dataset
metag_annotated_tidy <- metag_annotated %>%
  melt(value.name = "Abundance", variable.name = "Func_id")

#extract and calc average of single copy gene abundance
metag_scg <- metag_annotated_tidy[metag_annotated_tidy$Func_id %in% census,]
metag_scg_summary <- metag_scg %>%
  group_by(SampleName.x) %>%
  summarise(scgMean = mean(Abundance), scgStDev = sd(Abundance))

#remove strange sample with scg == 0 
metag_scg_summary <- metag_scg_summary[metag_scg_summary$scgMean > 0,]
  
#join scg data with AsRG data, normalize by scg, and add COG functional information
metag_asrg <- metag_annotated_tidy[metag_annotated_tidy$Func_id %in% ars,]
metag_asrg_normalized <- metag_scg_summary %>%
  left_join(metag_asrg, by = c("SampleName.x")) %>%
  mutate(RelAbund = Abundance/scgMean) %>%
  left_join(cog_funct, by = "Func_id")

##########################################
#COMPARE JGI GENOMES AND SOIL METAGENOMES#
##########################################
taxa.asrg.compare <- taxa.asrg %>%
  mutate(Source = "Genome") %>%
  rename(RelAbund = Gene.Count) %>%
  select(Source, Gene, RelAbund) 

metag_asrg_normalized_compare <- metag_asrg_normalized %>%
  mutate(Source = "Metagenome") %>%
  select(Source, Func_id, RelAbund) %>%
  rename(Gene = Func_id)

metag_asrg_normalized_compare$Gene <- gsub("COG0003", "arsA", metag_asrg_normalized_compare$Gene)
metag_asrg_normalized_compare$Gene <- gsub("COG1055", "arsB", metag_asrg_normalized_compare$Gene)
metag_asrg_normalized_compare$Gene <- gsub("COG1393", "arsC", metag_asrg_normalized_compare$Gene)
metag_asrg_normalized_compare$Gene <- gsub("COG0798", "acr3", metag_asrg_normalized_compare$Gene)

gen_metag <- rbind(taxa.asrg.compare, metag_asrg_normalized_compare)

#plot data based on COG
ggplot(gen_metag, aes(x = Gene, y = RelAbund)) +
  geom_boxplot(aes(color = Source)) +
  theme_bw()

gen_metag_summarised <- gen_metag %>%
  group_by(Gene, Source) %>%
  summarise(N = length(Gene), Mean = mean(RelAbund), StdErr = sd(RelAbund)/sqrt(N))

ggplot(gen_metag_summarised, aes(x = Gene, y = Mean)) +
  geom_bar(stat = "identity", position = "dodge", aes(color = Source)) +
  geom_errorbar(aes(ymin = Mean - StdErr, ymax = Mean + StdErr))
