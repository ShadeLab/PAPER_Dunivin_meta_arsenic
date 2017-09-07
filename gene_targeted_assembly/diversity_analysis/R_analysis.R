#####################
#ENVIRONMENTAL SETUP#
#####################
#load required packages
library(vegan)
library(psych)
library(tidyverse)
library(qgraph)
library(phyloseq)
library(reshape2)
library(data.table)
library(taxize)

#print working directory for future references
#note the GitHub directory for this script is as follows
#https://github.com/ShadeLab/meta_arsenic/tree/master/diversity_analysis
wd <- print(getwd())

#read in metadata
meta <- data.frame(read.delim(paste(wd, "/data/metadata_map.txt", 
                                    sep=""), sep="\t", header=TRUE))

#temporarily change working directories
setwd(paste(wd, "/data", sep = ""))

#list filenames of interest
filenames <- list.files(pattern="*_rformat_dist_0.1.txt")

#move back up directories
setwd("../..")

#make dataframes of all OTU tables
for(i in filenames){
  filepath <- file.path(paste(wd, "/data", sep = ""),paste(i,sep=""))
  assign(gsub("_rformat_dist_0.1.txt", "", i), read.delim(filepath,sep = "\t"))
}

##############
#DATA TIDYING#
##############
#write OTU naming function
naming <- function(file) {
  gsub("OTU", deparse(substitute(file)), colnames(file))
}

#change OTU to gene name
colnames(acr3) <- naming(acr3)
colnames(aioA) <- naming(aioA)
colnames(arsB) <- naming(arsB)
colnames(arrA) <- naming(arrA)
colnames(arsC_glut) <- naming(arsC_glut)
colnames(arsC_thio) <- naming(arsC_thio)
colnames(arsD) <- naming(arsD)
colnames(arsM) <- naming(arsM)
colnames(arxA) <- naming(arxA)
colnames(rplB) <- naming(rplB)

#join together all files
otu_table <- rplB %>%
  left_join(aioA, by = "X") %>%
  left_join(arrA, by = "X") %>%
  left_join(arsB, by = "X") %>%
  left_join(arsC_glut, by = "X") %>%
  left_join(arsC_thio, by = "X") %>%
  left_join(arsD, by = "X") %>%
  left_join(arsM, by = "X") %>%
  left_join(arxA, by = "X") %>%
  left_join(acr3, by = "X") %>%
  rename(Sample = X) 

#list otus that are gene matches
#mixed.1 <- c("aioA_13", "aioA_31", "aioA_34", "aioA_36", "aioA_37", "aioA_42", "aioA_43", "aioA_49", "aioA_51", "arrA_1", "arrA_2", "arrA_3", "arrA_4", "arrA_5", "arrA_6", "arrA_8","arxA_11", "arxA_04")

#remove OTUs that are gene matches
#otu_table <- otu_table[,!names(otu_table) %in% mixed.1]

#rename arxA column that is actually arrA (with no match)
#otu_table <- otu_table %>%
#  rename(arrA_3 = arxA_03)

#replace all NAs (from join) with zeros
otu_table[is.na(otu_table)] <- 0

#write file to save OTU table
write.table(otu_table, paste(wd, "/output/otu_table_full.txt", sep = ""), sep = "\t", quote = FALSE, row.names = FALSE)

####################
#DATA NORMALIZATION#
####################
#get rplB otu data
rplB <- otu_table[,grepl("rplB", names(otu_table))]

#add site names to rplB
rownames(rplB) <-  otu_table$Sample

#summarise rplB by adding all OTU counts 
# in each row (total rplB/site)
rplB_summary <- data.frame(rowSums(rplB)) %>%
  rename(sum.rplB = rowSums.rplB.)

#make site a column in rplB
rplB_summary$Sample <- rownames(rplB_summary) 

#add rplB data to otu_table
otu_table.rplB <- rplB_summary %>%
  left_join(otu_table, by = "Sample")

#normalize to rplB
otu_table_norm <- otu_table.rplB
for(i in 3:ncol(otu_table_norm)){otu_table_norm[,i]=otu_table.rplB[,i]/otu_table.rplB[,1]}

