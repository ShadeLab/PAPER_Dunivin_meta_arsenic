#!/bin/bash

#you have to type the gene name
GENE=$1

cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

#blast against nr database
module load BLAST/2.2.26
export BLASTDB=/mnt/research/common-data/Bio/blastdb:$BLASTDB
cat *_final_prot.fasta > final_prot.fasta
blastall -d nr -i final_prot.fasta -p blastp -o blast.txt -b 1 -v 1 -e 1e-6 -a 8
grep '^>' blast.txt > descriptor.blast.txt

#get and count occurences of gene descriptions
cat descriptor.blast.txt | awk -F '[|]' '{print $3}' > gene.descriptor.txt
sort gene.descriptor.txt | uniq -c > ${GENE}.descriptor.final.txt

#get and count occurrences of accession numbers
# awk finds and replaces text and the -F flag is for delimiters (delimeter is `|`)
# The '{print $2}' instructs to print the second column
# uniq -c creates a file of the lines with counts

cat descriptor.blast.txt | awk -F '[|]' '{print $2}' > accno.txt
sort accno.txt | uniq -c > ${GENE}.accno.final.txt

#this file contains protein accession numbers which can be used to gather sequences for phylogenetic analysis
cat ${GENE}.accno.final.txt | awk '{print $2}' > ${GENE}.ncbi.input.txt

#remove unnecessary files
rm gene.descriptor.txt
rm accno.txt
rm *_45_final_prot.fasta
