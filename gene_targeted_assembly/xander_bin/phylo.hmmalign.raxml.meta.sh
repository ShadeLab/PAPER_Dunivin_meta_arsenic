#!/bin/bash

#you have to type the gene
GENE=$1
CLUST=$2

#must adjust based on your system
PROJECT=meta_arsenic
RESULTDIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly/meta_arsenic/results
BASEDIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly

#change to working directory
cd ${BASEDIR}/${PROJECT}/OTUabundances
mkdir ${GENE}
cd ${GENE}

#make alignment directory
mkdir alignment

#copy all aligned protein files 
#must adjust for your project
for i in Brazilian_forest39.3 California_grassland61.3 Illinois_soil88.3 Iowa_agricultural00.3 Iowa_prairie72.3 Mangrove70.3 Permafrost_Canada45.3  Wyoming_soil22.3 Brazilian_forest54.3 California_grassland62.3 Illinois_soil91.3 Iowa_agricultural01.3 Iowa_prairie75.3 Minnesota_creek45.3 Permafrost_Russia12.3 Brazilian_forest95.3 Disney_preserve18.3 Illinois_soybean40.3 Iowa_corn22.3 Iowa_prairie76.3  Minnesota_creek46.3 Permafrost_Russia13.3 California_grassland15.3 Disney_preserve25.3 Illinois_soybean42.3  Iowa_corn23.3 Mangrove02.3 Permafrost_Canada23.3 Wyoming_soil20.3 ; do scp ${RESULTDIR}/${i}/k45/${GENE}/cluster/*_${GENE}_45_final_prot_aligned.fasta ${BASEDIR}/${PROJECT}/OTUabundances/${GENE}/alignment/${i}.fasta; done

#get all coverage files 
#copy all files to database
#must adjust for your project
for i in Brazilian_forest39.3 California_grassland61.3 Illinois_soil88.3 Iowa_agricultural00.3 Iowa_prairie72.3 Mangrove70.3 Permafrost_Canada45.3  Wyoming_soil22.3 Brazilian_forest54.3 California_grassland62.3 Illinois_soil91.3 Iowa_agricultural01.3 Iowa_prairie75.3 Minnesota_creek45.3 Permafrost_Russia12.3 Brazilian_forest95.3 Disney_preserve18.3 Illinois_soybean40.3 Iowa_corn22.3 Iowa_prairie76.3  Minnesota_creek46.3 Permafrost_Russia13.3 California_grassland15.3 Disney_preserve25.3 Illinois_soybean42.3  Iowa_corn23.3 Mangrove02.3 Permafrost_Canada23.3 Wyoming_soil20.3 ; do scp ${RESULTDIR}/${i}/k45/${GENE}/cluster/*_${GENE}_45_coverage.txt ${i}_${GENE}_45_coverage.txt; done

#merge coverage.txt files
cat *45_coverage.txt > final_coverage.txt

##CLUSTERING
#written by RDP
${BASEDIR}/bin/get_OTUabundance.sh final_coverage.txt ${BASEDIR}/${PROJECT}/OTUabundances/${GENE} 0 ${CLUST} alignment/*

#rename rformat of interest
mv rformat_dist_${CLUST}.txt ${GENE}_rformat_dist_${CLUST}.txt

#get and rename sequences
java -Xmx2g -jar ${BASEDIR}/RDPTools/Clustering.jar rep-seqs -c --id-mapping ids --one-rep-per-otu complete.clust ${CLUST} derep.fa

#rename complete.clust_rep_seqs.fasta to match distance
mv complete.clust_rep_seqs.fasta complete.clust_rep_seqs_${CLUST}.fasta 

##get files for gc counting/otu labels
#grab fasta headers since they contain otu and contig information for that clust
grep "^>" complete.clust_rep_seqs_${CLUST}.fasta > ${BASEDIR}/${PROJECT}/OTUabundances/otu_information/${GENE}_${CLUST}_otu_contig.txt

#rename files based on OTU, not cluster for specified distance (in case you want a tree for phyloseq later)
sed -i 's/[0-9]\{1,\}/0000000&/g;s/0*\([0-9]\{4,\}\)/\1/g' complete.clust_rep_seqs_${CLUST}.fasta
sed -i 's/cluster_/OTU_/g' complete.clust_rep_seqs_${CLUST}.fasta 

#make an OTU-only tree (for ecological comparisons in R)
module load GNU/4.4.5
module load FastTree/2.1.7
FastTree complete.clust_rep_seqs_${CLUST}.fasta > ${GENE}_${CLUST}_FastTree.nwk

#unalign sequences so that we can add seed sequences, etc
java -Xmx2g -jar ${BASEDIR}/RDPTools/Clustering.jar to-unaligned-fasta complete.clust_rep_seqs_${CLUST}.fasta > complete.clust_rep_seqs_${CLUST}_unaligned.fasta

#make file of reference sequences
cat ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE}/originaldata/${GENE}.seeds ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE}/originaldata/root.${GENE} ${BASEDIR}/${PROJECT}/ncbi_blast/${GENE}/matchlist.fasta > reference_seqs.fa

#add seed data to sequence file
cat complete.clust_rep_seqs_${CLUST}_unaligned.fasta reference_seqs.fa > complete.clust_full_rep_seqs_${CLUST}_unaligned_seeds.fasta

##make tree for phylogenetic analysis:
#align file with all sequences
module load HMMER/3.1b2
hmmalign --amino --outformat SELEX -o ${GENE}_alignment_${CLUST}.selex ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE}/originaldata/${GENE}.hmm complete.clust_full_rep_seqs_${CLUST}_unaligned_seeds.fasta

#convert alignment from aligned fasta (xmfa) format to phylip
module load Bioperl/1.6.923
${BASEDIR}/bin/convertAlignment.pl -i ${GENE}_alignment_${CLUST}.selex -o ${GENE}_alignment_${CLUST}.phy -f phylip -g selex

# load RAxML and make maximum likelihood tree
module load GNU/4.9
module load raxml/8.2.10
raxmlHPC-PTHREADS -m PROTGAMMAWAG -p 12345 -f a -k -x 12345 -# 100 -s ${GENE}_alignment_${CLUST}.phy -n ${GENE}_${CLUST}_RAxML_PROTGAMMAWAG.nwk -T 32

#remove unnecessary files
rm rformat_dist_*
rm *_${GENE}_45_coverage.txt
rm derep.fa
rm -r alignment
rm ids
rm samples
rm complete.clust_rep_seqs_${CLUST}.fasta
rm complete.clust
rm final_coverage.txt
rm ${GENE}_alignment_${CLUST}.selex
rm ${GENE}_alignment_${CLUST}.phy