#add in metadata
otu_table_norm_annotated <- meta %>%
  left_join(otu_table_norm, by = "Sample") %>%
  unique()

#change to df and add row names back
otu_table_norm_annotated <- as.data.frame(otu_table_norm_annotated)
rownames(otu_table_norm_annotated) <- otu_table_norm_annotated[,1]
otu_table_norm_annotated=otu_table_norm_annotated[,-1]

#make data matrix
otu_table_norm_annotated <- data.matrix(otu_table_norm_annotated)

#transpose data
otu_table_norm_annotated.t <- t(otu_table_norm_annotated)


#read in gene classification data
gene <- read_delim(paste(wd, "/data/gene_classification.txt",  sep=""), 
                   delim = "\t", col_names = TRUE)

#melt data to separate otu and abundance per site
gene_abundance <- otu_table_norm %>%
  select(-sum.rplB) %>%
  melt(variable.names = c("Sample", "OTU"), value.name = "RelativeAbundance") %>%
  rename(OTU = variable)

#change arsC_ to arsC and make new column, then add back "_"
gene_abundance$OTU <- gsub("arsC_", "arsC", gene_abundance$OTU)
gene_abundance <- gene_abundance %>%
  separate(OTU, into = "Gene", sep = "_", remove = FALSE) 
gene_abundance$Gene <- gsub("arsC", "arsC_", gene_abundance$Gene)


#annotate gene abundance file
gene_abundance_annotated <- gene_abundance %>%
  left_join(gene, by = "Gene") %>%
  left_join(meta, by = "Sample") %>%
  unique()

############################
#MAKE GENE ABUNDANCE GRAPHS#
############################
#summarise normalized data (aka annotated gene abundance data)
gene_abundance_summary <- gene_abundance_annotated %>%
  group_by(Description, Gene, Site, Sample) %>%
  summarise(Total = sum(RelativeAbundance))

#order based on gene group
gene_abundance_summary$Gene <- factor(gene_abundance_summary$Gene, 
                                      levels = gene_abundance_summary$Gene[order(gene_abundance_summary$Description)])

#plot bar graph by SAMPLE
(barplot.sample <- ggplot(subset(gene_abundance_summary, subset = Gene !="rplB"),
                   aes(x = Sample, y = 100*Total)) +
    geom_bar(stat = "identity", aes(fill = Gene)) +
    scale_fill_brewer(palette = "Set3") +
    ylab("Total gene count (normalized to rplB)") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 45, size = 12, 
                                     hjust=0.99,vjust=0.99)))

#save bar graph with SAMPLE means
ggsave(barplot.sample, filename = paste(wd, "/figures/bar.sample.png", sep= ""))
ggsave(barplot.sample, filename = paste(wd, "/figures/bar.sample.eps", sep= ""))

#summarise based on sample
gene_abundance_summary.site <- gene_abundance_summary %>%
  ungroup() %>%
  group_by(Description, Gene, Site) %>%
  summarise(Mean = mean(Total))

#plot bar graph with SITE means
(barplot.site <- ggplot(subset(gene_abundance_summary.site, subset = Gene !="rplB"),
                          aes(x = Site, y = Mean)) +
    geom_bar(stat = "identity", aes(fill = Gene)) +
    scale_fill_brewer(palette = "Set3") +
    ylab("Total gene count (normalized to rplB)") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 45, size = 12, 
                                     hjust=0.99,vjust=0.99)))

#save bar graph with SITE means
ggsave(barplot.site, filename = paste(wd, "/figures/bar.site.png", sep= ""))
ggsave(barplot.site, filename = paste(wd, "/figures/bar.site.eps", sep= ""))

#######################################
#COMMUNITY COMPOSITION ANALYSIS (rplB)#
#######################################

#temporarily change working directory to data 
#to bulk load rplB abundance/ taxonomy files
setwd(paste(wd, "/data", sep = ""))
names <- list.files(pattern="*_45_taxonabund.txt")
community <- do.call(rbind, lapply(names, function(X) {
  data.frame(Sample = basename(X), fread(X, sep = "\t", skip = "Lineage"))}))
