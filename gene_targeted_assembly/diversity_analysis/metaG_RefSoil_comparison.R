#####################
#ENVIRONMENTAL SETUP#
#####################
#load required packages
library(tidyverse)
library(reshape2)
library(broom)

#set working directory
wd <- paste(getwd())

#read in metaG normalzied abundance data
metaG <- read_delim(file = paste(wd, "/output/metaG_normAbund.txt", sep = ""), delim = "\t")

#read in RefSoil count data
refSoil <- read_delim(file = paste(wd, "/../../gene_search/output/RefSoil_count.txt", sep = ""), delim = "\t")

#tidy metaG data
#(i.e. summarise per gene)
metaG.tidy <- metaG %>%
  group_by(Biome, Site, Sample, Gene) %>%
  summarise(total.abund = sum(RelativeAbundance))  

#tidy RefSoil data
#(i.e. transform list to count information)
refSoil.tidy <- refSoil %>%
  #subset(Gene !="None") %>%
  dcast(Gene~`RefSoil ID`, length) %>%
  melt(id.vars = "Gene",value.name = "Count")%>%
  group_by(Gene) %>%
  summarise(abund = sum(Count), N = length(Count)) %>%
  mutate(RefSoil.abund = abund/N) %>%
  select(Gene, RefSoil.abund) %>%
  mutate(log.RefSoil.abund = log(RefSoil.abund))


#test differences between arsB
arsB <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arsB")
shapiro.test(log(arsB$total.abund))
arsB.t <- tidy(t.test(arsB$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arsB",3])), conf.level = 0.99)

#test difference w arsC
arsC_thio <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arsC_thio")
shapiro.test(log(arsC_thio$total.abund))
arsC_thio.t <- tidy(t.test(arsC_thio$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arsC_thio",3])), conf.level = 0.99)

#test difference w arsC (grx)
arsC_glut <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arsC_glut")
shapiro.test(log(arsC_glut$total.abund))
arsC_glut.t <- tidy(t.test(arsC_glut$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arsC_glut",3])), conf.level = 0.99)

#test difference with arxA
arxA <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arxA")
shapiro.test(log(arxA$total.abund))
arxA.t <- tidy(t.test(arxA$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arxA",3])), conf.level = 0.99)

#test difference with arrA
arrA <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arrA")
shapiro.test(log(arrA$total.abund))
arrA.t <- tidy(t.test(arrA$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arrA",3])), conf.level = 0.99)

#test difference with aioA
aioA <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "aioA")
shapiro.test(log(aioA$total.abund))
aioA.t <- tidy(t.test(aioA$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "aioA",3])), conf.level = 0.99)

#test difference with acr3
acr3 <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "acr3")
shapiro.test(log(acr3$total.abund))
acr3.t <- tidy(t.test(acr3$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "acr3",3])), conf.level = 0.99)

#test difference with arsD
arsD <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arsD")
shapiro.test(log(arsD$total.abund))
arsD.t <- tidy(t.test(arsD$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arsD",3])), conf.level = 0.99)

arsM <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene) %>% subset(Gene == "arsM")
shapiro.test(log(arsM$total.abund))
arsM.t <- tidy(wilcox.test(arsM$log, mu=as.numeric(refSoil.tidy[refSoil.tidy$Gene == "arsC_thio",3])), conf.level = 0.99)

all <- rbind(arsB.t, arsC_glut.t, arsC_thio.t, acr3.t, arsD.t, arsM.t, arrA.t, arxA.t, aioA.t)

all$p.adjust <- p.adjust(all$p.value, method = p.adjust.methods, n = length(all$p.value))


metaG.tidy.nozero <- metaG.tidy %>% subset(total.abund != 0.0000000000) %>% mutate(log = log(total.abund)) %>% group_by(Gene)

no <- c("arsA", "None", "rplB")
(comp.plot <- ggplot(subset(metaG.tidy.nozero, Gene != "rplB"), aes(x = Gene, y = total.abund)) +
  geom_boxplot() +
  geom_point(data = subset(refSoil.tidy, !Gene %in% no), aes(y = RefSoil.abund), color = "springgreen3", size = 3) +
  ylab("Normalized abundance") +
  theme_bw(base_size = 16) +
  theme(axis.text.x = element_text(angle = 45,
                                   hjust=0.99,vjust=0.99)))

ggsave(comp.plot, filename = paste(wd, "/figures/refsoil_metaG_comparison.eps", sep = ""))


refsoil.tidy.annotated <- refSoil.tidy %>%
  mutate(Biome = "RefSoil", 
         Sample = "RefSoil", 
         Site = "RefSoil") %>%
  rename(total.abund = RefSoil.abund) %>%
  select(Biome, Site, Sample, Gene, total.abund)
metaG.tidy.RefSoil <- rbind(data.frame(refsoil.tidy.annotated), data.frame(metaG.tidy))
  
metaG.tidy.nozero.RefSoil <- metaG.tidy.RefSoil %>% 
  subset(total.abund != 0.0000000000) %>% 
  group_by(Gene) %>% 
  mutate(N = paste(length(Gene), ")", sep = "")) %>% 
  unite(col = Gene_n, c(Gene, N), sep = "_(", remove = FALSE) 

#add N info to original refsoil data
refsoil.tidy.annotated.n <- refsoil.tidy.annotated %>%
  select(-total.abund) %>%
  left_join(subset(metaG.tidy.nozero.RefSoil, Site == "RefSoil"), by = c("Biome", "Sample", "Site", "Gene")) %>%
  select(Gene_n, total.abund)

no <- c("arsA_(1)", "None_(1)", "rplB_(39)")
(comp.plot.refsoil.outlier <- ggplot(subset(metaG.tidy.nozero.RefSoil, !Gene_n %in% no), aes(x = Gene_n, y = total.abund)) +
    geom_boxplot(outlier.size = 2) +
    geom_point(data = subset(refsoil.tidy.annotated.n, !Gene_n %in% no), aes(x = Gene_n, y = total.abund), color = "springgreen3", shape = 23, size = 4) +
    ylab("Normalized abundance") +
    theme_bw(base_size = 16) +
    theme(axis.text.x = element_text(angle = 45,
                                     hjust=0.99,vjust=0.99)))
ggsave(comp.plot.refsoil.outlier, filename = paste(wd, "/figures/refsoil_metaG_comparison_outlier.eps", sep = ""))
