After downloading and filtering metagenomes, I performed assembly assessment and assessment by gene. 

#### [Assembly Assessment](https://github.com/ShadeLab/meta_arsenic/blob/master/Assessment/assessment.sh):
* Script title: `assessment.sh`
* To execute: `./asssessment.sh GENE SAMPLE`
* Stored in: `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment`
* Creates folder `databases_GENE` and puts  files into that folder, including 4 R files (`GENE_readssummary.txt`, `GENE_kmerabundancedist.png`, `GENE_stats.txt`, and `GENE_e.values.txt`)
* Finds GC content of `SAMPLE_GENE_45_final_nucl.fasta`, the output will be in `GENE_gc` directory
* Uses [`assembly_assessmentsR.R`](https://github.com/ShadeLab/meta_arsenic/blob/master/Assessment/assembly_assessmentR.R) by T. Dunivin
   * Relevant outputs: `GENE_readssummary.txt`, `GENE_kmerabundancedist.png`, `GENE_stats.txt`, `GENE_e.values.txt`
   * Uses [get_gc_content.pl](https://github.com/ShadeLab/Xander_arsenic/blob/master/assembly_assessments/bin/get_gc_content.pl)
   
#### [Assessment by Gene](https://github.com/ShadeLab/meta_arsenic/blob/master/Assessment/blast.summary.sh):
* Script title: `blast.summary.sh`
* To execute: `./blast.summary.sh GENE`
* Outputs the counts of occurences of gene descriptors 
* The output of all the files from TD's centralia data is in `mnt/research/ShadeLab/WorkingSpace/Yeh/centralia_descriptors`
