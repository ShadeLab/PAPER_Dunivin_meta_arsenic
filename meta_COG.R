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

############################################################
#WHAT IS THE DISTRIBUTION OF ASRG IN EACH GENOME (#/GENOME)#
############################################################
#It is known that multiple copies of AsRG can occur both
#chromosomally and on plasmids. I need to see how frequent 
#multiple AsRG copies is

##COG0798: Arsenite efflux pump ArsB, ACR3 family

#read in COG0798 data
arsB <- read.delim(file = paste(wd, "/data/ccdCOGGenomesCOG079818206_01-may-2017.xls", sep = ""))

#format COG0798 data (arsB) by adding a genus column
arsB <- arsB %>%
  separate(col = Genome, into = "Genus", sep = " ", remove = FALSE)

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
#read in taxonomy data
taxa <- read.table(file = paste(wd, "/data/taxonomy.table.txt", sep = ""), sep = " ", fill = TRUE, flush = TRUE)

#add column names to taxa table
colnames(taxa) <- c("K", "na", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus")

#remove non bacterial rows and NA column
taxa <- taxa[which(taxa$K == "B"),]
taxa <- select(taxa, -(K:Kingdom))

#remove rows with no genus
taxa <- taxa[-which(taxa$Genus == "."),]

#change "." to NA
taxa[taxa == "."] <- NA
taxa[taxa == ""] <- NA

#fill NAs with last observation
taxa <- na.locf(taxa)

#join taxanomic data with count data
#not appropriate to use non-phylum data (join not specific enough)
taxa.arsB <- left_join(arsB, taxa, by = "Genus")
#15454 organisms

#some cannot be joing at the genus level, so we will make a new
#df with these values and join by next up taxanomic level and so on
no.genus <- arsB %>%
  anti_join(taxa, by = "Genus") %>%
  rename(Family = Genus) %>%
  left_join(taxa, by = "Family")
#973 organisms

no.family <- no.genus[is.na(no.genus$Phylum),]
no.family <- no.family %>%
  select(1:5) %>%
  rename(Order = Family) %>%
  left_join(taxa, by = "Order")
#862 organisms

no.order <- no.family[is.na(no.family$Phylum),]
no.order <- no.order %>%
  select(1:5) %>%
  rename(Class = Order) %>%
  left_join(taxa, by = "Class")
#676 organisms

no.class <- no.order[is.na(no.order$Phylum),]
#457 organisms

no.classA <- no.class[which(no.class$Class %in% taxa.arsB$Phylum),]
#227 organisms

no.classB <- no.class[-which(no.class$Class %in% taxa.arsB$Phylum),]
#230 organisms


no.classB <- no.classB %>%
  lapply(function(x) gsub("Methylosarcina-21", "Euryarchaeota", x)) %>%
  lapply(function(x) gsub("beta", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Acidovorax-*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("desulfomonile", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("alpha", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Bacteriovorax*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Bacteroidetes*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("BetaproteoUnknown", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("clostridium", "Firmicutes", x)) %>%
  lapply(function(x) gsub("Geomicrobium", "Firmicutes", x)) %>%
  lapply(function(x) gsub("DeltaproteoUnknown", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Flavobacter*", "Bacteroidetes", x)) %>%
  lapply(function(x) gsub("gamma", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("GammaproteoUnknown", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("methylo*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("zeta", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Zeta", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Gamma*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Delta*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("delta", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("actinobacterium", "Actinobacteria", x)) %>%
  lapply(function(x) gsub("Actinobacterium", "Actinobacteria", x)) %>%
  lapply(function(x) gsub("Proteobacteriaproteobacterium", "Actinobacteria", x)) %>%
  lapply(function(x) gsub("Bacteroidetesia", "Bacteroidetes", x)) %>%
  lapply(function(x) gsub("Bacteroidetesiaceae*", "Bacteroidetes", x)) %>%
  lapply(function(x) gsub("Betaproteobacterium", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Proteobacteria*", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("marine", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Cyano_bin1_Alphaproteobacteria", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Cyano_bin9_Proteobacteriaproteobacteria", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("Guam_bin1_Proteobacteria", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("LKpool_bin1_Proteobacteria", "Proteobacteria", x)) %>%
  lapply(function(x) gsub("LKpool_bin7_Proteobacteria", "Proteobacteria", x)) %>%
  data.frame()

no.classC <- no.classB[which(no.classB$Class =="Proteobacteria" | no.classB$Class =="Bacteroidetes" | no.classB$Class =="Actinobacteria" | no.classB$Class =="Firmicutes" | no.classB$Class =="Euryarchaeota" | no.classB$Class =="Euryarchaeota" | no.classB$Class =="Parcubacteria"),]
#61 orgs

no.classD <- no.classB[-which(no.classB$Class =="Proteobacteria" | no.classB$Class =="Bacteroidetes" | no.classB$Class =="Actinobacteria" | no.classB$Class =="Firmicutes" | no.classB$Class =="Euryarchaeota" | no.classB$Class =="Euryarchaeota" | no.classB$Class =="Parcubacteria"),]

no.classD <- mutate(no.classD, Phylum = "Unknown")
#170 orgs
  
#obtain best matches and rbind
a <- taxa.arsB[!is.na(taxa.arsB$Phylum),]
a <- a[which(duplicated(a$Genome) == FALSE),]
a <- select(a,Genome, Gene.Count, Phylum)
#14481 orgs

b <- no.genus[!is.na(no.genus$Phylum),]
b <- b[which(duplicated(b$Genome) == FALSE),]
b <- select(b,Genome, Gene.Count, Phylum)
#111 orgs

c <- no.family[!is.na(no.family$Phylum),]
c <- c[which(duplicated(c$Genome) == FALSE),]
c <- select(c,Genome, Gene.Count, Phylum)
#186 orgs

d <- no.order[!is.na(no.order$Phylum),]
d <- d[which(duplicated(d$Genome) == FALSE),]
d <- select(d,Genome, Gene.Count, Phylum)
#219 orgs

e <- no.classA %>%
  mutate(Phylum = Class) %>%
  select(Genome, Gene.Count, Phylum)
#227  
  
f <- no.classC %>%
  mutate(Phylum = Class) %>%
  select(Genome, Gene.Count, Phylum)
#56 orgs

g <-select(no.classD, Genome, Gene.Count, Phylum)
#169  

taxa.final <- rbind(a,b,c,d,e,f,g)

#group data by count
taxa.sum <- taxa.final %>%
  group_by(Gene.Count, Phylum) %>%
  summarise(N=length(Phylum))

#plot a histogram of isolates from different phyla with arsB
(arsB.phyla <- ggplot(taxa.final, aes(x = reorder(Phylum, Phylum, function(x)-length(x)), fill = Gene.Count)) +
    geom_histogram(stat="count") +
    xlab("Phylum") +
    ylab("Number of Isolate Genomes") +
    scale_fill_discrete(name = "Gene copy number") +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)))

#save plot
ggsave(arsB.phyla, filename = paste(wd, "/figures/arsB.isolates.phyla.png", sep=""), width = 6.5, height = 6)

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
ggsave(ars.plot, filename = paste(wd, "/figures/AsRG.proportions.png", sep=""), height = 4, width = 10)

#Some AsRG appear underrepresented in isolate genomes while 
#arsC-glut is over-represented; arsC_glut is in E.coli, which
#may explain some of this discrepancy 
#metaG data makes more sense since it has higher arsenite efflux pump 
#abundance than arsenate redcutase; an arsenate reductase is not useful
#without an arsenite efflux pump 
#as always, I do not really trust arsR COG data
