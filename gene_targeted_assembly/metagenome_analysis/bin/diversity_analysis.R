#####################
#ENVIRONMENTAL SETUP#
#####################
#load required packages
library(vegan)
library(psych)
library(tidyverse)
library(phyloseq)
library(reshape2)
library(data.table)
library(broom)

#print working directory for future references
#note the GitHub directory for this script is as follows
#https://github.com/ShadeLab/meta_arsenic/tree/master/diversity_analysis
wd <- print(getwd())

#read in metadata
meta <- data.frame(read.delim(paste(wd, "/data/sample_map.txt", sep=""), sep="\t", header=TRUE))

#temporarily change working directories
setwd(paste(wd, "/data", sep = ""))

#list filenames of interest
filenames <- list.files(pattern="*_rformat_dist_0.1.txt")

#move back up directories
setwd(wd)

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
mixed.1 <- c("aioA_59", "arrA_44", "aioA_57", "arrA_41", "aioA_63", "arrA_40", "aioA_34", "arrA_31", "aioA_41", "arrA_49", "arrA_04", "aioA_20", "arrA_53", "aioA_65", "arxA_23", "arxA_13", "arxA_40", "arxA_39", "arxA_37", "arxA_19", "arxA_16", "arxA_24", "arxA_34", "arxA_02", "arxA_21", "arxA_15", "arxA_20", "arxA_24", "arxA_16", "arxA_19", "arxA_28")

#remove OTUs that are gene matches
otu_table <- otu_table[,!names(otu_table) %in% mixed.1]

#rename arrA column that is actually arxA (with no match)
#rename OTU with same number plus .# (1 = aioA, 2 = arrA, 3 = arxA)
#of the original otu call
otu_table <- otu_table %>%
  rename(arxA_30.2 = arrA_30,
         arxA_32.2 = arrA_32, 
         arxA_67.1 = aioA_67,
         arxA_45.1 = aioA_45)

#repeat for arrA misnames
otu_table <- otu_table %>%
  rename(arrA_31.3 = arxA_31, 
         arrA_12.3 = arxA_12,
         arrA_01.3 = arxA_01,
         arrA_07.3 = arxA_07,
         arrA_06.3 = arxA_06,
         arrA_14.3 = arxA_14,
         arrA_30.3 = arxA_30,
         arrA_38.3 = arxA_38,
         arrA_32.3 = arxA_32,
         arrA_33.3 = arxA_33,
         arrA_17.3 = arxA_17,
         arrA_03.3 = arxA_03,
         arrA_42.3 = arxA_42,
         arrA_09.3 = arxA_09,
         arrA_25.3 = arxA_25,
         arrA_08.3 = arxA_08,
         arrA_11.3 = arxA_11,
         arrA_18.3 = arxA_18,
         arrA_04.3 = arxA_04,
         arrA_10.3 = arxA_10,
         arrA_36.3 = arxA_36)


#replace all NAs (from join) with zeros
otu_table[is.na(otu_table)] <- 0

#remove duplicate switchgrass metagenome
otu_table <- otu_table[-which(otu_table$Sample == "Illinois_soil88.3"),]

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

#save rplB summary for iTOL later in analysis
rplB_summary_save <- rplB_summary
rplB_summary_save$Sample <- rownames(rplB_summary_save)
write.table(rplB_summary_save, file = paste(wd, "/output/rplB.summary.scg.txt", sep = ""))

#make sample a column in rplB
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
  left_join(meta, by = "Sample") %>%
  unique()

