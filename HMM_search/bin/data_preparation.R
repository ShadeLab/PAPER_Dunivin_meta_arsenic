#######################################
#READ IN AND PREPARE DATA FOR ANALYSIS#
#######################################

#load dependencies or install 
library(tidyverse)

#print working directory for future references
wd <- print(getwd())

#temporarily change working directory to data to bulk load files
setwd(paste(wd, "/data", sep = ""))

#read in abundance data
names=list.files(pattern="*.tbl.txt")
data <- do.call(rbind, lapply(names, function(X) {
  data.frame(id = basename(X), read.table(X))}))

#fix working directory
setwd(wd)

#remove unnecessary columns
data <- data %>%
  mutate(id = gsub(".0.0000000001.tbl.txt", "", id)) %>%
  separate(col = id, into = c("Gene", "Sample"), sep = "[.]", extra = "merge") %>%
  select(-c(V2, V5, V23))

#add column names
#known from http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf
colnames(data) <- c("Gene", "Sample", "t.name", "t.length", "q.name", "q.length", "e.value", "score1", "bias1", "#", "of", "c.evalue", "i.evalue", "score2", "bias2", "from.hmm", "to.hmm", "from.ali", "to.ali", "from.env", "to.env", "acc", "NCBI.ID")

#Calculate the length of the alignment
data <- data %>%
  mutate(length = to.ali - from.ali) %>%
  mutate(perc.ali = length / q.length)

#plot data quality distribution
(quality <- ggplot(data, aes(x = perc.ali, y = score1)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~Gene, scales = "free_y") +
    ylab("Score") +
    xlab("Percent alignment") +
    theme_bw(base_size = 10))

ggsave(quality, filename = paste(wd, "/figures/search.quality.png", sep = ""), width = 5.5, height = 4, units = "in")

#remove rows that do not have at least 90% 
#of hmm length (std)
data.90 <- data[which(data$perc.ali > 0.90 & data$score1 > 100 & data$acc > 0.70),]


#examine if any HMM hits apply to two genes
duplicates <- data.90[duplicated(data.90$t.name),]

#of the duplicates, all are arrA/aioA mixed hits
#we will accept the one with a higher score
#arrange data by score
data.90 <- data.90[order(data.90$t.name, abs(data.90$score1), decreasing = TRUE), ] 

#remove duplicates that have the lower score
data.90 <- data.90[!duplicated(data.90$t.name),]

#plot data quality distribution
ggplot(data.90, aes(x = perc.ali, y = score1)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~Gene, scales = "free_y")


#dissim must have a score > 1000 so it doesnt
#pick up thiosulfate reductases
data.90 <- data.90[-which(data.90$Gene == "arxA" & data.90$score1 < 1000),]
data.90 <- data.90[-which(data.90$Gene == "aioA" & data.90$score1 < 1000),]

#save table to output
write.table(data.90, paste(wd, "/output/AsRG_summary.txt", sep = ""), sep = "\t", quote = FALSE, row.names = FALSE)

####################################
#GET SEQUENCES FOR ASRG PHYLOGENIES#
####################################
arsM <- data.90 %>%
  subset(Gene == "arsM") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)

aioA <- data.90 %>%
  subset(Gene == "aioA") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)
arrA <- data.90 %>%
  subset(Gene == "arrA") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)

arxA <- data.90 %>%
  subset(Gene == "arxA") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)


arsC_thio <- data.90 %>%
  subset(Gene == "arsC_thio") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>% 
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)

arsC_glut <- data.90 %>%
  subset(Gene == "arsC_glut") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)

arsB <- data.90 %>%
  subset(Gene == "arsB") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)

acr3 <- data.90 %>%
  subset(Gene == "acr3") %>%
  unite(col = target, c(t.name, NCBI.ID), sep = " from ") %>%
  mutate(target = paste(">", target, sep = "")) %>%
  select(target)

#save all genes as individual files
write.table(aioA, file = paste(wd, "/output/aioA.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(arrA, file = paste(wd, "/output/arrA.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(arxA, file = paste(wd, "/output/arxA.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(arsM, file = paste(wd, "/output/arsM.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(acr3, file = paste(wd, "/output/acr3.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(arsB, file = paste(wd, "/output/arsB.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(arsC_thio, file = paste(wd, "/output/arsC_thio.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)

write.table(arsC_glut, file = paste(wd, "/output/arsC_glut.target.txt", sep = ""), row.names = FALSE, quote = FALSE, col.names = FALSE)


