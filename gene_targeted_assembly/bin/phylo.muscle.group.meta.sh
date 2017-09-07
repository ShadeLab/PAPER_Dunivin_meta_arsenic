#!/bin/bash

#requirements: gene group name, gene1 (will be used for model), gene 2, gene 3 (optional), cluster cutoff

#you have to type the gene
GROUP=$1
GENE1=$2
GENE2=$3
GENE3=$4
CLUST=$5

#Must adjust to fit your system
PROJECT=meta_arsenic
RESULTDIR=/mnt/research/ShadeLab/WorkingSpace/Yeh/OTUabundances
BASEDIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly

#change to working directory
cd ${BASEDIR}/${PROJECT}/OTUabundances

#make directory for group
mkdir ${GROUP}
cd ${GROUP}

#get all coverage files 
#copy all files to database
cp ${RESULTDIR}/${GENE1}/complete.clust_rep_seqs_${CLUST}_unaligned.fasta ${GENE1}_complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta
cp ${RESULTDIR}/${GENE2}/complete.clust_rep_seqs_${CLUST}_unaligned.fasta ${GENE2}_complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta
cp ${RESULTDIR}/${GENE3}/complete.clust_rep_seqs_${CLUST}_unaligned.fasta ${GENE3}_complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta

#change OTU to gene name
sed -i 's/OTU_/'"$GENE1"'/g' ${GENE1}_complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta
sed -i 's/OTU_/'"$GENE2"'/g' ${GENE2}_complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta
sed -i 's/OTU_/'"$GENE3"'/g' ${GENE3}_complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta

#make reference seqs based on seeds
cat ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE1}/originaldata/${GENE1}.seeds ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE2}/originaldata/${GENE2}.seeds ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE3}/originaldata/${GENE3}.seeds > ${GROUP}.seeds

#add blast matches to reference seqs
cat ${GROUP}.seeds ${BASEDIR}/${PROJECT}/ncbi_blast/${GENE1}/matchlist.fasta ${BASEDIR}/${PROJECT}/ncbi_blast/${GENE2}/matchlist.fasta ${BASEDIR}/${PROJECT}/ncbi_blast/${GENE3}/matchlist.fasta > reference_seqs.fa

#add seed data to sequence file
#Note: first would need to uploade sequences to HPCC
cat *complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta reference_seqs.fa > complete.clust_full_rep_seqs_${CLUST}_unaligned_seeds.fasta

#align sequences
module load MUSCLE/3.8.31
muscle -in complete.clust_full_rep_seqs_${CLUST}_unaligned_seeds.fasta -out ${GROUP}_alignment_muscle_${CLUST}.afa

#make tree
# load RAxML and make maximum likelihood tree
module load GNU/4.9
module load raxml/8.2.10
raxmlHPC-PTHREADS -m PROTGAMMAWAG -p 12345 -f a -k -x 12345 -# 100 -s ${GROUP}_alignment_muscle_${CLUST}.afa -n ${GROUP}_${CLUST}_RAxML_PROTGAMMAWAG.nwk -T 32


#delete unnecessary files
rm ${GROUP}_${CLUST}_labels.n.txt
rm *complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta