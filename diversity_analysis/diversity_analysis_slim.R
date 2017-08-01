#load dependencies 
library(phyloseq)
library(vegan)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(readr)

wd <- print(getwd())

#make color pallette
GnYlOrRd <- colorRampPalette(colors=c("green", "yellow", "orange","red"), bias=2)

#make colors for rarefaction curves (n=12)
rarecol <- c("black", "darkred", "forestgreen", "orange", "blue","yellow",
             "hotpink", "green", "red", "brown", "grey", "purple", "violet")

#read in available metadata
metad <- read.delim(paste(wd, "/data/metadata.txt", sep = ""), sep = "\t")

#########################
#rplB DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
rplB0.01 <- read.delim(file = paste(wd, "/data/rplB_rformat_dist_0.01.txt", sep=""))

#rename sites
rplB0.01 <- rplB0.01 %>%
  separate(col = X, into = c("Site", "junk"), sep = ".3_") %>%
  select(-junk)

#add row names back
rownames(rplB0.01)=rplB0.01[,1]

#remove first column
rplB0.01=rplB0.01[,-1]

#make data matrix
rplB0.01=data.matrix(rplB0.01)

#make an output of total gene count per site
rplB0.01.gcounts=rowSums(rplB0.01)
print(rplB0.01.gcounts)

#otu table
otu_rplB0.01=otu_table(rplB0.01, taxa_are_rows = FALSE)

#see rarefaction curve
rarecurve(otu_rplB0.01, step=1, col=rarecol, label = TRUE, cex=0.5)

#rarefy
rare_rplB0.01=rarefy_even_depth(otu_rplB0.01, sample.size = 40, 
                       rngseed = TRUE)


#check curve
rarecurve(rare_rplB0.01, step=1, col = c("black", "darkred", "forestgreen", 
                                "orange", "blue", "yellow", "hotpink"), 
          label = FALSE)

#remove unnecessary rows in metad
meta <- metad[which(metad$Sample %in% rownames(rplB0.01)),]
rownames(meta)=meta$Sample
meta <- meta[-1]

#make metadata a phyloseq class object
meta <- sample_data(meta)

##make biom for phyloseq
phylo <- merge_phyloseq(rare_rplB0.01, meta)

#plot phylo richness
(richness <- plot_richness(phylo, x = "Site", measures = "Shannon"))

#save plot 
ggsave(richness, filename = paste(wd, "/figures/rplB_richness.png", sep=""))

#calculate evenness
s=specnumber(rare_rplB0.01)
h=diversity(rare_rplB0.01, index="shannon")
plieou=h/log(s)

#save evenness number
write.table(plieou, file = paste(wd, "/output/rplB_evenness.txt", sep=""))

#make plieou a dataframe for plotting
plieou=data.frame(plieou)

#add site column to evenness data
plieou$Sample=rownames(plieou)

#merge evenness information with fire classification
plieou=left_join(plieou, metad)

#plot evenness by fire classification
(evenness <- ggplot(plieou, aes(x = Site, y = plieou)) +
    geom_point(size=3) +
    ylab("Evenness") +
    theme_bw(base_size = 12) +
    theme(axis.text.x = element_text(angle = 90, size = 12, 
                                     hjust=0.95,vjust=0.2)))

#save evenness plot
ggsave(evenness, filename = paste(wd, "/figures/rplB_evenness.png", sep=""), 
       width = 7, height = 5)

#plot Bray Curtis ordination
ord <- ordinate(phylo, method="PCoA", distance="bray")
(bc.ord=plot_ordination(phylo, ord, shape="Biome", color="Site",title="Bray Curtis") +
    geom_point(size=5) +
    theme_light(base_size = 12))

#save bray curtis ordination
ggsave(bc.ord, filename = paste(wd, "/figures/rplB_braycurtis.ord.png", sep=""), 
       width = 6, height = 5)


#plot Sorenson ordination
ord.sor <- ordinate(phylo, method="PCoA", distance="bray", binary = TRUE)
(sor.ord=plot_ordination(phylo, ord.sor, shape="Biome", color="Site",
                         title="Sorensen") +
    geom_point(size=5) +
    theme_light(base_size = 12))

library(ape)
#make object phylo with tree and biom info
tree <- read.tree(file = paste(wd, "/data/rplB_0.01_tree_short.nwk", sep=""))
tree <- phy_tree(tree)

