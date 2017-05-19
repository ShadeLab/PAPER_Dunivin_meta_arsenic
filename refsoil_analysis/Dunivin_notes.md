# Estimating AsRG abundance in RefSoil genomes
### Taylor Dunivin

## May 18, 2017
* Downloaded the 922 genomes used for RefSoil database 
    * Choi, J. et al. Strategies to improve reference databases for soil microbiomes. 11, 829–834 (2016).
    * Download from: https://figshare.com/articles/RefSoil_Database/4362812
    * file: bacteria.protein.fa.gz
    
* Used existing HMMs (from pre-xander work) and hmmsearch to find hits in all of these genomes where
    * ```GENE``` = gene used in script
    * ```#``` = E value (actual value where E-5 ~0.00001)
    * ```##``` = E value cutoff abbreviation(I tried E-10 and E-5)
    * I chose to move forward with E-10 since that generally corresponded to a score of >=50
```
hmmsearch -E # -o GENE.refsoil.E-##.full.txt --domtblout GENE.refsoil.E-##.dom.txt --tblout GENE.refsoil.E-##.txt /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Xander_assembler/gene_resource/GENE/originaldata/GENE.hmm bacteria.protein.fa
```
    * outputs:
      * GENE.refsoil.E-##.full.txt: full hmmsearch output
      * GENE.refsoil.E-##.dom.txt: tabular format including e values and alignment lengths (for downstream analysis)
      * GENE.refsoil.E-##.txt: tabular format including e values 
      
Need to make r compatible file by removing all lines that start with ```#```
```
sed '/#/d' ./GENE.refsoil.E-##.dom.txt > GENE.r.txt
```
      
* Read in resulting .dom files into R for further analysis
    * Supplementary table 1 was used to add taxanomic information to genome hits
    * Also made file with model lengths for all 7 AsRG of interest
    
* Results
    * Broad strokes, the data here is similar to what we see in IMG
    * Likely this is because the database is still biased towards Firmicutes and Proteobacteria, which consistently show AsRG
    * Still see high arsC_glut counts, however, many orgs might have more than one copy per genome
    * Will need to perform future data analysis to account for copies per genome
    
## May 19, 2017
* Adjusted R script to include gene presence/absence in genomes (logical rather than absolute). 
* I would like to additionally go through alignments and check which % alignment lengths are most appropriate
      * I used 70% here since that is what JGI uses
      * This is likely too relaxed
      * Perhaps something more like 90% would be better for this analysis

