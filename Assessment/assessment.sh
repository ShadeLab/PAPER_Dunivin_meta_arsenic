#!/bin/bash

#you have to type the gene and sample names after calling this script, for example "$./testAutomation.sh arsB cen10"
#$1 means the first argument (arsB in the example, so the variable GENE would be arsB), $2 is site name
GENE=$1
SAMPLE=$2

#load blast
module load GNU/4.4.5
module load Gblastn/2.28

#switch into correct directory
cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${SAMPLE}/k45/${GENE}/cluster

#make database from diverse gene sequences
makeblastdb -in /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Xander_assembler/gene_resource/${GENE}/origina
ldata/nucl.fa  -dbtype nucl -out ${SAMPLE}_${GENE}_database

#blast xander results against db
#tabular format, show seq id, query id (and description), e-value, only show 1 match
blastn -db ${SAMPLE}_${GENE}_database -query /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${SAMPLE}/k45/${GENE}/cluster/*_final_n
ucl.fasta -out blast.txt -outfmt "6 qseqid salltitles evalue" -max_target_seqs 1

#make a list of reads from *match_reads.fa
grep "^>" /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${SAMPLE}/k45/${GENE}/cluster/*match_reads.fa | sed '0~1s/^.\{1\}//g' > ma
tchreadlist.txt

##Extract info for stats calculations in R
#take the framebot stats
grep "STATS" /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${SAMPLE}/k45/${GENE}/cluster/*_framebot.txt > framebotstats.txt

#load R
module load GNU/4.9
module load OpenMPI/1.10.0
module load R/3.3.0

#R script should read in files from the cluster and create 4 new files
R < /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/assembly_assessmentR.R --no-save

#create folder databases_${GENE}
cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment
mkdir databases_${GENE}
cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${SAMPLE}/k45/${GENE}/cluster

#move 8 files to databases_${GENE}
mv ${SAMPLE}_${GENE}_database* /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv blast.txt ${SAMPLE}_${GENE}_blast.txt
mv ${SAMPLE}_${GENE}_blast.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv matchreadlist.txt ${SAMPLE}_${GENE}_matchreadlist.txt
mv ${SAMPLE}_${GENE}_matchreadlist.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv framebotstats.txt ${SAMPLE}_${GENE}_framebotstats.txt
mv ${SAMPLE}_${GENE}_framebotstats.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv readssummary.txt ${SAMPLE}_${GENE}_readssummary.txt
mv ${SAMPLE}_${GENE}_readssummary.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv kmerabundancedist.png ${SAMPLE}_${GENE}_kmerabundancedist.png
mv ${SAMPLE}_${GENE}_kmerabundancedist.png /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv stats.txt ${SAMPLE}_${GENE}_stats.txt
mv ${SAMPLE}_${GENE}_stats.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

mv e.values.txt ${SAMPLE}_${GENE}_e.values.txt
mv ${SAMPLE}_${GENE}_e.values.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}

#GET GC COUNT OF THIS SAMPLE!

cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/

#load perl
module load GNU/4.9
module load perl/5.24.1
#get GC count and put output into ${GENE}_gc folder
./get_gc_counts.pl /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${SAMPLE}/k45/${GENE}/cluster/*_final_nucl.fasta

mv gc_out.txt ${SAMPLE}_${GENE}_gc_out.txt
mv ${SAMPLE}_${GENE}_gc_out.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/${GENE}_gc