#save annotated gene abund file for RefSoil comparison
write.table(gene_abundance_annotated, file = paste(wd, "/output/metaG_normAbund.txt", sep = ""), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")

###################
#Centralia heatmap#
###################
#list OTUs present in 2 or more samples
#rownames(otu_table_norm) <- otu_table_norm$Sample
#otu_table_normPA <- t((otu_table_norm[3:ncol(otu_table_norm)]>0)*1)
#abund_2 <- t(otu_table_normPA[which(rowSums(otu_table_normPA) > 2),])

#remove OTUs with presence in 2 or less samples
#otu_table_norm.slim_2 <- data.frame(otu_table_norm[which(colnames(otu_table_norm) %in% colnames(abund_2))])
#otu_table_norm.slim_2 <- otu_table_norm.slim_2[grep("cen", rownames(otu_table_norm.slim_2)),]
#otu_table_norm.slim_2 <- t(otu_table_norm.slim_2[,-grep("rplB", colnames(otu_table_norm.slim_2))])

#library(pheatmap)
#callback = function(hc, mat){
#  sv = svd(t(mat))$v[,1]
#  dend = reorder(as.dendrogram(hc), wts = sv)
#  as.hclust(dend)
#}


#get heatmap colors
#hc=colorRampPalette(c("white", "#91bfdb", "midnightblue"), interpolate="linear", bias = 3)

#prep data for gene annotation on heatmap
#colors.otu.2 <- data.frame(otu_table_norm.slim_2)
#colors.otu.2_annotated <- colors.otu.2 %>%
#  rownames_to_column(var = "OTU") %>%
#  mutate(OTU = gsub("arsC_glut", "arsCgrx", OTU)) %>%
#  mutate(OTU = gsub("arsC_thio", "arsCtrx", OTU)) %>%
#  separate(col = OTU, into = c("Gene", "OTU"), sep = "_") %>%
#  mutate(Max = apply(colors.otu.2, 1, max)) %>%
#  select(Gene)
#rownames(colors.otu.2_annotated) <- rownames(colors.otu.2)


#set gene colors for plotting
#ann_colors = list(
#  Gene = c(acr3 = "#8DD3C7", aioA = "#FFFFB3", arrA = "#BEBADA", arsB = "#FB8072", arsCgrx = "#80B1D3", arsCtrx = "#FDB462", arsD = "#B3DE69", arsM = "#FCCDE5", arxA = "#D9D9D9"))

#order samples by temperature
#otu_table_norm.slim_2 <- data.frame(otu_table_norm.slim_2) %>% select(cen17, cen04, cen07, cen05, cen01, cen03, cen16, cen06, cen12, cen14, cen15, cen10, cen13)

#plot heatmap
#(heatmap <- pheatmap(otu_table_norm.slim_2, cluster_rows = TRUE, cluster_cols = FALSE, clustering_method = "complete", dendrogram = "row", scale = "none", trace = "none", legend = TRUE, cellheight = 6, color = hc(500), cellwidth = 12, treeheight_row = 50, fontsize = 8, border_color = NA, show_rownames = FALSE, annotation_colors = ann_colors,  annotation_row = colors.otu.2_annotated, clustering_callback = callback, width = 12, height = 16))

#############################
#EXAMINE RANK GENE ABUNDANCE#
#############################
#summarise normalized data (aka annotated gene abundance data)
gene_abundance_summary <- gene_abundance_annotated %>%
  group_by(Gene, Biome, Site, Sample) %>%
  summarise(Total = sum(RelativeAbundance)) %>%
  ungroup() %>%
  group_by(Gene, Site) %>%
  mutate(Mean = mean(Total))

gene_abundance_order <- gene_abundance_summary %>%
  group_by(Gene, Biome, Site) %>%
  summarise(Mean = mean(Total)) %>%
  arrange(Gene, Mean) %>%
  ungroup() %>%
  mutate(order = as.factor(row_number())) %>%
  select(-Mean)

gene_abundance_summary_order <- gene_abundance_order %>%
  left_join(gene_abundance_summary, by = c("Gene", "Biome", "Site")) %>%
  mutate(Gene = gsub("arsC_glut", "arsC (grx)", Gene)) %>%
  mutate(Gene = gsub("arsC_thio", "arsC (trx)", Gene))

gene_abundance_summary_order$gene_f = factor(gene_abundance_summary_order$Gene, levels=c("acr3", "arsB", "arsC (trx)", "arsC (grx)", "arsD", "arsM", "aioA", "arrA", "arxA"))

#plot bar graph with SITE means
(pointplot.site <- ggplot(subset(gene_abundance_summary_order, subset = Gene !="rplB")) +
    geom_point(size = 2.5, shape = 1, aes(x = order, y = Total, color = Site)) +
    geom_point(size = 2.1, shape = 1, aes(x = order, y = Total, color = Site)) +
    facet_wrap(~gene_f, ncol = 1, scales = "free") +
    ylab("rplB-normalized abundance") +
    theme_light(base_size = 10) +
    xlab("Site") +
    scale_color_manual(values = c("#808000", "#aa6e28", "#ffe119", "#f58231", "#aaffc3", "#fabebe", "#d2f53c", "#008080", "#3cb44b", "#ffd8b1", "#808080", "#911eb4", "#000080", "#46f0f0", "#0082c8", "grey75")) +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          legend.position = "none"))


