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
                facet_wrap(~Site, ncol = 2) +
                theme_bw(base_size = 8) +
                theme(axis.text.x = element_text(angle = 90, size = 8, 
                                                 hjust=0.99,vjust=0.99))))

#save full community structure
ggsave(phylum.plot, filename = paste(wd, "/figures/community.structure.full.eps", sep=""), width = 6.8, height = 10, units = "in")

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
  theme_light() +
  theme(axis.text.x = element_blank()) +
  scale_color_manual(values = c("#808000", "#ffe119", "#f58231", "#aaffc3", "#fabebe", "#d2f53c", "#008080", "#3cb44b", "#ffd8b1", "#808080", "#911eb4", "#000080", "#46f0f0", "#0082c8", "grey75")))

ggsave(otu.shared, filename = paste(wd, "/figures/shared.otus.eps", sep = ""), height = 6, width = 4.5, units = "in")

#what portion are endemic?
abund_occur <- gene_abundance_annotated %>%
  #mutate(Site = gsub("Centralia_.*", "Centralia", Site)) %>%
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
  mutate(occurPA = ifelse(Occur > 2, 0, 1)) %>%
  group_by(Gene, total) %>%
  summarise(endemic = sum(occurPA)) %>%
  mutate(endemic.perc = endemic/total)

write.table(occur_stats, file = "output/occurrence_statistics.txt", quote = FALSE, row.names = FALSE, col.names = TRUE, sep = "\t")

(abund_occur_plot <- ggplot(abund_occur, aes(y = MeanAbund, x = as.character(Occur))) +
  geom_jitter(shape = 1, width = 0.1) +
  scale_y_log10() +
  facet_wrap(~Gene, ncol = 1) +
    xlab("Occurrence") +
    ylab("rplB-normalized abundance") +
  theme_light())

ggsave(abund_occur_plot, filename = "figures/abund.occur.plot.eps", height = 9, width = 2.5, units = "in")

#make spatial distance matrix
coord <- read.delim("data/literature_coordinates.txt", sep = "\t")

#add function from 
#https://eurekastatistics.com/calculating-a-distance-matrix-for-geographic-points-using-r/
ReplaceLowerOrUpperTriangle <- function(m, triangle.to.replace){
  # If triangle.to.replace="lower", replaces the lower triangle of a square matrix with its upper triangle.
  # If triangle.to.replace="upper", replaces the upper triangle of a square matrix with its lower triangle.
  
  if (nrow(m) != ncol(m)) stop("Supplied matrix must be square.")
  if      (tolower(triangle.to.replace) == "lower") tri <- lower.tri(m)
  else if (tolower(triangle.to.replace) == "upper") tri <- upper.tri(m)
  else stop("triangle.to.replace must be set to 'lower' or 'upper'.")
  m[tri] <- t(m)[tri]
  return(m)
}
GeoDistanceInMetresMatrix <- function(df.geopoints){
  # Returns a matrix (M) of distances between geographic points.
  # M[i,j] = M[j,i] = Distance between (df.geopoints$lat[i], df.geopoints$lon[i]) and
  # (df.geopoints$lat[j], df.geopoints$lon[j]).
  # The row and column names are given by df.geopoints$name.
  
  GeoDistanceInMetres <- function(g1, g2){
    # Returns a vector of distances. (But if g1$index > g2$index, returns zero.)
    # The 1st value in the returned vector is the distance between g1[[1]] and g2[[1]].
    # The 2nd value in the returned vector is the distance between g1[[2]] and g2[[2]]. Etc.
    # Each g1[[x]] or g2[[x]] must be a list with named elements "index", "lat" and "lon".
    # E.g. g1 <- list(list("index"=1, "lat"=12.1, "lon"=10.1), list("index"=3, "lat"=12.1, "lon"=13.2))
    DistM <- function(g1, g2){
      require("Imap")
      return(ifelse(g1$index > g2$index, 0, gdist(lat.1=g1$lat, lon.1=g1$lon, lat.2=g2$lat, lon.2=g2$lon, units="m")))
    }
    return(mapply(DistM, g1, g2))
  }
  
  n.geopoints <- nrow(df.geopoints)
  
  # The index column is used to ensure we only do calculations for the upper triangle of points
  df.geopoints$index <- 1:n.geopoints
  
  # Create a list of lists
  list.geopoints <- by(df.geopoints[,c("index", "lat", "lon")], 1:n.geopoints, function(x){return(list(x))})
  
  # Get a matrix of distances (in metres)
  mat.distances <- ReplaceLowerOrUpperTriangle(outer(list.geopoints, list.geopoints, GeoDistanceInMetres), "lower")
  
  # Set the row and column names
  rownames(mat.distances) <- df.geopoints$name
  colnames(mat.distances) <- df.geopoints$name
  
  return(mat.distances)
}

#calculate geographical distances
library(Imap)
coord_dist <- round(GeoDistanceInMetresMatrix(coord) / 1000)
colnames(coord_dist) <- rownames(coord_dist)
coord_dist_a <- coord_dist[ order(row.names(coord_dist)), ]

#make gene abundance summary into distance matrix
as_table <- gene_abundance_summary %>%
  dcast(Sample ~ Gene, value.var = "Total") %>%
  select(-rplB) %>%
  column_to_rownames("Sample") 

as_table_norm <- as_table
for(i in 1:nrow(as_table_norm)){as_table_norm[i,]=as_table[i,]/sum(as_table[i,])}

#as distance
as_table.d <- vegdist(as_table_norm, diag = TRUE, upper = TRUE)

mantel(as_table.d,coord_dist_a, method = "spear")

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
