## Github Repository for
# A global survey of arsenic-related genes in soil microbiomes
## by Taylor K. Dunivin, Susanna Y. Yeh, Ashley Shade


<i>This work is published.</i>


### Data
The raw data for this study are available in the NCBI SRA under bioproject [PRJNA492298](https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA492298).


### To cite this work or code
Dunivin, T.K., Yeh, S.Y. & Shade, A. A global survey of arsenic-related genes in soil microbiomes. BMC Biol 17, 45 (2019). https://doi.org/10.1186/s12915-019-0661-5


### Abstract
Environmental resistomes include transferable microbial genes. One important resistome component is resistance to arsenic, a ubiquitous and toxic metalloid that can have negative and chronic consequences for human and animal health. The distribution of arsenic resistance and metabolism genes in the environment is not well understood. However, microbial communities and their resistomes mediate key transformations of arsenic that are expected to impact both biogeochemistry and local toxicity.
We examined the phylogenetic diversity, genomic location (chromosome or plasmid), and biogeography of arsenic resistance and metabolism genes in 922 soil genomes and 38 metagenomes. To do so, we developed a bioinformatic toolkit that includes BLAST databases, hidden Markov models and resources for gene-targeted assembly of nine arsenic resistance and metabolism genes: acr3, aioA, arsB, arsC (grx), arsC (trx), arsD, arsM, arrA, and arxA. Though arsenic-related genes were common, they were not universally detected, contradicting the common conjecture that all organisms have them. From major clades of arsenic-related genes, we inferred their potential for horizontal and vertical transfer. Different types and proportions of genes were detected across soils, suggesting microbial community composition will, in part, determine local arsenic toxicity and biogeochemistry. While arsenic-related genes were globally distributed, particular sequence variants were highly endemic (e.g., acr3), suggesting dispersal limitation. The gene encoding arsenic methylase arsM was unexpectedly abundant in soil metagenomes (median 48%), suggesting that it plays a prominent role in global arsenic biogeochemistry.
Our analysis advances understanding of arsenic resistance, metabolism, and biogeochemistry, and our approach provides a roadmap for the ecological investigation of environmental resistomes.

### Funding
Metagenome sequencing was supported by the Joint Genome Institute Community Science Project #1834 and by [Michigan State University](msu.edu). The work conducted by the U.S. Department of Energy (DOE) [Joint Genome Institute](jgi.doe.gov), Contract No. DE-AC02-05CH11231. TKD was supported by the [Ronald and Sharon Rogowski Fellowship for Food Safety and Toxicology](https://mmg.natsci.msu.edu/academics/graduate/information-for-current-graduate-students/funding/awards-fellowships/) and the [Russel B. DuVall Graduate Fellowship](https://mmg.natsci.msu.edu/academics/undergraduate-programs/awards-fellowships/previous-duvall-awardees/) from the Department of Microbiology and Molecular Genetics. SYY was supported through the Advanced Computational Research Experience program funded by the National Science Foundation under Grant No. [1560168](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1560168). AS acknowledges support from the National Science Foundation DEB# [1655425](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1655425) and [#1749544](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1749544), from the USDA National Institute of Food and Agriculture and Michigan State University AgBioResearch. AS and TKD acknowledge support from the National Institutes of Health R25GM115335.

### More info
[ShadeLab](http://ashley17061.wixsite.com/shadelab/home)


======
# Toolkit for detecting arsenic resistance genes
Taylor K Dunivin, Susanna Yeh, Ashley Shade

This repository contains several databases to detect arsenic resistance genes from nucleotide (genome, metagenome, metatranscriptome) and amino acid (assembled genome) data sets. 

 <img src="https://github.com/ShadeLab/meta_arsenic/blob/master/images/Figure1-01.png" width="500" height="450"> 

## 1. [HMM_search](https://github.com/ShadeLab/meta_arsenic/tree/master/HMM_search)
- Tools and guide to search amino acid sequences for arsenic resistance genes using hidden markov models
- Analysis of arsenic resistance genes in RefSoil (Choi et al 2017) genomes 

## 2. [FunGene databases](http://fungene.cme.msu.edu/)

## 3. [BLAST_databases](https://github.com/ShadeLab/meta_arsenic/tree/master/BLAST_databases)
- Nucleotide and amino acid BLAST databases

## 4. [gene_targeted_assembly](https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly)
- arsenic resistance gene resource information for running Xander (Wang et al 2015), a gene-targeted metagenome assembler
- Analysis of arsenic resistance genes in different soil metagenomes