#save bar graph with SITE means
ggsave(pointplot.site, filename = paste(wd, "/figures/ordered.point.site.eps", sep= ""),  height = 9, width = 2.5, units = "in")

#################################
#EXAMINE GENE RELATIVE ABUNDANCE#
#################################
gene_abundance_biome <- gene_abundance_summary %>%
  ungroup() %>%
  mutate(Gene = gsub("arsC_glut", "arsC (grx)", Gene)) %>%
  mutate(Gene = gsub("arsC_thio", "arsC (trx)", Gene)) %>%
  group_by(Gene, Biome, Site, Sample) %>%
  summarise(Mean = mean(Total)) %>%
  arrange(Biome, Site) %>%
  mutate(order = as.factor(row_number()),
         N =length(Site))

gene_abundance_biome$Gene = factor(gene_abundance_biome$Gene, levels=c("acr3", "arsB", "arsC (trx)", "arsC (grx)", "arsD", "arsM", "aioA", "arrA", "arxA"))

#Plot AsRG relative abundance by site
(relabund.plot <- ggplot(subset(gene_abundance_biome, subset = Gene !="rplB"), aes(x = Site, y = Mean/N, fill = Gene)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values = c("#8BD1C4", "#F98072", "#F3A955", "#80B1D3", "#FFFFB3", "#B9E563", "#919191", "#C58CDC", "#FBB8DA")) +
  ylab("Relative Abundance") +
  theme_bw(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)))

ggsave(relabund.plot, filename = paste(wd, "/figures/relative_abundance.eps", sep = ""), width = 5.5, height = 4, units = "in")

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
ggsave(phylum.plot, filename = paste(wd, "/figures/community.structure.full.eps", sep=""), width = 12, height = 6)

#extract 6 most abundant phyla
#top 6 were chosen so that at least
#70% of each community was represented
top.phyla <- c("Proteobacteria", "Actinobacteria", "Verrucomicrobia", "Firmicutes", "Acidobacteria", "Chloroflexi")

#plot community structure of top phyla
(phylum.plot.top=(ggplot(subset(history, subset = Phylum %in% top.phyla),
                         aes(x=Site, y=Average, fill = Phylum)) +
                    geom_bar(stat = "identity") +
                    scale_fill_manual(values = c("#FDB462", "#F4CAE4", "#999999", "#E6AB02", "#7FC97F", "#666666")) +
                    labs(x="Phylum", y="Mean relative abundance") +
                    theme_bw(base_size = 12) +
                    theme(axis.text.x = element_text(angle = 45, size = 10, 
                                                     hjust=0.99,vjust=0.99))))

#save plot of top phyla
ggsave(phylum.plot.top, filename = paste(wd, "/figures/community.structure.top.eps", sep=""), units = "in", width = 6, height = 4)

################################
#HEATMAP ANALYSIS OF ASRG ABUND#
################################

library(reshape2)
heatmap.cast <- dcast(gene_abundance_summary, Gene~Sample, value.var = "Total")
rownames(heatmap.cast) <- heatmap.cast$Gene
heatmap.cast <- heatmap.cast[-10,-1]

