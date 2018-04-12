# Analysis of Cen13 metagenomes
### Taylor Dunivin

### Goals
* Check quality and filter Cen13 metagenomic datasets (2 total)
* Test for the presence of AsRGs using Xander (gene targeted metagenome assembler)
* Examine the overlap between gene presence and As resistant isolate collection. 

### Table of contents
* [Quality check/filtering](https://github.com/ShadeLab/Arsenic_Growth_Analysis/blob/master/As_metaG/Analysis_notes.md#quality-check/filtering)


### Quality check/filtering
1. Check the quality of Cen13 fastq files: Do this for both fastqc Cen13_mgDNA_Pooled_CTTGTA_L002_R2_001.fastq.gz and fastqc Cen13_mgDNA_Pooled_CTTGTA_L002_R1_001.fastq.gz
```
#!/bin/bash -login
 
### define resources needed:
### walltime - how long you expect the job to run
#PBS -l walltime=04:00:00
 
### nodes:ppn - how many nodes & cores per node (ppn) that you require
#PBS -l nodes=1:ppn=1
 
### mem: amount of memory that the job will need
#PBS -l mem=100gb
 
### you can give your job a name for easier identification
#PBS -N R1
 
### load necessary modules, e.g.
module load GNU/4.4.5
module load FastQC/0.11.3
 
### change to the working directory where your code is located
cd /mnt/scratch/dunivint/c13
 
### call your executable
fastqc Cen13_mgDNA_Pooled_CTTGTA_L002_R2_001.fastq.gz
```

Output: 
* [R1](https://github.com/ShadeLab/Arsenic_Growth_Analysis/blob/master/As_metaG/data/Cen13_mgDNA_Pooled_CTTGTA_L002_R1_001_fastqc.html): Quality looks good, but will still trim
* [R2](https://github.com/ShadeLab/Arsenic_Growth_Analysis/blob/master/As_metaG/data/Cen13_mgDNA_Pooled_CTTGTA_L002_R2_001_fastqc.html): Quality is not ideal. Will trim

2. Quality trim data files using fastx
```
#load modules
module load GNU/4.4.5
module load FASTX/0.0.14

#quality filter
fastq_quality_filter -Q33 -q 30 -p 50 -z -i Cen13_mgDNA_Pooled_CTTGTA_L002_R1_001.fastq -o Cen13_mgDNA_Pooled_CTTGTA_L002_R1_001.qc.fastq.gz
fastq_quality_filter -Q33 -q 30 -p 50 -z -i Cen13_mgDNA_Pooled_CTTGTA_L002_R2_001.fastq -o Cen13_mgDNA_Pooled_CTTGTA_L002_R2_001.qc.fastq.gz
```

### Gene targeted assembly
1. Set up environment 
* Note: `MIN_LENGTH` will be changed to `50` instead of `150` for arsC_glut and arsC_thio since these proteins are both less than 150 amino acids
```
#!/bin/bash -login

#### start of configuration

###### Adjust values for these parameters ####
#       SEQFILE, SAMPLE_SHORTNAME
#       WORKDIR, REF_DIR, JAR_DIR, UCHIME, HMMALIGN
#       FILTER_SIZE, MAX_JVM_HEAP, K_SIZE
#       THREADS
#####################

## THIS SECTION MUST BE MODIFIED FOR YOUR FILE SYSTEM. MUST BE ABSOLUTE PATH
## SEQFILE can use wildcards to point to multiple files (fasta, fataq or gz format), as long as there are no spaces in the names
SEQFILE=/mnt/scratch/dunivint/c13/*.qc.fastq.gz
WORKDIR=/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/cen13
REF_DIR=/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Xander_assembler
JAR_DIR=/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools
UCHIME=/mnt/research/rdp/public/thirdParty/uchime-4.2.40/uchime
HMMALIGN=/opt/software/HMMER/3.1b1--GCC-4.4.5/bin/hmmalign

## THIS SECTION NEED TO BE MODIFIED, SAMPLE_SHORTNAME WILL BE THE PREFIX OF CONTIG ID
SAMPLE_SHORTNAME=cen13

## THIS SECTION MUST BE MODIFIED BASED ON THE INPUT DATASETS
## De Bruijn Graph Build Parameters
K_SIZE=45  # kmer size, should be multiple of 3
FILTER_SIZE=40 # memory = 2**FILTER_SIZE, 38 = 32 GB, 37 = 16 GB, 36 = 8 GB, 35 = 4 GB, increase FILTER_SIZE if the bloom filter predicted false positive rate is greater than 1%
MAX_JVM_HEAP=300G # memory for java program, must be larger than the corresponding memory of the FILTER_SIZE
MIN_COUNT=1  # minimum kmer abundance in SEQFILE to be included in the final de Bruijn graph structure

## number of threads to use for find starting kmer step and kmer coverage mapping step
THREADS=8

## Contig Search Parameters
PRUNE=20 # prune the search if the score does not improve after n_nodes (default 20, set to -1 to disable pruning)
PATHS=1 # number of paths to search for each starting kmer, default 1 returns the shortest path
LIMIT_IN_SECS=100 # number of seconds a search allowed for each kmer, recommend 100 secs if PATHS is 1, need to increase if PATHS is large 

## Contig Merge Parameters
MIN_BITS=50  # mimimum assembled contigs bit score
MIN_LENGTH=150  # minimum assembled protein contigs

## Contig Clustering Parameters
DIST_CUTOFF=0.01  # cluster at aa distance 

NAME=k${K_SIZE}

#### end of configuration
```

2. Submit job
* Note: only need to "build" once
* Note: job will change based on gene (Ex: `"arsB"`)
```
#!/bin/bash -login
 
### define resources needed:
### walltime - how long you expect the job to run
#PBS -l walltime=10:00:00
 
### nodes:ppn - how many nodes & cores per node (ppn) that you require
#PBS -l nodes=01:ppn=8
 
### mem: amount of memory that the job will need
#PBS -l mem=350gb
 
### you can give your job a name for easier identification
#PBS -N c13.bloom
 
### load necessary modules, e.g.
 
### change to the working directory where your code is located
cd /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/cen13
 
### call your executable
./run_xander_skel.sh xander_setenv.sh "build find search" "arrA"
```