#merge
phylo=merge_phyloseq(tree, rare_rplB0.01, metad)

#plot unweighted Unifrac ordination
uni.u.ord.rplB <- ordinate(phylo, method="PCoA", distance="unifrac", weighted = FALSE)
(uni.u.ord.rplB=plot_ordination(phylo, uni.u.ord.rplB, shape="Classification", 
                                title="Unweighted Unifrac") +
    geom_point(aes(color = SoilTemperature_to10cm), size=5) +
    scale_color_gradientn(colours=GnYlOrRd(5), guide="colorbar", 
                          guide_legend(title="Temperature (°C)")) +
    theme_light(base_size = 12))

#save unweighted Unifrac ordination
ggsave(uni.u.ord.rplB, filename = paste(wd, "/figures/rplB.u.unifrac.ord.png", sep=""), 
       width = 6, height = 5)

#plot weighted Unifrac ordination
uni.w.ord.rplB <- ordinate(phylo, method="PCoA", distance="unifrac", weighted = TRUE)
(uni.w.ord.rplB=plot_ordination(phylo, uni.w.ord.rplB, shape="Classification", 
                                title="Weighted Unifrac") +
    geom_point(aes(color = SoilTemperature_to10cm), size=5) +
    scale_color_gradientn(colours=GnYlOrRd(5), guide="colorbar", 
                          guide_legend(title="Temperature (°C)")) +
    theme_light(base_size = 12))

#save weighted Unifrac ordination
ggsave(uni.w.ord.rplB, filename = paste(wd, "/figures/rplB.w.unifrac.ord.png", sep=""), 
       width = 6, height = 5)


#########################
#rplB DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
rplB0.1=read.delim(file = paste(wd, 
                                     "/data/rplB_rformat_dist_0.01.txt", 
                                     sep=""))

#add row names back
rownames(rplB0.1)=rplB0.1[,1]

#remove first column
rplB0.1=rplB0.1[,-1]

#make data matrix
rplB0.1=data.matrix(rplB0.1)

#remove samples with <5 OTUs (Illinois_soybean40.3 (row 8), California_grasland62.3 (row16),
# Illinois_soybean42.3(row 20), Iowa_agricultural01.3(row19))
rplB0.1 <- rplB0.1[-c(8,16,20,19), ]


#make an output of total gene count per site
rplB0.1.gcounts=rowSums(rplB0.1)

#otu table for rplB0.3
otu_rplB0.1=otu_table(rplB0.1, taxa_are_rows = FALSE)

#see rarefaction curve
rarecurve(otu_rplB0.1, step=5, col=rarecol, label = FALSE, cex=0.5)

#rarefy
rare_rplB0.1=rarefy_even_depth(otu_rplB0.1, 
                               sample.size = min(sample_sums(otu_rplB0.1)), 
                               rngseed = TRUE)

#check curve
rarecurve(rare_rplB0.1, step=1, col = c("black", "red", "forestgreen", 
                                        "orange", "blue", "yellow", "hotpink"), 
          label = FALSE, cex=0.4)

#make an output of total OTUs per site
rplB0.1[rplB0.1 > 0]  <- 1
rplB0.1.OTUcounts=rowSums(rplB0.1)

#########################
#arsC_thio DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arsC_thio0.1=read.delim(file = paste(wd, 
                                     "/data/arsC_thio_rformat_dist_0.01.txt", 
                                     sep=""))

#add row names back
rownames(arsC_thio0.1)=arsC_thio0.1[,1]

#remove first column
arsC_thio0.1=arsC_thio0.1[,-1]

#make data matrix
arsC_thio0.1=data.matrix(arsC_thio0.1)

#remove samples with <5 OTUs (rows 1,2,4-6,8,10-13)
#OR: remove samples with <=5 OTUs(rows 1-6,8-13)
arsC_thio0.1 <- arsC_thio0.1[-c(1,2,3,4,5,6,8,9,10,11,12,13), ]

#make an output of total gene count per site
arsC_thio0.1.gcounts=rowSums(arsC_thio0.1)

#otu table for rplB0.3
otu_arsC_thio0.1=otu_table(arsC_thio0.1, taxa_are_rows = FALSE)

#see rarefaction curve
rarecurve(otu_arsC_thio0.1, step=5, col=rarecol, label = FALSE, cex=0.5)