#set up environment to run heatmap
library(pheatmap)
callback = function(hc, mat){
  sv = svd(t(mat))$v[,1]
  dend = reorder(as.dendrogram(hc), wts = sv)
  as.hclust(dend)
}

#get heatmap colors
hc=colorRampPalette(c("white", "#91bfdb", "midnightblue"), interpolate="linear", bias = 3)


#prep data for gene annotation on heatmap
colors.otu.2 <- data.frame(t(heatmap.cast))
colors.otu.2_annotated <- colors.otu.2 %>%
  rownames_to_column(var = "Sample") %>%
  left_join(meta, by = c("Sample")) %>%
  select(Site, Biome)
rownames(colors.otu.2_annotated) <- rownames(colors.otu.2)

#set gene colors for plotting
ann_colors = list(
  Site = c(Brazilian_forest = "#808000", California_grassland = "#aa6e28", Centralia_recovered = "#ffe119", Centralia_active = "#f58231", Centralia_reference = "#aaffc3", Disney_preserve = "#fabebe", Illinois_switchgrass = "#d2f53c", Illinois_soybean = "#008080", Iowa_agricultural = "#3cb44b", Iowa_corn = "#ffd8b1", Iowa_prairie = "#808080", Mangrove = "#911eb4", Minnesota_grassland = "#000080", Permafrost_Canada = "#46f0f0", Permafrost_Russia = "#0082c8", Wyoming_soil ="#FFFFFF"), 
  Biome = c(permafrost = "white", mangrove = "black",agricultural = "#cb181d", `non-agricultural` = "#fb6a4a", coal_seam_fire = "#fcae91", recovered = "#fee5d9"))


pheatmap(t(heatmap.cast), cluster_rows = TRUE, cluster_cols = FALSE, clustering_method = "complete", color = hc(100), dendrogram = "row", scale = "none", trace = "none", legend = TRUE, clustering_callback = callback, annotation_row = colors.otu.2_annotated, annotation_colors = ann_colors, show_rownames = FALSE)

#####################
#SHARED OTU ANALYSIS#
#####################
gene_abundance_non <- gene_abundance[!grepl("rplB.", gene_abundance$OTU),]

gene_abundance_non <- gene_abundance_non %>%
  left_join(meta, by = "Sample") %>%
  group_by(Site, Gene, OTU) %>%
  summarise(MeanRelativeAbundance = mean(RelativeAbundance))

gene_abundance_cast <- gene_abundance_non %>%
  dcast(Site ~ OTU, value.var = "MeanRelativeAbundance")

rownames(gene_abundance_cast) <- gene_abundance_cast$Site
gene_abundance_cast <- select(gene_abundance_cast, -Site)

#make PA matrix
gene_abundance_castPA <- (gene_abundance_cast > 0)*1

#list all otus present in > 1 site
gene_abundance_castPA_2 <- gene_abundance_castPA[,which(colSums(gene_abundance_castPA) > 2)]

#slim gene_abundance based on site presence
gene_abundance_cast_2 <- gene_abundance_cast[,colnames(gene_abundance_cast) %in% colnames(gene_abundance_castPA_2)]

#remove samples with no otus
gene_abundance_cast_2 <- gene_abundance_cast_2[rowSums(gene_abundance_cast_2) >0,]

#melt data
gene_abundance_cast_2_melt <- gene_abundance_cast_2 %>%
  mutate(Sample = rownames(.)) %>%
  melt(id.vars = "Sample", variable.name = "OTU", value.name = "NormalizedAbundance") %>%
  separate(OTU, into = "Gene", by = "_", remove = FALSE) %>%
  mutate(NormalizedAbundance = ifelse(NormalizedAbundance == 0, NA, NormalizedAbundance)) %>%
  mutate(OTU = gsub("arsCglut", "arsC (grx)", OTU), 
         OTU = gsub("arsCthio", "arsC (trx)", OTU), 
         OTU = gsub("_", "-", OTU))

