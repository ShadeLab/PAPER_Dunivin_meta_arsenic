#### start of configuration

###### Adjust values for these parameters ####
#       SEQFILE, WORKDIR, REF_DIR, HMMSEARCH
#       AsRG, E_VALUE, THREADS
##############################################

## THIS SECTION MUST BE MODIFIED FOR YOUR FILE SYSTEM. MUST BE ABSOLUTE PATH
SEQDIR=/mnt/research/ShadeLab/WorkingSpace/Dunivin/as_ncbi/refsoil
WORKDIR=/mnt/research/ShadeLab/Dunivin/hmmsearch/refsoil_data
REF_DIR=/mnt/research/ShadeLab/Dunivin/gene_targeted_assembly/RDPTools/Xander_assembler
HMMSEARCH=/opt/software/HMMER/3.1b2--GCC-4.8.3/bin/hmmsearch

## THIS SECTION NEED TO BE MODIFIED BASED ON EXPERIMENTAL QUESTIONS
#Which arsenic resistance genes would you like to search?
AsRG="acr3 aioA arrA arsA arsB arsC_glut arsC_thio arsD arsM arxA"
#what evalue cutoff (for hmmsearch) would you like to use?
evalue=0.0000000001

## THIS SECTION NEEDS TO BE MODIFIED BASED ON RESOURCES
THREADS=1
