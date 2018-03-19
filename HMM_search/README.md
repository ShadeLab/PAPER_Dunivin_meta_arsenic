Folder contains [tools](https://github.com/ShadeLab/meta_arsenic/tree/master/HMM_search/bin) to assess abudnance of AsRGs in *soil* genomes as well as analysis of AsRGs in [RefSoil genomes](https://github.com/ShadeLab/meta_arsenic/tree/master/HMM_search/RefSoil_HMM_search)

---

# Detection of arsenic resistance genes using hidden markov models
This repository contains examples of and information on detecting arsenic resistance genes using hidden markov models. If you want to use arsenic resistance gene HMMs for other purposes, feel free to bypass this workflow and work with the `.hmm` files directly [https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly/gene_resource](https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly/gene_resource) which are located in the gene_resources directories. 

## Required tools
* [HMMER 3.1](http://hmmer.org/download.html)
* R 3.4+

## Details 
* Protocol includes the following arsenic resistance genes: _acr3_, _aioA_, _arrA_, _arsA_, _arsB_, _arsC_glut_, _arsC_thio_, _arsD_, _arsM_, _arxA_
* Inputs 
  * [search_setenv.sh](https://github.com/ShadeLab/meta_arsenic/blob/master/HMM_search/bin/search_setenv.sh) 
  * dataset(s) to test
* Outputs 
  * `stdout.txt`: standard output for hmmsearch (contains all available data). per gene per dataset
  * `alignment.txt`: shows alignment of target and query. per gene per dataset
  * `tbl.txt`: tabular output. per gene per dataset
  * (potentially) `no_hits.txt`: This file is created if there were no hits to a specific arsenic resistance gene in a dataset. It lists all genes in all datasets that were not detected. Space delim file containing two columns: 1) gene 2)dataset.

## Quickstart 
* The following example will test datasets sequence1.fa and sequence2.fa for all arsenic resistance genes specified in the input file.
```
./AsRG_hmmsearch.sh search_setenv.sh "sequence1.fa sequence2.fa"
```

## Environmental setup 
Must edit [search_setenv.sh](https://github.com/ShadeLab/meta_arsenic/blob/master/HMM_search/bin/search_setenv.sh) to fit your environment before beginning
   * `SEQDIR`: absolute path to folder that contains your sequence(s) of interest
   * `WORKDIR`: absolute path to your results
   * `REF_DIR`: absolute path to directory containing `gene_resource` (if you git cloned this repository the path is as follows `/PATH_TO_GIT_DIRECTORY/methods_arsenic/gene_targeted_assembly`)
   * `HMMSEARCH`: absolute path to hmmsearch (example: /opt/software/HMMER/3.1b2--GCC-4.8.3/bin/hmmsearch)

## Parameters
Search parameters can be adjusted in [search_setenv.sh](https://github.com/ShadeLab/meta_arsenic/blob/master/HMM_search/bin/search_setenv.sh) before running

   * `AsRG`: adjust this if you do not need to test all 10 arsenic resistance genes
   * `evalue`: adjust this if you would like an e-value cutoff to be more or less stringent. Default set to E-10
   * `THREADS`: number of processors to use. Default set to 1
   
## Trimming
We recomend trimming the resulting outputs based on the alignment length, percent identity, and duplicate hits. The provided R script will correct these errors. 
* We do not recomend positive hits with alignments < 80 % hmm length. 
* Genes _aioA_, _arrA_, and _arxA_ can result in duplicate hits in rare cases. The following R script examines the results for this issue and provides a workaround where the sequence with the highest bit score is accepted and the secondary hit is discarded. 
* __Inputs__: all `.tbl.txt` files from `AsRG_hmmsearch.sh` (can be from multiple genes and datasets)
* __Output__: `AsRG_summary.txt`: Tabular file with high quality hmm hits

