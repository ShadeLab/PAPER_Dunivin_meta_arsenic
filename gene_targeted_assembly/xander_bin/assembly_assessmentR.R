# load required packages
library(ggplot2)
library(dplyr)

# COUNT NUMBER OF READ MATCHES
# load packages
library(dplyr)

# KMER ABUND DISTRIBUTION
# read in kmer abund file
kmer=read.table(list.files(pattern = "_abundance.txt"), header=TRUE)

# plot dist
plot=ggplot(kmer, aes(x=kmer_abundance, y=frequency)) + geom_point() + labs(x="kmer abundance", y="Frequency")

# save plot, change filename to include gene name, move to home
ggsave("kmerabundancedist2.png", plot=last_plot(), width=4, height=4)

# NUCL STATS 
# read in stats on length
stats=read.table("framebotstats.txt", header=FALSE)

# calculate statistics
results=summarise(stats, ProteinContigClusters.99=length(stats$V4),AverageLength=mean(stats$V4),MedianLength=median(stats$V4), MinLength.aa=min(stats$V4), MaxLength.aa=max(stats$V4), MaxPercentIdentity=max(stats$V6), MinPercentIdentity=min(stats$V6), AveragePercentIdentity=mean(stats$V6))

# save results, move to home 
write.table(results, "stats2.txt", row.names=FALSE)

# BLAST STATS
# read in blast results from above
blast=read.delim("blast.txt", header=FALSE)

# write column names based on blast search
colnames(blast)=c("contig", "match", "eval")

# calculate number of low quality sequences along with
# the min, max, mean, and median e values
evalues=summarize(blast, lowq=length(blast[,which(blast$eval>1e-2)]), min=min(blast$eval), max=max(blast$eval), avg=mean(blast$eval), median=median(blast$eval))

# save results, move to home
write.table(evalues, "e.values2.txt", row.names=FALSE)