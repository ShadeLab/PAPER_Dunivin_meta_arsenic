#####################
#ENVIRONMENTAL SETUP#
#####################
#load required packages
library(tidyverse)
library(reshape2)
library(broom)
library(ggpubr)

#set working directory
wd <- paste(getwd())

#read in metaG normalzied abundance data
metaG <- read_delim(file = paste(wd, "/output/metaG_normAbund.txt", sep = ""), delim = "\t")

#read in RefSoil count data
refSoil <- read_delim(file = paste(wd, "/../../HMM_search/RefSoil_HMM_search/output/RefSoil_count.txt", sep = ""), delim = "\t")

#tidy metaG data
#(i.e. summarise per gene)
metaG.tidy <- metaG %>%
  group_by(Biome, Site, Sample, Gene) %>%
  summarise(total.abund = sum(RelativeAbundance))  

#tidy RefSoil data
#(i.e. transform list to count information)
refSoil.tidy <- refSoil %>%
  group_by(Gene) %>%
  summarise(abund = sum(Total), N = 922) %>%
  mutate(RefSoil.abund = abund/N) %>%
  select(Gene, RefSoil.abund) %>%
  mutate(log.RefSoil.abund = log(RefSoil.abund))

no <- c("arsA", "None", "rplB")

refsoil.tidy.annotated <- refSoil.tidy %>%
  mutate(Biome = "RefSoil", 
         Sample = "RefSoil", 
         Site = "RefSoil") %>%
  rename(total.abund = RefSoil.abund) %>%
  select(Biome, Site, Sample, Gene, total.abund) %>%
  mutate(Gene = factor(Gene,levels = c("acr3", "arsB","arsD", "arsC_glut", "arsC_thio",  "arsM","arrA", "aioA", "arxA", "rplB", "None"), ordered = TRUE))

metaG.tidy.RefSoil <- rbind(data.frame(refsoil.tidy.annotated), data.frame(metaG.tidy))
  
metaG.tidy.nozero.RefSoil <- metaG.tidy.RefSoil %>% 
  subset(total.abund != 0.0000000000) %>% 
  group_by(Gene) %>%
  mutate(N = paste(length(Gene), ")", sep = "")) %>% 
  unite(col = Gene_n, c(Gene, N), sep = " (", remove = FALSE)  %>%
  ungroup() %>%
  mutate(Gene_n = factor(Gene_n, levels = c("acr3 (29)", "arsB (5)","arsD (21)", "arsC_glut (39)", "arsC_thio (27)",  "arsM (35)","arrA (5)", "aioA (23)", "arxA (4)", "rplB (38)", "None (1)")))

#add N info to original refsoil data
refsoil.tidy.annotated.n <- refsoil.tidy.annotated %>%
  select(-total.abund) %>%
  left_join(subset(metaG.tidy.nozero.RefSoil, Site == "RefSoil"), by = c("Biome", "Sample", "Site", "Gene")) %>%
  select(Gene_n, total.abund) %>%
  mutate(Gene_n = factor(Gene_n, levels = c("acr3 (29)", "arsB (5)","arsD (21)", "arsC_glut (39)", "arsC_thio (27)",  "arsM (35)","arrA (5)", "aioA (23)", "arxA (4)", "rplB (38)", "None (1)")))


no <- c("arsA (1)", "None (1)", "rplB (38)")
(comp.plot.refsoil.outlier <- ggplot(subset(metaG.tidy.nozero.RefSoil, !Gene_n %in% no), aes(x = Gene_n, y = total.abund)) +
    geom_boxplot(outlier.size = 2) +
    geom_point(data = subset(refsoil.tidy.annotated.n, !Gene_n %in% no), aes(x = Gene_n, y = total.abund), color = "springgreen3", shape = 23, size = 4) +
    ylab("Normalized abundance") +
    theme_bw(base_size = 16) +
    xlab("Gene") + 
    theme(axis.text.x = element_text(angle = 45,
                                     hjust=0.99,vjust=0.99)))
ggsave(comp.plot.refsoil.outlier, filename = paste(wd, "/figures/refsoil_metaG_comparison_outlier.eps", sep = ""))

#read in groups
groups <- read.delim("../metagenome_analysis/data/detox_metab.txt", sep = "\t")

#join w metag info
metaG.tidy.annotated <- metaG.tidy %>%
  left_join(groups, by = "Gene") %>%
  subset(Gene!="rplB") 

#perform statistics comparing gene abundance in metaG
metab_detox <- tidy(wilcox.test(metaG.tidy.annotated$total.abund~metaG.tidy.annotated$Category))

efflux <- metaG.tidy.annotated %>%
  subset(Description == "efflux") %>%
  group_by(Site)

efflux.stats <- tidy(wilcox.test(efflux$total.abund~efflux$Gene))


reduc <- metaG.tidy.annotated %>%
  subset(Description == "cyto_reductase") %>%
  group_by(Site)

reduc.stats <- tidy(wilcox.test(reduc$total.abund~reduc$Gene))

#read in refsoil abund data
