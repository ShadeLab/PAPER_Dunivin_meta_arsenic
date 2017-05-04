# Meta-analysis review notes
## Taylor Dunivin
File contains notes on relevant publications for the analysis, broad decisions on data inclusion, hypotheses for report, and some preliminary analysis information. 

## Table of contents
* [April 28, 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Dunivin_notes.md#april-28-2017)
* [May 2, 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Dunivin_notes.md#may-2-2017)
* [May 3, 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Dunivin_notes.md#may-3-2017)
* [May 4, 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Dunivin_notes.md#may-4-2017)


## April 28, 2017
* Questions I've been thinking about
  * What are AsRG concentrations across soils? 
  * How does diversity of AsRGs change between soils? Can this be mostly predicted/ explained by community membership?
    * **Hyp: AsRG diversity in soil can largely be explained by community membership (evolutionarily old)**
      * Lebrun, E. et al. Arsenite Oxidase , an Ancient Bioenergetic Enzyme. Mol. Biol. Evol. 20, 686–693 (2003).
      * Jackson, C. R. & Dugas, S. L. Phylogenetic analysis of bacterial and archaeal arsC gene sequences suggests an ancient, common origin for arsenate reductase. BMC Evol. Biol. 3, 18 (2003).
      * van Lis, R., Nitschke, W., Duval, S. & Schoepp-cothenet, B. Arsenic as bioenergetic substrates. Biochim. Biophys. Acta 1827, 176–188 (2013).
    * **Hyp: AsRG abundance (per gene) relates to geography/ metadata (think prochlorococcus paper)**
      * Saunders, J. K. & Rocap, G. Genomic potential for arsenic efflux and methylation varies among global Prochlorococcus populations. ISME J. 10, 197–209 (2016).
      * May need more metadata to answer this question
  * What is the distribution of AsRGs in known genomes? Both in proportion of genomes and proportion of different AsRGs
  * In completed genomes, are some AsRGs represented in particular phyla more than others?
    * In particular I am interested in whether thermophiles are more likely to be arsenic resistant (hyp yes)



## May 2, 2017
* JGI preliminary data
  * wrote .R script to examine COGs related to As resistance in *all* JGI genomes and metagenomes
  * meta COG results
    * Glutaredoxin arsenate reductase COGs are overrepresented in isolate genomes
     * Found in ~86% of isolate genomes 
       * not exact since there can be multiple copies in one genome
     * Found in ~34.5% of metagenome genome equivalents (norm to scg ribosomal protein S2)
     * Note no COG exists for the gene encoding thioredoxin arsenate reductases 
    * COGs for arsenite efflux pumps (arsB, acr3, arsenite permeases) are under-represented in isolate genomes
     * This actually makes more sense seeing as arsenate reductases are not useful without arsenite efflux potential
    * I am not analyzing arsR extensively here since I do not trust those COGs
  
  * The majority of isolate genomes with arsenite efflux pump COGs have 1. Max is 7.
  
  * Made figure of number of isolates in each available phyla have arsB/acr3
    * Would like to analyze further to see whether this highlights database bias 
    * Would like to see if thermophiles are over represented based on genome availability
    * *considering* doing this for arsC; painful to make taxanomic table (might be another way)
  
  * Script also contains analysis of single copy genes in known genomes from the Tringe paper and microbeCensus
  
## May 3, 2017
* I realized the true percentages of COGs/ genome will be inflated since some genomes have >1 copy
* Today I calculated the true percentages containing arsB/arsC
  * arsB: 30.49%
  * arsC: 75.00%
  
* I also made a histogram of isolate genomes with arsC. Actually many have 2/3
  * Perhaps this is due to the loose struct of this COG? (my hmm is more specific)


## May 4, 2017
* Some of the genomes appear to have been deleted from JGI/ do not have genome ID's. I do not trust these data, so I removed them from the datasets so they do not impact final calculations.
* New percentages for the percent of organisms containing an AsRG are below. 
  * arsA: 19.75%
  * arsB: 30.49%
  * arsC: 73.95%

* It is not intuitive to get taxanomic information for all JGI genomes. See link below for future references
  * home -> IMG Statistics -> Total (bacteria) -> Select a category -> reset -> Genomes Count -> reconfigure table to show phylum:Species
  * https://img.jgi.doe.gov/cgi-bin/m/main.cgi






