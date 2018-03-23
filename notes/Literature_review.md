# Review of studies on AsRG in metagenomic datasets
### Taylor Dunivin

__Goals:__
* Examine the expected distribution of AsRGs in the environment from existing literature
* Tally the different methods (sequencing, assembly, gene count esitmations, etc)
* Tally which genes are tested (some may be infrequent)

### Table of Contents
* [Summary table](https://docs.google.com/spreadsheets/d/1-QjI7Aun_S2CxAXtMExuNcwu6ipUIYg97lo7WJB23JA/edit#gid=0)
* [Engel et al., 2013](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#engel-et-al-2013)
* [Kurth et al., 2013](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#kurth-et-al-2017)
* [Escudero et al., 2013](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#escudero-et-al-2017)
* [Zeng et al., 2016](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#zeng-et-al-2016)
* [Li et al., 2014](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#li-et-al-2014)
* [Saunders and Rocap 2016](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Saunders-and-Rocap-2016)
* [Plewniak 2013](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Plewniak-2013)
* [Chi 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Chi-2017)
* [Costa 2015](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Costa-2015)
* [Das 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Das-2017)
* [Luo 2014](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Luo-2014)
* [Rascovan 2015](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Rascovan-2015)
* [Bertin 2011](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Bertin-2011)
* [Edwardson and Hollibaugh 2017](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Edwardson-and-Hollibaugh-2017)
* [Sangwan 2015](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#angwan-2015)
* [Oremland review 2005](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Oremland-review-2005)
* [Xiao 2016](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Xiao-2016)
* [Lu 2016](https://github.com/ShadeLab/meta_arsenic/blob/master/Literature_review.md#Lu-2016)


### Engel et al., 2013
* Study aims to compare 16S rRNA gene diversity with _aioA_ diversity in microbial mats from arsenic contaminated gyser effluent in Chile. 
* Site is geothermal with temperatures ranging from 50-83C
* Used evolutionary trace analysis to examine functional protein sites in _aioA_ sequences 
* Results may be biased due to using clone library
* Sampled along a shifting gradient with initially high AsIII gradually shifting towards more AsV
* Samples were dominated by chloroflexi and deinococcus-thermus
* "Proteobacteria capable of arsenite oxidation are probably the most fre- quently detected from natural and contaminated settings (Macur et al., 2004; Cai et al., 2009; Hamamura et al., 2009; Heinrich-Salmeron et al., 2011; Sultana et al., 2012)."

### Kurth et al., 2017
* "The bacteria isolated from these stromatolites are, in fact, extremophiles able to resist severe stress conditions, including UV radiation, heavy metals, salinity and, most interestingly, arsenic. Previous"
* Discusses using microbial stromatolie mat communities from extreme environments as models of _early earth organisms_
* Compared data to other microbial mats from MG-RAST!
  * Compared Phylum-level taxanomic differences between study site and other MG-RAST stromatolite sites
  * Compared function level differences between sites as well
  * Moved forward with site most similar to study site
  * Essentially they find more AsRG in study site than in most similar reference
* Site is impacted by volcanic ash
* Difficult finding arsB; much more acr3
* "The thioredoxin-dependent type is much more diverse in Socompa than the glutaredoxin-linked type, probably because the thioredoxin reducing system is more efficient in arsenate decontamination."
  * We see the opposite in Centralia
  * Possible glut is more common in under-contaminated environments?
* Only used full length proteins for the phylogenetic analysis... _good idea_
* acr3 and arsC_thio were most abundant; low arsC_glut and arsB; intermediate arsM, arrA, aioA
* also find mostly alphaproteobacteria aioA
 
### Escudero et al., 2013
* Examined arsC, acr3, aioA, arrA from a wide variety of sites with wide randing arsenic concentrations
* Found arrA and some form (dif primer pairs) of arsC in every sample 
* Likely biased by PCR methods
* See enterobacter arsC in low arsenic concentrations but firmicutes arsC (thio) in higher arsenic concentrations

### Zeng et al., 2016
* Reglar mine
* Focus on community and aioA (PCR methods)
* aioA is mostly proteobacteria 

### Li et al., 2014
* "However, our knowledge of the distribution, redundancies and organization of these genes in bacteria is still limited."
* "we analyzed the 188 Burkholderiales genomes and found that 95% genomes harbored arsenic-related genes, with an average of 6.6 genes per genome."
* _ars_ related genes were most common
* Do not find a correlation between genome size and number of As resistance genes 
 * Could check this with jgi cogs data
* Nice example of examining AsRG distribution with genomes

### Saunders and Rocap 2016
* Prochlorococcus genomes
* arsR, acr3, arsC, arsM
* See ubiquitous arsM in Prochlorocossus, but only see acr3 in oceans with low phosphate concentrations compared to arsenate 

### Plewniak 2013
* Ocean focus
* COG data

### Chi 2017
* Treat mice with 100 ppb As for 13 weeks
* See _reduction_ in arsC and acr3 post-arsenic exposure (unknown expression levels)

### Costa 2015
* historically metal-contaminated tropical freshwater stream sediment.
* anoxic environmet; see lots of arrA ---> perhaps comparable to mangrove? 

### Das 2017
* arsenic contaminated groundwater
 * 50% arsC
 * 25% arsA
 * 12% acr3
 * 3% arsB, arsD, arsR, arsH
 * did not look for arsM
 
### Luo 2014
* contaminated soil metagenomes
   * As: 34.11 to 821.23 mg kg21
   * Sb: 226.67 to 3923.07 mg kg21
* observe higher diversity and abundance of  arsC, arrA, aioA, arsB and ACR3 in higher As samples
* correlation between arsC and aioA and arsenic

### Rascovan 2015
* "However, among the archaea, bioenergetic arsenic metabolism has only been found in the Crenarchaeota phylum"
* high arsenic and 4589 m above sea level inside a volcano crater in Diamante Lake, Argentina
* find lots of As-resistance genes related to archaea
* "phylogenetic analysis of aioA showed that haloarchaea sequences cluster in a novel and monophyletic group, suggesting that the origin of arsenic metabolism in haloarchaea is ancient"

### Bertin 2011
* AMD ecosystem
* proteomics confirms ars operon including reductase and efflux pump
* arsM also detected
 
### Edwardson and Hollibaugh 2017
* mono lake
* metaTRANSCRIPTOMICS of arrA, aioA and arxA
* micro-aerophilic environment had mostly arxA
* oxic env had minimal AsRG expression
* anoxic bottom mostly arrA

### Sangwan 2015
* Arsenic rich Himalayan hot spring metagenomics
* do detect ars operon (not sure if they tested other genes)

### Oremland review 2005
* argues that metagenomes alone are not enough
* what about clear discrepancies between cultivated genomes and non?

### Xiao 2016
* low arsenic paddy soil metagenomes
* mostly see cytoplasmic reduction but do see some arsM, arrA, and aioA
* see correlations between arsenic resistance genes --> check this with co-occurrence in 16S tree?
* showed pH as an important factor controlling their distribution in paddy soil
  * probably not pH but rather community-driving factors
  * in Cen it changes but is not correlated with pH
  
### Lu 2016
* clone library arrA
* core sediments collected from a region with arsenic-contaminated groundwater in the Jianghan Plain
* see lots of diverse arrA 
