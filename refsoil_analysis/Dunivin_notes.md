# Estimating AsRG abundance in RefSoil genomes
### Taylor Dunivin

### Table of Contents ###
* [May 18, 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/refsoil_analysis/Dunivin_notes.md#may-18-2017)
* [May 19, 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/refsoil_analysis/Dunivin_notes.md#may-19-2017)

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
* Adjusted script to set minimum score to 50 (what Xander does) and make sure that the target lenght is not more than 40% different from the query (1.4<->0.6%)
   * This reduced the number of results, but not by too much
* Adjusted script to deal with duplicate calls
   * Several targets hit to two genes (aioA/arrA)
   * This is not unexpected since these proteins are quite similar
   * In looking at all cases (4 with 70% cutoff), there was a clear "true" match based on the score
   * Ordered name by score and removed duplicates
   
* What initial Phylum-level patterns do we see with a stringent dataset? 
   * parameters: 90% alignment length; >50 score; within 40% of target length
   * for now, I will focus on relative presence/absence within genome when there are multiple representatives
      * This excludes: Deferribacteres, Fusobacteria, Gemmatimonadetes, Planctomycetes, Terrabacteria_group, Synergistetes
      * __Acidobacteria__: Favor arsC_thio and acr3, although many (~75%) have arsB as well. A small portion test positive for arsM. No other arsenic resistance capabilities are seen.
      * __Actinobacteria__: Do not have preferences for arsC_thio/arsC_glut or arsB/acr3. Roughly 50% have one of each type. Less than 5% have arsM, and less than 10% have no AsRG screened. 
      * __Aquificae__: 100% have arsB and arsC_thio. No other tested resistance mechanisms are seen. 
      * __Armatimonadetes__: 50% have arsM, another 50% have arsC_thio, and 50% have acr3. Likely those with arsC_thio also have acr3. 
      * __Bacteroidetes__: 20% have arsM, 75% have acr3, 75% have arsC_glut, ~30% have arsC_thio, and less than 5% have none. It looks like acr3 is favored over arsB and arsC_glut is favored over arsC_thio. Possibly arsC_thio relates to arsM?
      * __Chlamydiae__:  No AsRG found.
      * __Chloroflexi__: Nearly 100% test positive for arsM, arsB, acr3, and arsC_thio. Chloroflexi here therefore favor arsC_thio over arsC_glut. And also favor arsenite methylation.
      * __Crenarchaeota__: No AsRG found.
      * __Cyanobacteria__: Show a mix of arsB/acr3 and arsC_glut/arsC_thio. Favors reduction and efflux over methylation (less than 5%). Fewer than 5% show now resistance.
      * __Deinococcus–Thermus__: About 75% test postivie for arsB; 75% for arsC_thio; 25% for no AsRG tested. DT therefore favors arsB over acr3 and arsC_thio over arsC_glut. Methylation is not favored either. 
      * __Euryarchaeota__:  No AsRG found.
      * __Firmicutes__: 75% test positive for arsB; ~70% test positive for arsC_glut and arsC_thio; and 50% test positive for acr3. Firmicutes, thus, favor reduction and efflux over methylation but do not prefer glut/thio, arsB/acr3. Roughly 5% have no AsRG. Some (less than 5%) test positive for arrA
      * __Nitrospirae__: ~30% have arsM, 100% have arsB, 75% have arsC_thio. Favors arsB over acr3, and arsC_thio over arsC_glut. 
      * __Proteobacteria__: ~30% have arsB and ~30% acr3. Roughly 90% have arsC_glut, while ~30% have arsC_thio. About 5% have no AsRG and even fewer test positive for arsM. Proteobacteria generally favor arsC_glut and favor reduction and efflux over methylation. A small portion have arrA and aioA (the only phylum to have hits to aioA). 
      * __Spirochaetes__: No arsM, less than 5% arsB, ~20% acr3, 30% have none; 30% arsC_glut; 25% arsC_thio. 
      * __Tenericutes__: more than 50% have no AsRG. Remaining have arsC_glut and arsB. This phylum therefore favors glut over thio and arsB over acr3.
      * __Thermotogae__: 100% test positive for arsB and under 50% have arsC_thio. Prefers arsB over acr3; prefers arsC_thio over arsC_glut. Perhaps there is evidence that this phylum mostly encounters arsenite??
      * __Verrucomicrobia__: 100% have arsC_thio, arsC_glut, and arsM. 50% have arsB while 100% have acr3. This is a very As resistant phylum according to this sample size. 

* Not many phyla test positive for aioA or arrA. Is this expected?
   * Andres, J. & Bertin, P. N. The microbial genomics of arsenic. FEMS Microbiol. Rev. 40, 299–322 (2016).
   * The above paper reports the following for these genes
   
   | Phylum | Gene | Known representatives (#) | Phylum in RefSoil? | RefSoil hits | Acceptable? |
   | ------ | ---- | ----------------------- | -------------- | -------- | ------ |
   | Deinococcus–Thermus | aioA | 3 | 1 | no | yes |
   | Proteobacteria | aioA | 34 | 458 | 12 | yes |
   | Crenarcheota | aioA | 7 | 9 | none | yes:model for bact |
   | Chlorobi | aioA | 2 | 3 | none | yes |
   | Chloroflexi | aioA | 2 | 9 | none | yes |
   | Aquificae | aioA | 2 | 3 | none | yes |
   | Firmicutes | arrA | 11 | 206 | 4 | yes |
   | Deferribacteres | arrA | 2 | 1 | 1 | yes |
   | Chrysiogenetes | arrA | 2 | no | NA | NA |

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
