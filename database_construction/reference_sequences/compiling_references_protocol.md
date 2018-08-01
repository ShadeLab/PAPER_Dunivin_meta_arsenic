# Compiling gene references working protocol
### Taylor Dunivin
## March 27, 2017
---
## 1. Merge aligned fasta files (for >10,000 seq only)
First need to make separate directory of all seq files 
* Do this for protein sequences only
* Do not need aligned files for Xander (only for tree building pre-analysis)

```
java -jar /mnt/research/rdp/public/RDPTools/AlignmentTools.jar alignment-merger /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/gene/aligned_seqs aligned.prot.fa
```

## 2. Linking protein and nucleotide accession/GI numbers
### Format sequence information (protein)
```
# make new file of accession number only
grep "^>" input.fa | sed '0~1s/^.\{1\}//g'| cut -f1 -d " "  >prot.id.final.txt
```

### 3. Submit job to assign nucleotide information to protein information
Below is the information in the file ```job.names.qsub```

```
#!/bin/bash -login
 
### define resources needed:
### walltime - how long you expect the job to run
#PBS -l walltime=03:00:00
 
### nodes:ppn - how many nodes & cores per node (ppn) that you require
#PBS -l nodes=10:ppn=1
 
### mem: amount of memory that the job will need
#PBS -l mem=5gb
 
### you can give your job a name for easier identification
#PBS -N prot2accession

### change to the working directory where your code is located
cd /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/intI
 
### call your executable
./fetchCDSbyProteinIDs_ver2.py prot.id.final.txt names.fa names.txt
```

To submit the job, ```qsub names.qsub```

### 4. Dereplicate nucleotide sequences
First need to dereplicate based on accession number (otherwise RDP software will not work)
```
#remove duplicate accession numbers
awk '/^>/{f=!d[$1];d[$1]=1}f' input.fa >derepaccno.input.fa
```

Next dereplicate based on sequence
```
java -Xmx2g -jar /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Clustering.jar derep -o derep.nucl.fa derep.all_seqs.ids derep.all_seqs.samples derepaccno.input.fa
```

### 5. Obtain accession numbers for nucleotide sequences in ```derepaccno.fa```
```
# make new file of accession number only
grep "^>" derep.nucl.fa | sed '0~1s/^.\{1\}//g'| cut -f1 -d " "  >derep.nucl.id.txt
```

### 6. Convert nucleotide accession numbers to protein accession numbers
```
module load GNU/4.9
module load R/3.3.0
R

#read in data
nucl=read.delim("derep.nucl.id.txt", header=FALSE)
p2n=read.delim("names.txt", header=FALSE)

# make header information
labels=c("protein.accession", "nucl.accession", "strand", "start", "stop")

# label p2n
colnames(p2n)=labels

#remove version numbers
p2n$nucl.accession=gsub("\\.[0-2]$","",p2n$nucl.accession)

# extract protein accno information from nucl accno
derep.protbynucl.id=p2n[which(p2n$nucl.accession %in% nucl),]

# write protein accno id file
write(derep.protbynucl.id, file="derep.protbynucl.id.txt", col.names=F, row.names=F)
```

### 7. Remove sequences in protein fasta based on derep nucleotide sequences
Here i will use the filterbyname.sh funciton in bbmap
```
module load BBMap/35.34
filterbyname.sh in=input.fa out=prot.filtered.fa names=derep.protbynucl.id.txt
```

### 8. Remove sequences in aligned protein fasta based on derep nucleotide sequences
```
module load BBMap/35.34
filterbyname.sh in=aligned.prot.fa out=aligned.prot.filtered.fa names=derep.protbynucl.id.txt
```

---
### Taylor Dunivin
## April 5, 2017
---
Short script to merge unaligned protein and nucleotide sequences
Includes dereplication for nucleotide sequences _only_. 
```
#merge sequence files (FunGene can only download 10k at a time)
#do NOT do this for aligned sequences
#this step also makes sure files are named the same (regardless of gene) for automation
cat *unaligned_nucleotide_seqs_v1.fa >merged_unaligned_nucleotide_seqs_v1.fa
cat *unaligned_protein_seqs_v1.fa>framebot.fa

#remove duplicate accession numbers
awk '/^>/{f=!d[$1];d[$1]=1}f' merged_unaligned_nucleotide_seqs_v1.fa >derepaccno.input.fa

#dereplicate nucleotide sequences
java -Xmx2g -jar /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Clustering.jar derep -o nucl.fa derep.all_seqs.ids derep.all_seqs.samples derepaccno.input.fa

#Ultimately need to copy files to ~Xander_assembler/gene_resource/GENE/originaldata
```