setwd("../")

#tidy lineage data (separate KPCOFGS)
community_tidy <- community %>%
  separate(col = Lineage, into = c("Kingdom",
                                   "Phylum",
                                   "Class",
                                   "Order",
                                   "Family",
                                   "Genus"), sep = ";")

community_tidy$Sample <- gsub("_rplB_45_taxonabund.txt", "", community_tidy$Sample)

#join rlpB summarsied data with metadata for plotting
community_tidy_annotated <- community_tidy %>%
  left_join(meta, by = "Sample") %>%
  group_by(Site, Sample, Phylum) %>%
  summarise(RelAbund = sum(Fraction.Abundance))

#decast for abundance check
dcast <- dcast(community_tidy_annotated, Phylum ~ Sample, 
               value.var = "RelAbund")

#call na's zeros
dcast[is.na(dcast)] = 0

#order based on abundance
order.dcast <- dcast[order(rowSums(dcast[,2:ncol(dcast)]),decreasing=TRUE),]

#melt data
melt <- melt(order.dcast,id.vars="Phylum", 
             variable.name= "Sample", value.name="RelAbund" )

#join metadata with regular data
history <- melt %>%
  left_join(meta, by="Sample") %>%
  group_by(Site, Phylum) %>%
  summarise(N = length(RelAbund),
            Average = mean(RelAbund))

#plot full community structure
(phylum.plot=(ggplot(history, aes(x=Phylum, y=Average)) +
                geom_point(size=2) +
                labs(x="Phylum", y="Mean relative abundance") +
                facet_wrap(~Site) +
                theme_bw(base_size = 11) +
                theme(axis.text.x = element_text(angle = 90, size = 11, 
                                                 hjust=0.99,vjust=0.99))))

#save full community structure
ggsave(phylum.plot, filename = paste(wd, "/figures/community.structure.full.png", sep=""), width = 12, height = 6)
ggsave(phylum.plot, filename = paste(wd, "/figures/community.structure.full.eps", sep=""), width = 12, height = 6)
#extract 6 most abundant phyla
#top 6 were chosen so that at least
#70% of each community was represented
top.phyla <- c("Proteobacteria", "Actinobacteria", "Verrucomicrobia", "Firmicutes", "Acidobacteria", "Chloroflexi")

#plot community structure of top phyla
(phylum.plot.top=(ggplot(subset(history, subset = Phylum %in% top.phyla),
                         aes(x=Site, y=Average, fill = Phylum)) +
                    geom_bar(stat = "identity") +
                    scale_fill_brewer(palette = "Dark2") +
                    labs(x="Phylum", y="Mean relative abundance") +
                    theme_bw(base_size = 11) +
                    theme(axis.text.x = element_text(angle = 45, size = 10, 
                                                     hjust=0.99,vjust=0.99))))

#save plot of top phyla
ggsave(phylum.plot.top, filename = paste(wd, "/figures/community.structure.top.png", sep=""))
ggsave(phylum.plot.top, filename = paste(wd, "/figures/community.structure.top.eps", sep=""), units = "in", width = 6, height = 4)



##############################
#Community membership v. AsRG#
##############################
#remove sites with low rplB (ie low seq depth/ confidence)
otu_table <- otu_table[-which(otu_table$Sample == "Iowa_agricultural01.3"),]
otu_table <- otu_table[-which(otu_table$Sample == "Illinois_soybean42.3"),]
otu_table <- otu_table[-which(otu_table$Sample == "Illinois_soybean40.3"),]

#make sample the row names
rownames(otu_table) <- otu_table$Sample
otu_table <- otu_table[,-1]

#separate OTU table into 2: rplB and AsRG
otu_table.rplB <- otu_table[, grep("rplB", colnames(otu_table))]
colnames(otu_table.rplB) <- gsub("rplB_", "OTU_0", colnames(otu_table.rplB))
otu_table.AsRG <- otu_table[, grep("ars|aio|arx|arr|acr", colnames(otu_table))]

