# Written by T Dunivin: https://github.com/ShadeLab/Xander_arsenic/blob/master/assembly_assessments/bin/assembly_assessments.R
# load required packages
library(ggplot2)
library(dplyr)

# COUNT NUMBER OF READ MATCHES
# load packages
library(dplyr)

# read in file
data=read.table("matchreadlist.txt", header=FALSE)

# count unique in query_id column
reads=summarize(data, UniqueReads=length(unique(data$V1)),TotalReads=length(data$V1))

# write results. later the name of the file will be changed to include the gene name
write.table(reads, "readssummary.txt", row.names=FALSE)

# KMER ABUND DISTRIBUTION
# read in kmer abund file
kmer=read.table(list.files(pattern = "_abundance.txt"), header=TRUE)

# plot dist
plot=ggplot(kmer, aes(x=kmer_abundance, y=frequency)) + geom_point() + labs(x="kmer abundance", y="Frequency")

# save plot, change filename to include gene name, move to home
ggsave("kmerabundancedist.png", plot=last_plot(), width=4, height=4)

# NUCL STATS
# read in stats on length
stats=read.table("framebotstats.txt", header=FALSE)

# calculate statistics
results=summarise(stats, ProteinContigClusters.99=length(stats$V4),AverageLength=mean(stats$V4),MedianLength=median(stats$V4), MinL
ength.bp=min(stats$V4), MaxLength.bp=max(stats$V4), MaxPercentIdentity=max(stats$V6), MinPercentIdentity=min(stats$V6), AveragePerc
entIdentity=mean(stats$V6))

# save results
write.table(results, "stats.txt", row.names=FALSE)

# BLAST STATS
# read in blast results from above
blast=read.delim("blast.txt", header=FALSE)

# write column names based on blast search
colnames(blast)=c("contig", "match", "eval")

# calculate number of low quality sequences along with
# the min, max, mean, and median e values
evalues=summarize(blast, lowq=length(blast[,which(blast$eval>1e-2)]), min=min(blast$eval), max=max(blast$eval), avg=mean(blast$eval
), median=median(blast$eval))

# save results
write.table(evalues, "e.values.txt", row.names=FALSE)
