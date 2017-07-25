After downloading and filtering metagenomes, I performed assembly assessment and assessment by gene. 

#### [Assembly Assessment](https://github.com/ShadeLab/meta_arsenic/blob/master/Assessment/assessment.sh):
* Script title: `assessment.sh`
* To execute: `./asssessment.sh GENE SAMPLE`
* Location: `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment`
* Creates folder `databases_GENE` and puts  files into that folder, including 4 R files (`GENE_readssummary.txt`, `GENE_kmerabundancedist.png`, `GENE_stats.txt`, and `GENE_e.values.txt`)
* Finds GC content of `SAMPLE_GENE_45_final_nucl.fasta`, the output will be in `GENE_gc` directory
* Uses [`assembly_assessmentsR.R`](https://github.com/ShadeLab/meta_arsenic/blob/master/Assessment/assembly_assessmentR.R) by T. Dunivin
   * Relevant outputs: `GENE_readssummary.txt`, `GENE_kmerabundancedist.png`, `GENE_stats.txt`, `GENE_e.values.txt`
   * Uses [get_gc_content.pl](https://github.com/ShadeLab/Xander_arsenic/blob/master/assembly_assessments/bin/get_gc_content.pl)
   
#### [Assessment by Gene](https://github.com/ShadeLab/meta_arsenic/blob/master/Assessment/blast.summary.sh): Blast against non redundant database
* [Written by T. Dunivin](https://github.com/ShadeLab/Xander_arsenic/blob/master/assembly_assessments/bin/blast.summary.pl) to test genes against non redundant database
* Script title: `blast.summary.sh`
* Start from correct directory, `cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}`
* To execute: `.././blast.summary.sh GENE`
* Located: `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment`
* Pre script activities: 
  * Copy all *final_prot.fasta* files from the clusters to the `databases_${GENE}` folders, for example:
  * `GENE=arsB; for i in California_grassland15.3 California_grassland62.3 Permafrost_Canada23.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*final_prot.fasta /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/databases_${GENE}; done`
* Relevent outputs: 
  * `ncbi.input.txt`: contains protein accession numbers which can be used to gather sequences for phylogenetic analysis
  * `gene.descriptor.final.txt`: Contains unique gene descriptor hits; look to see how often a specific hit shows up/ if the results look gene-specific
* The output of all the files from TD's centralia data is in `mnt/research/ShadeLab/WorkingSpace/Yeh/centralia_descriptors`
