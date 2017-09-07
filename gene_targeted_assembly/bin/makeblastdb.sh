#!/bin/bash

#you have to type the gene and sample names after calling this script, for example "$./testAutomation.sh arsB cen10"
#$1 means the first argument (arsB in the example, so the variable GENE would be arsB), $2 is site name
GENE=$1
BASEDIR=$2

#load blast
module load GNU/4.4.5
module load Gblastn/2.28

#switch into correct directory. 
cd ${BASEDIR}/blast_databases
mkdir ${GENE}
cd ${GENE}

#make database from diverse gene sequences
makeblastdb -in ${BASEDIR}/RDPTools/Xander_assembler/gene_resource/${GENE}/originaldata/nucl.fa  -dbtype nucl -out ${GENE}_database