#plot data
(otu.shared <- ggplot(gene_abundance_cast_2_melt, aes(y = OTU, x = Sample)) +
  geom_point(aes(size = NormalizedAbundance, color = Sample)) +
  #facet_wrap(~Gene, scales = "free_x") +
  theme_light() +
  theme(axis.text.x = element_blank()) +
  scale_color_manual(values = c("#808000", "#ffe119", "#f58231", "#aaffc3", "#fabebe", "#d2f53c", "#008080", "#3cb44b", "#ffd8b1", "#808080", "#911eb4", "#000080", "#46f0f0", "#0082c8", "grey75")))

ggsave(otu.shared, filename = paste(wd, "/figures/shared.otus.eps", sep = ""), height = 6, width = 4.5, units = "in")

#what portion are endemic?
abund_occur <- gene_abundance_annotated %>%
  mutate(Site = gsub("Centralia_.*", "Centralia", Site)) %>%
  group_by(Site, Gene, OTU) %>%
  subset(RelativeAbundance > 0) %>%
  summarise(MeanAbund = mean(RelativeAbundance)) %>%
  group_by(OTU) %>%
  mutate(Occur = length(OTU)) %>%
  subset(Gene !="rplB") 

occur_stats <- abund_occur %>%
  group_by(Gene, OTU, Occur) %>%
  summarise() %>%
  group_by(Gene) %>%
  mutate(total = length(Gene)) %>%
  mutate(occurPA = ifelse(Occur > 1, 0, 1)) %>%
  group_by(Gene, total) %>%
  summarise(endemic = sum(occurPA)) %>%
  mutate(endemic.perc = endemic/total)

ggplot(abund_occur, aes(y = MeanAbund, x = Occur, color = Gene)) +
  geom_jitter(shape = 1, width = 0.1) +
  scale_y_log10() +
  facet_wrap(~Gene)

##############################
#Community membership v. AsRG OLDDDDDDDDD#
##############################
otu_table_slim <- otu_table_norm[grepl("cen01|cen03|cen04|cen05|cen06|cen07|cen10|cen12|cen13|cen14|cen15|cen16|cen17", otu_table_norm$Sample),]

#make sample the row names
rownames(otu_table_slim) <- otu_table_slim$Sample
otu_table_slim <- otu_table_slim[,-c(1,2)]

#separate OTU table into 2: rplB and AsRG
otu_table.rplB <- otu_table_slim[, grep("rplB", colnames(otu_table_slim))]
#otu_table.rplB <- otu_table.rplB[, -which(colSums(otu_table.rplB) < 2)]

otu_table.AsRG <- otu_table_slim[, grep("ars|aio|arx|arr|acr", colnames(otu_table_slim))]
#otu_table.AsRG <- otu_table.AsRG[, -which(colSums(otu_table.AsRG) < 2)]
#otu_table.AsRG <- otu_table.AsRG[-which(rowSums(otu_table.AsRG) == 0),]

#otu_table.rplB <- otu_table.rplB[which(rownames(otu_table.rplB) %in% rownames(otu_table.AsRG)),]


#make metadata a phyloseq class object
#meta.phylo <- sample_data(cen_meta)
row.names(meta) <- meta$Sample
meta.phylo <- sample_data(meta)

##make biom for phyloseq
rare_rplB <- merge_phyloseq(otu_table(otu_table.rplB, taxa_are_rows = FALSE), meta.phylo)
rare_AsRG <- merge_phyloseq(otu_table(otu_table.AsRG, taxa_are_rows = FALSE), meta.phylo)

#relativize rarefied datasets
rare_rplB_rel = transform_sample_counts(rare_rplB, function(x) x/sum(x))

rare_AsRG_rel = transform_sample_counts(rare_AsRG, function(x) x/sum(x))

#plot Bray Curtis ordination for rplB
ord.rplB.bray <- ordinate(rare_rplB_rel, method="PCoA", distance="bray")
(bc.ord=plot_ordination(rare_rplB_rel, ord.rplB.bray, color="Site",
                        title="Bray Curtis (rplB)", label = "Sample") +
    geom_point(size=5, alpha = 0.5) +
    theme_light(base_size = 15))