#rarefy
rare_arsC_thio0.1=rarefy_even_depth(otu_arsC_thio0.1, 
                                    sample.size = min(sample_sums(otu_arsC_thio0.1)), 
                                    rngseed = TRUE)

#check curve
rarecurve(rare_arsC_thio0.1, step=1, col = c("black", "red", "forestgreen", 
                                             "orange", "blue", "yellow", "hotpink"), 
          label = FALSE, cex=0.4)


#make an output of total OTUs per site
arsC_thio0.1[arsC_thio0.1 > 0]  <- 1
arsC_thio0.1.OTUcounts=rowSums(arsC_thio0.1)
print(arsC_thio0.1.OTUcounts)

#########################
#arrA DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arrA0.1=read.delim(file = paste(wd, 
                                     "/data/arrA_rformat_dist_0.01.txt", 
                                     sep=""))

#add row names back
rownames(arrA0.1)=arrA0.1[,1]

#remove first column
arrA0.1=arrA0.1[,-1]

#make data matrix
arrA0.1=data.matrix(arrA0.1)

#i removed first column, it is "X"
arrA0.1=arrA0.1[,-1]


#remove samples with les OTU(row2)
arrA0.1 <- arrA0.1[-c(2), ]

#make an output of total gene count per site
arrA0.1.gcounts=rowSums(arrA0.1)

#otu table for rplB0.3
otu_arrA0.1=otu_table(arrA0.1, taxa_are_rows = FALSE)

#see rarefaction curve
rarecurve(otu_arrA0.1, step=5, col=col, label = TRUE, cex=0.5)

#rarefy
rare_arrA0.1=rarefy_even_depth(otu_arrA0.1, 
                                    sample.size = min(sample_sums(otu_arrA0.1)), 
                                    rngseed = TRUE)

#check curve
rarecurve(rare_arrA0.1, step=1, col = c("black", "red", "forestgreen", 
                                             "orange", "blue", "yellow", "hotpink"), 
          label = TRUE, cex=0.6)

arrA0.1[arrA0.1 > 0]  <- 1
arrA0.1.OTUcounts=rowSums(arrA0.1)
print(arrA0.1.OTUcounts)

#########################
#arsD DIVERSITY ANALYSIS#
#########################
#read in distance matrix for 0.1
arsD0.1=read.delim(file = paste(wd, 
                                "/data/arsD_rformat_dist_0.01.txt", 
                                sep=""))

#add row names back
rownames(arsD0.1)=arsD0.1[,1]

#remove first column
arsD0.1=arsD0.1[,-1]

#make data matrix
arsD0.1=data.matrix(arsD0.1)
arsD0.1=arsD0.1[,-1]

#remove samples with less OTUs(rows 2,3,4,7,8)
arsD0.1 <- arsD0.1[-c(2,3,4,5,6,7,8), ]

#make an output of total gene count per site
arsD0.1.gcounts=rowSums(arsD0.1)

#otu table for rplB0.3
otu_arsD0.1=otu_table(arsD0.1, taxa_are_rows = FALSE)

#see rarefaction curve
rarecurve(otu_arsD0.1, step=5, col=rarecol, label = FALSE, cex=0.5)

#rarefy
rare_arsD0.1=rarefy_even_depth(otu_arsD0.1, 
                               sample.size = min(sample_sums(otu_arsD0.1)), 
                               rngseed = TRUE)

#check curve
rarecurve(rare_arsD0.1, step=1, col = c("black", "red", "forestgreen", 
                                        "orange", "blue", "yellow", "hotpink"), 
          label = TRUE, cex=0.4)

arsD0.1[arsD0.1 > 0]  <- 1
arsD0.1.OTUcounts=rowSums(arsD0.1)
print(arsD0.1.OTUcounts)

#########################
#observed alpha diversity#
#########################
library(reshape2)
library(datasets)
observed_abundances=read.delim(file = paste(wd, 
                                "/data/observed_abundances.txt",
                                sep=""))

observed_abundances.reshaped <- melt(observed_abundances.reshaped, id.vars=c("Sample"), 
                          measure.vars=c('arsB','rplB','arrA','rplB','arxA','rplB',
                                         'arsC_thio','arsD','arsM'))

plot_observed_abund<-ggplot(data=observed_abundances.reshaped, 
                         aes(x=Sample, color=variable)) + theme(axis.text.x = element_text(angle = 50, hjust = 1))
plot(plot_observed_abund)