#check sampling depth of each matrix
otu_table.rplB <- otu_table(otu_table.rplB, taxa_are_rows = FALSE)
rarecurve(otu_table.rplB, step=1, label = FALSE)

otu_table.AsRG <- otu_table(otu_table.AsRG, taxa_are_rows = FALSE)
rarecurve(otu_table.AsRG, step=1, label = FALSE)

#rarefy to even sampling depth 
rare_rplB <- rarefy_even_depth(otu_table.rplB, rngseed = TRUE)
rarecurve(rare_rplB, step=1, label = FALSE)

rare_AsRG <- rarefy_even_depth(otu_table.AsRG, rngseed = TRUE)
rarecurve(rare_AsRG, step=1, label = FALSE)

#make metadata a phyloseq class object
rownames(meta) <- meta[,1]
meta.phylo <- meta[,-1]
meta.phylo <- sample_data(meta.phylo)

#read in trees and make phyloseq object
library(ape)
rplb.tree <- read.tree(paste(wd, "/data/rplB_0.1_FastTree.nwk", sep = ""))
rplb.tree <- phy_tree(rplb.tree)

##make biom for phyloseq
rare_rplB <- merge_phyloseq(rare_rplB, meta.phylo, rplb.tree)
rare_AsRG <- merge_phyloseq(rare_AsRG, meta.phylo)

#plot & save richness of rplB
(richness.rplB <- plot_richness(rare_rplB, x = "Site", measures = "Shannon"))
ggsave(richness.rplB, filename = paste(wd, "/figures/rplB_richness.png",
                                       sep = ""))
#... and AsRGs
(richness.AsRG <- plot_richness(rare_AsRG, x = "Site", measures = "Shannon"))
ggsave(richness.AsRG, filename = paste(wd, "/figures/AsRG_richness.png",
                                       sep = ""))
#relativize rarefied datasets
rare_rplB_rel = transform_sample_counts(rare_rplB, function(x) x/sum(x))
rare_AsRG_rel = transform_sample_counts(rare_AsRG, function(x) x/sum(x))

#plot Bray Curtis ordination for rplB
ord.rplB.bray <- ordinate(rare_rplB_rel, method="PCoA", distance="bray")
(bc.ord=plot_ordination(rare_rplB_rel, ord.rplB.bray, color="Site",
                        title="Bray Curtis") +
    geom_point(size=5, alpha = 0.5) +
    theme_light(base_size = 12))

w.ord.rplB.uni <- ordinate(rare_rplB_rel, method="PCoA", distance="unifrac")
(w.uni.ord=plot_ordination(rare_rplB_rel, ord.rplB.uni, color="Site",
                        title="Weighted UniFrac") +
    geom_point(size=5, alpha = 0.5) +
    theme_light(base_size = 12))

u.uni.ord.rplB <- ordinate(rare_rplB_rel, method="PCoA", 
                         distance="unifrac", weighted = FALSE)
(u.uni.ord <- plot_ordination(rare_rplB_rel, u.uni.ord.rplB, color="Site",
                           title="Weighted UniFrac") +
    geom_point(size=5, alpha = 0.5) +
    theme_light(base_size = 12))

#plot Bray Curtis ordination for AsRGs
ord.AsRG.bray <- ordinate(rare_AsRG_rel, method="PCoA", distance="bray")
(bc.ord=plot_ordination(rare_AsRG_rel, ord.AsRG.bray, color="Site",
                        title="Bray Curtis") +
    geom_point(size=5, alpha = 0.5) +
    theme_light(base_size = 12))

#extract OTU table from phyloseq
rare_rplB_rel.matrix = as(otu_table(rare_rplB_rel), "matrix")
rare_AsRG_rel.matrix = as(otu_table(rare_AsRG_rel), "matrix")

#calculate distance matrix
otu_rplB.d <- vegdist(rare_rplB_rel.matrix, diag = TRUE, upper = TRUE)
otu_AsRG.d <- vegdist(rare_AsRG_rel.matrix, diag = TRUE, upper = TRUE)

#mantel test between rplB and AsRG
mantel(otu_AsRG.d,otu_rplB.d, method = "spear")
