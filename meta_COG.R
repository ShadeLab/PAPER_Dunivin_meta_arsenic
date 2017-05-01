#load required packages
library(tidyverse)
library(reshape2)

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
  mutate(isolates = 44979) %>%
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

###################################################
#NORMALIZE COG ABUND IN METAG BASED ON CENSUS SCGs#
###################################################
data <- mutate(data, 
               Metagenomes = Metagenome.Count / mean(census$Metagenome.Count))

####################################################
#WHICH GENES ARE OVERREPRESENTED IN ISOLATE GENOMES#
####################################################

#view variation in COG genome representation by functional group
(func.abund <- ggplot(data, aes(x = Catergory, y = Genomes)) +
    geom_boxplot() + 
    geom_jitter() + 
    coord_flip())

(func.abund.metaG <- ggplot(data, aes(x = Catergory, y = Metagenomes)) +
    geom_boxplot() + 
    geom_jitter() + 
    coord_flip())

#not particularly useful plots
#does show scg pattern of ~1 (translation, ribosomal struct &biogen) for both ds
#lots of variation by COG
#more function unknown for metagenomes (sanity check)

#select AsRG cogs (exclusing several arsR groups)
ars <- c("COG0798", "COG1055", "COG1393", "COG0003", "COG0640", "COG2345", "COG4860")

#subset data based on AsRG cogs
ars <- data[which(data$COG.ID %in% ars),]

#tidy ars
ars <- melt(ars, id.vars = "COG.Name", measure.vars = c("Genomes", "Metagenomes"))

#plot AsRG COG proportions in genomes and metagenomes
(ars.plot <- ggplot(ars, aes(x = COG.Name, y = value, fill = variable)) +
    geom_bar(stat = "identity", position = "dodge") +
    guides(fill=guide_legend(title="Dataset")) +
    ylab("COG Proportion (count per genome)") + 
    xlab("COG Name") +
    theme_bw(base_size = 12) +
    scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 15)))

#save comparison plot
ggsave(ars.plot, filename = paste(wd, "/figures/AsRG.proportions.png", sep=""), height = 4, width = 10)

#overall see more AsRG in metagenomes
#compared to ATPase and efflux pumps, glutaredoxin As(V) reductases
#are overrepresented in genomes
#perhaps metagenomes are more likely to have contaminated sites? or
#genomes are more likely "domesticated" and less exposed to As?
#this also depends on freq of *multiple* AsRG counts in one genome

############################################################
#WHAT IS THE DISTRIBUTION OF ASRG IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG0798: Arsenite efflux pump ArsB, ACR3 family

#read in COG0798 data
arsB <- read.delim(file = paste(wd, "/data/ccdCOGGenomesCOG079818206_01-may-2017.xls", sep = ""))

#format COG0798 data (arsB)
arsB <- arsB %>%
  separate(col = Genome, into = "Genus", sep = " ", remove = FALSE)

#plot COG0798 data (arsB)
(arsB.hist <- ggplot(arsB, aes(x = Gene.Count)) +
    geom_bar(fill = "black") +
    ylab("Genome count") +
    xlab("Arsenite efflux pump genes / genome") +
    scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7)) + 
    theme_bw(base_size = 12))

#group data by count
arsB <- arsB %>%
  group_by(Gene.Count, Genus) %>%
  summarise(N=length(Genus))

arsB$Genus <- as.factor(arsB$Genus)
arsB <- arsB[order(arsB$Genus, arsB$N, decreasing = TRUE),]
arsB <- arsB[which(arsB$N >1),]

(genera.arsB <- ggplot(arsB, aes(x = Genus, y = N, fill = Genus)) +
    geom_bar(stat = "identity", inherit.aes = TRUE) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position="none") +
    facet_wrap(~Gene.Count, ncol = 1, scales = "free_y"))

ggsave(genera.arsB, filename = paste(wd, "/figures/arsB.genus.png", sep=""), height = 10, width = 30)