ggsave(bc.ord, filename = paste(wd, "/figures/cen.bc.rplb.png", sep = ""))

#plot Bray Curtis ordination for AsRGs
ord.AsRG.bray <- ordinate(rare_AsRG_rel, method="PCoA", distance="bray")
(bc.ord=plot_ordination(rare_AsRG_rel, ord.AsRG.bray, color="Site",
                        title="Bray Curtis (AsRG)", label = "Sample") +
    geom_point(size=5, alpha = 0.5) +
    theme_light(base_size = 15))

ggsave(bc.ord, filename = paste(wd, "/figures/cen.bc.Asrg.png", sep = ""))


#extract OTU table from phyloseq
rare_rplB_rel.matrix = as(otu_table(rare_rplB_rel), "matrix")
rare_AsRG_rel.matrix = as(otu_table(rare_AsRG_rel), "matrix")

#calculate distance matrix
otu_rplB.d <- vegdist(rare_rplB_rel.matrix, diag = TRUE, upper = TRUE)
otu_AsRG.d <- vegdist(rare_AsRG_rel.matrix, diag = TRUE, upper = TRUE)

#mantel test between rplB and AsRG
mantel(otu_AsRG.d,otu_rplB.d, method = "spear")

################################
#Centralia metadata stats +AsRG#
################################
#remove sites with low rplB (ie low seq depth/ confidence)
otu_table_cen <- otu_table_norm[grepl("cen01|cen03|cen04|cen05|cen06|cen07|cen10|cen12|cen13|cen14|cen15|cen16|cen17", otu_table_norm$Sample),]

#melt AsRG data by gene
asrg_cen <- otu_table_cen %>%
  select(-sum.rplB) %>%
  melt(variable.names = c("Sample", "OTU"), value.name = "RelativeAbundance") %>%
  rename(OTU = variable, Site = Sample) %>%
  mutate(OTU = gsub("arsC_", "arsC", OTU), 
         Site = gsub("cen", "Cen", Site)) %>%
  separate(col = OTU, into = c("Gene", "Number"), sep = "_", remove = FALSE) %>%
  left_join(cen_meta, by = "Site")

#add gene counts per site
asrg_cen_summary <- asrg_cen %>%
  group_by(Gene, Site) %>%
    summarise(Total = sum(RelativeAbundance)) %>%
  left_join(cen_meta, by = "Site") %>%
  subset(Classification !="Reference")

#make color pallette for Centralia temperatures
GnYlOrRd <- colorRampPalette(colors=c("green", "yellow", "orange","red"), bias=2)

#plot arsM abundance per temperature
(arsM.cen <- ggplot(subset(asrg_cen_summary, Gene == "arsM"), aes(x = Classification, Total)) +
  geom_boxplot() +
  geom_jitter(aes(color = SoilTemperature_to10cm)) +
  scale_color_gradientn(colours=GnYlOrRd(5), guide="colorbar", 
                        guide_legend(title="Temperature (°C)")) +
  ylab("Normalized abundance") +
  theme_bw(base_size = 8))

ggsave(arsM.cen, filename = paste(wd, "/figures/arsM.cen.eps", sep = ""), height = 1.6, width = 3, units = "in")

#plot aioA abundance
(aioA.cen <- ggplot(subset(asrg_cen_summary, Gene == "aioA"), aes(x = Classification, Total)) +
    geom_boxplot() +
    geom_jitter(aes(color = SoilTemperature_to10cm)) +
    scale_color_gradientn(colours=GnYlOrRd(5), guide="colorbar", 
                          guide_legend(title="Temperature (°C)")) +
    ylab("Normalized abundance") +
    theme_bw(base_size = 8))

ggsave(aioA.cen, filename = paste(wd, "/figures/aioA.cen.eps", sep = ""), height = 1.6, width = 3, units = "in")
