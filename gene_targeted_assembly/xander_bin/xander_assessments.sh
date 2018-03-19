#!/bin/bash

#you have to type the gene, sample name, and project name (ie meta_arsenic)
#manually edit the project and base directory 
GENE=$1
SAMPLE=$2
PROJECT=$3
RESULTDIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly/meta_arsenic/results
BASEDIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly


#load blast
module load GNU/4.4.5
module load Gblastn/2.28

#switch into correct directory.
cd ${BASEDIR}/${PROJECT}/assessments
mkdir ${GENE}
cd ${GENE}

#blast xander results against db
#tabular format, show seq id, query id (and description), e-value, only show 1 match
blastn -db ${BASEDIR}/blast_databases/${GENE}/${GENE}_database -query ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/*_final_nucl.fasta -out ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/blast.txt -outfmt "6 qseqid salltitles evalue" -max_target_seqs 1

##Extract info for stats calculations in R
#take the framebot stats
grep "STATS" ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/*_framebot.txt > ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/framebotstats.txt

# USE R TO CREATE STATISTIC FILES

#start in cluster directory from xander output!
cd ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster

# swap and load the version of R you want to use here with module commands
module load GNU/4.9
module load OpenMPI/1.10.0
module load R/3.3.0
 
# Run R Command with input script myRprogram.R
#R script should read in files from the cluster and create 4 new files
R < ${BASEDIR}/bin/assembly_assessmentR.R --no-save

#GET GC COUNT OF THIS SAMPLE!
cd ${BASEDIR}/${PROJECT}

#load perl
module load GNU/4.4.5
module load perl/5.24.1

#get GC count and put output into ${GENE}_gc folder
${BASEDIR}/bin/get_gc_counts.pl ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/*_${GENE}_45_final_nucl.fasta

#move all final files to results folder
mv ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/framebotstats.txt ${BASEDIR}/${PROJECT}/assessments/${GENE}/${SAMPLE}_${GENE}_framebotstats.txt
mv ${RESULTDIR}/${SAMPLE}/k45/${GENE}/cluster/blast.txt ${BASEDIR}/${PROJECT}/assessments/${GENE}/${SAMPLE}_${GENE}_blast.txt
mv gc_out.txt ${BASEDIR}/${PROJECT}/gc/${SAMPLE}_${GENE}_gc_out.txt