#!/bin/bash

#you have to type the gene
GENE=$1
CLUST=$2

#merge coverage.txt files
cat *45_coverage.txt > final_coverage.txt

##CLUSTERING

#get all coverage files
#copy all files to database
/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/OTUabundances/bin/./get_OTUabundance.sh final_coverage.txt /mnt/research/ShadeLa
b/WorkingSpace/Yeh/xander/OTUabundances/${GENE} 0 ${CLUST} alignment/*

#rename rformat of interest
mv rformat_dist_${CLUST}.txt ${GENE}_rformat_dist_${CLUST}.txt

#get and rename sequences
java -Xmx2g -jar /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Clustering.jar rep-seqs -c --id-mapping ids -
-one-rep-per-otu complete.clust ${CLUST} derep.fa

#rename complete.clust_rep_seqs.fasta to match distance
mv complete.clust_rep_seqs.fasta complete.clust_rep_seqs_${CLUST}.fasta

#rename files based on OTU, not cluster for specified distance
sed -i 's/[0-9]\{1,\}/0000000&/g;s/0*\([0-9]\{4,\}\)/\1/g' complete.clust_rep_seqs_${CLUST}.fasta
sed -i 's/cluster_/OTU_/g' complete.clust_rep_seqs_${CLUST}.fasta

#unalign sequences
java -Xmx2g -jar /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Clustering.jar to-unaligned-fasta complete.cl
ust_rep_seqs_${CLUST}.fasta > complete.clust_rep_seqs_${CLUST}_unaligned_short.fasta

#add seed data to sequence file
#Note: first would need to uploade sequences to HPCC
cat complete.clust_rep_seqs_${CLUST}_unaligned_short.fasta reference_seqs.fa > complete.clust_full_rep_seqs_${CLUST}_unaligned_seed
s_short.fasta

#make tree for visualization:
#align file with all sequences
module load HMMER/3.1b2
hmmalign --amino --outformat SELEX -o ${GENE}_alignment_${CLUST}_short.selex /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/ana
lysis/RDPTools/Xander_assembler/gene_resource/${GENE}/originaldata/${GENE}.hmm complete.clust_full_rep_seqs_${CLUST}_unaligned_seed
s_short.fasta

#convert alignment from selex format to aligned fasta (xmfa)
module load Bioperl/1.6.923
/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/OTUabundances/bin/./convertAlignment.pl -i ${GENE}_alignment_${CLUST}_short.sele
x -o ${GENE}_alignment_${CLUST}_short.fa -f xmfa -g selex

#remove last line of aligned seqs (= sign)
dd if=/dev/null of=${GENE}_alignment_${CLUST}_short.fa bs=1 seek=$(echo $(stat --format=%s ${GENE}_alignment_${CLUST}_short.fa ) -
$( tail -n1 ${GENE}_alignment_${CLUST}_short.fa | wc -c) | bc )

#make two separate trees
module load GNU/4.4.5
module load FastTree/2.1.7
FastTree ${GENE}_alignment_${CLUST}_short.fa > ${GENE}_${CLUST}_tree_short.nwk

#extract labels from fasta file
grep "^>" ${GENE}_alignment_${CLUST}_short.fa > ${GENE}_alignment_${CLUST}_labels_short.txt

#edit file name for iTOL
sed 's/^........../,/' ${GENE}_alignment_${CLUST}_labels_short.txt > ${GENE}_${CLUST}_labels_short.txt
sed 's/, /,/' ${GENE}_${CLUST}_labels_short.txt > ${GENE}_${CLUST}_labels_short.n.txt

#add numbers to each line (seq_name)
nl -w 1 -s "" ${GENE}_${CLUST}_labels_short.n.txt > ${GENE}_${CLUST}_labels_short.txt

#delete unnecessary files
rm rformat_dist_*
rm ${GENE}_${CLUST}_labels_short.n.txt
#rm *_${GENE}_45_coverage.txt
