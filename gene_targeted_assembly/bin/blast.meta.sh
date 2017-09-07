#!/bin/bash

#you have to type the gene and project
GENE=$1
BASEDIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly
RESULTDIR=/mnt/research/ShadeLab/WorkingSpace/Yeh/xander

#change to working directory
cd ${BASEDIR}/meta_arsenic/ncbi_blast
mkdir ${GENE}
cd ${GENE}

#copy all files to database
for i in Brazilian_forest39.3 California_grassland61.3 Illinois_soil88.3 Iowa_agricultural00.3 Iowa_prairie72.3 Mangrove70.3 Permafrost_Canada45.3  Wyoming_soil22.3 Brazilian_forest54.3 California_grassland62.3 Illinois_soil91.3 Iowa_agricultural01.3 Iowa_prairie75.3 Minnesota_creek45.3 Permafrost_Russia12.3 Brazilian_forest95.3 Disney_preserve18.3 Illinois_soybean40.3 Iowa_corn22.3 Iowa_prairie76.3 Minnesota_creek46.3 Permafrost_Russia13.3 California_grassland15.3 Disney_preserve25.3 Illinois_soybean42.3 Iowa_corn23.3 Mangrove02.3 Permafrost_Canada23.3 Wyoming_soil20.3 ; do scp ${RESULTDIR}/${i}/k45/${GENE}/cluster/*_${GENE}_45_final_prot.fasta ${BASEDIR}/meta_arsenic/ncbi_blast/${GENE}/${i}_${GENE}_45_final_prot.fasta ; done

#concatenate all fasta files
cd ${BASEDIR}/meta_arsenic/ncbi_blast/${GENE}
cat *${GENE}_45_final_prot.fasta > final_prot.fasta

#blast nr database!
module load GNU/4.9
module load BLAST+/2.6 
export BLASTDB=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly/blast_databases/ncbi:$BLASTDB
#blastp -db nr -query final_prot.fasta -out blast.txt -outfmt "6 qseqid stitle sacc evalue score length pident" -num_threads 12 -max_target_seqs 1
#blastp -db nr -query final_prot.fasta -out gene.descriptor.txt -outfmt "6 stitle" -num_threads 12 -max_target_seqs 1 
blastp -db nr -query final_prot.fasta -out accno.txt -outfmt "6 sacc" -max_target_seqs 1 -num_threads 12

#count occurrences of gene descriptions
#sort gene.descriptor.txt | uniq -c > gene.descriptor.final.txt

#get and count occurrences of accession numbers
sort accno.txt | uniq > accno.u.txt

filename='accno.u.txt'
echo Start
while read p; do 
   curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=$p&rettype=fasta&retmode=text" >$p.result
done <$filename

#convert results into one matchlist fasta file
cat *.result >matchlist.fasta

#remove unnecessary files
rm *final_prot.fasta
rm *.result
rm accno.txt
rm gene.descriptor.txt