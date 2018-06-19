#####################
#ENVIRONMENTAL SETUP#
#####################
#load required packages
library(tidyverse)
library(reshape2)

wd <- paste(getwd())

##read in data
#temporarily change working directories
setwd(paste(wd, "/data/assessments", sep = ""))

#list filenames of interest
filenames <- list.files(pattern="*framebotstats.txt")

#make dataframes of all OTU tables
qual.data <-  data.frame(do.call(rbind, lapply(filenames, function(x){read.delim(file=x,header=FALSE)})))

#move back up directories
setwd(wd)

#read in metadata
meta.qual <- data.frame(read.delim(paste(wd, "/data/sample_map_qual.txt", sep=""), sep="\t", header=TRUE))

#read in gene hmm data
hmm.length <- data.frame(read.delim(paste(wd, "/data/hmm_length.txt", sep = ""), sep= "\t", header = TRUE))

#tidy data
qual.data.tidy <- qual.data %>%
  select(-c(V1, V8, V9)) %>%
  rename(Accno = V2, Query = V3, NucLength = V4, AlignLength = V5, P.Identity = V6, Score = V7) %>%
  mutate(Query = gsub("arsC_", "arsC", Query),
         Query = gsub("cen", "Centralia_", Query),
         Query = gsub("Mangrove", "Malaysia_mangrove", Query), 
         Query = gsub("Russia_", "Russia", Query), 
         Query = gsub("IowaPr", "Iowa_prairie", Query)) %>%
  separate(col = Query, into = c("Sample1", "Sample2" ,"Gene"), sep = "_") %>%
  unite(col = Sample, Sample1, Sample2, sep = "_") %>%
  left_join(meta.qual, by = "Sample") %>%
  left_join(hmm.length, by = "Gene")

#plot lenght v. identity
(qual.plot <- ggplot(subset(qual.data.tidy, Gene !="rplB"), aes(x = P.Identity, y = NucLength)) +
  geom_point(alpha = 1, aes(color = Site), shape = 1) +
  geom_hline(aes(yintercept = HMMlength*3*0.7), color = "black") +
  facet_wrap(~Gene, scales = "free_y", ncol = 3) +
  scale_color_manual(values = c("#808000", "#aa6e28", "#ffe119", "#f58231", "#aaffc3", "#fabebe", "#d2f53c", "#008080", "#3cb44b", "#ffd8b1", "#808080", "#911eb4", "#000080", "#46f0f0", "#0082c8", "grey75")) +
  theme_bw(base_size = 12) +
  ylim(0, NA) +
  xlim(0, NA) +
  ylab("Assembled length (bp)") +
  xlab("Percent Identity"))

ggsave(qual.plot, filename = paste(wd, "/figures/asrg.quality.eps", sep = ""), units = "mm", width = 178, height = 125)

##########################
#MAp#
library(maps)

#read in literature coordinate data
coord <- read_delim(paste(wd, "/data/literature_coordinates.txt", sep = ""), delim = "\t")

#plot onto world map
meta.qual <- meta.qual %>% group_by(Site) %>%
  mutate(N = length(Site))


#plot onto world map
mapWorld <- borders("world", fill = "white", colour = "white")
(map.plot <- ggplot() + 
  mapWorld + 
  #geom_point(data = meta.qual, aes(x=Lon, y=Lat, color = Site), alpha = 0.15, size = 2) +
  geom_point(data = meta.qual, aes(x=Lon, y=Lat, color = Site), size = 3, shape = 9) +
  geom_point(data = coord, aes(x=Lon, y=Lat), color = "black") +
  scale_size(range = c(3,10)) + 
  theme_classic() + 
  scale_color_manual(values = c("#808000", "#aa6e28", "#ffe119", "#f58231", "#aaffc3", "#fabebe", "#d2f53c", "#008080", "#3cb44b", "#ffd8b1", "#808080", "#911eb4", "#000080", "#46f0f0", "#0082c8", "grey75")) +
  theme(panel.background = element_rect(fill='grey80')))

ggsave(map.plot, filename = paste(wd, "/figures/site.map.eps", sep = ""), units = "in", width = 7, height = 3.5)


#read in literature data
literature <- read_delim(paste(wd, "/data/study_summary.txt", sep = ""), delim = "\t")

#plot data
(literatire.plot <- ggplot(literature, aes(x = Year, y = Samples, fill = Analysis)) +
    geom_bar(stat = "identity", color = "black") +
    scale_fill_manual(values = c("#E41A1C", "mistyrose", "#377EB8")) +
    theme_bw(base_size = 10) +
    ylab("Number of metagenomes"))

ggsave(literatire.plot, filename = paste(wd, "/figures/literature_summary.eps", sep = ""), width = 6, height = 3, units = "in")

