#Plot the Average Genome Size Across Samples

library(tidyverse)
library(ggplot2)

setwd("C:/Users/susan/Documents/arsenic/download")

wd <- print(getwd())

data_all <- read.table("avggenomesizes_all.txt", head=FALSE, sep="\t")
colnames(data_all) = c("Site", "Sample1AGS", "Sample2AGS", "Sample3AGS", "Biome")

#Average Genome Size per Biome
library(reshape2)
library(datasets)
data_all.reshaped <- melt(data_all, id.vars=c("Site", "Biome"), 
                          measure.vars=c('Sample1AGS','Sample2AGS','Sample3AGS'))
plot_all_reshaped<-ggplot(data_all.reshaped, aes(x=Biome, y=value)) + 
  geom_boxplot() + 
  geom_jitter(aes(color=Site)) + 
  theme(axis.text.x = element_text(angle = 50, hjust = 1)) + 
  theme(text = element_text(size=23)) +
  theme(axis.text.x = element_text(angle = 50, hjust = 1)) +
  ylab("Average Genome Size (bp)")
plot(plot_all_reshaped)
ggsave(plot_all_reshaped, filename = paste(wd, "/figures/ags_per_biome2.png", sep = ""), 
       width = 10, height = 10)

#Average Genome Size Per Site
plot_all<-ggplot(data=data_all, aes(x=Site, color=Biome, shape=Biome)) + 
  geom_jitter(aes(y=Sample1AGS), size=4) + geom_point(aes(y=Sample2AGS), size=4) + 
  geom_jitter(aes(y=Sample3AGS), size=4) + 
  theme_bw() +
  theme(text = element_text(size=23)) +
  theme(axis.text.x = element_text(angle = 50, hjust = 1)) +
  ylab("Average Genome Size (bp)") 

ggsave(plot_all, filename = paste(wd, "/figures/ags_per_site2.png", sep=""), 
       width = 23, height = 18)


#Gbases vs genomes equivalents:
data2<-read.table("bp_genomeEq.txt")
colnames(data2) = c("Site", "Sample", "Gbp", "GenomeEquivalents")
str(data2)
data2$Gbases
gbases_vs_ge=(ggplot(data=data2, aes(x=GenomeEquivalents, y=Gbp, color=Site)) + 
  geom_point(size=4) +
  theme_bw() +
  theme(text = element_text(size=23)) +
  ylab("Size of Metagenome (Gbp)") +
  xlab("Genome Equivalents"))

ggsave(gbases_vs_ge, filename = paste(wd, "/figures/gbases_vs_ge.png", sep=""), 
       width = 12, height = 6)
