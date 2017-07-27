#### Check Phylogeny
* Script title: [`phylo.sh`](https://github.com/ShadeLab/meta_arsenic/blob/master/phylogenetic_analysis/bin/phylo.sh)
* Location: `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/bin`
* From `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/GENE`, to execute: `../bin/./phylo.sh GENE CLUST`
* [Written by TD](https://github.com/ShadeLab/Xander_arsenic/blob/master/phylogenetic_analysis/bin/phylo.sh) 
* Pre-script activities: 
  * 1. add file `reference_seqs.fa` to `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/GENE`
      * consists of: (1) **root**, (2) **FASTA** (see directions below), (3) **seeds** (from `/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Xander_assembler/gene_resource/GENE/originaldata/GENE.seeds`)
      * Roots used: 
         * arsB: first sequence from `acr3.seeds`
         * aioA: first sequence from `arrA.seeds`
         * arrA: first sequence from `aioA.seeds`
         * acr3: first sequence from `arsB.seeds`
         * arxA: first sequence from `arrA.seeds`
         * arsC_glut: first sequence from `arsC_thio`
         * arsC_thio: first sequence from `arsC_glut`
         * arsD: root from T.D.'s arsD `reference_seqs.fa`
         * arsM: first root from T.D.'s `arsM reference_seqs.fa`
       * FASTA file directions: save `GENE.ncbi.input.txt`, upload to [batch entrez](https://www.ncbi.nlm.nih.gov/sites/batchentrez), select "Protein", click "Retrieve", "Retrieve records for # UID(s)", click on the pull down menu "Summarize" and select "FASTA (text)"; copy and paste into `reference_seqs.fa`
  * 2. Copy all *final_prot_aligned.fasta* from clusters to the `/OTUabudances/GENE/alignment` directory. For example, for arsB:
    * `GENE=arsB; for i in California_grassland15.3 California_grassland62.3 Permafrost_Canada23.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*final_prot_aligned.fasta /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GENE}/alignment/${i}_${GENE}_45_final_prot_aligned.fasta; done` (replace `GENE` and `i` with the gene and samples which have clusters at that gene)
  * 3. Copy all the *_coverage.txt* files from clusters to the `OTUabundances/GENE` folder. For example: 
    * `GENE=arsB; for i in California_grassland15.3 California_grassland62.3 Permafrost_Canada23.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*_coverage.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GENE}/${i}_${GENE}_45_coverage.txt; done` (replace `GENE` and `i` with the gene and samples which have clusters at that gene)
* Relevant outputs:
  * `${GENE}_${CLUST}_labels_short.txt`: Labels of all sequences (short) for incorporating into iTOL trees
  * `${GENE}_${CLUST}_tree_short.nwk`: Maximum likelihood tree of all sequences (short) for iTOL tree
* I did this for each gene, at cluster of 0.1

* uploaded `tree_short.nwk` files (both 0.1 and 0.3) onto [iTOL](http://itol.embl.de/) and added labels.
* Used [label template](http://itol.embl.de/help/labels_template.txt) to create labels:
```
LABELS
SEPARATOR COMMA
DATA
#DATA GOES HERE
```

#### [Examine phylogony of assembled genes](https://github.com/ShadeLab/Xander_arsenic/tree/master/phylogenetic_analysis)
* Essentially the same as steps 1 and 2 except these scripts are gene specific and remove all sequences that are less than 90% of hmm length
* To execute, `./GENE.phylo.sh GENE CLUST`

#### [Group Related Sequences](https://github.com/ShadeLab/Xander_arsenic/tree/master/phylogenetic_analysis)
* Used with the following pairs:
   * arrA, arxA, aioA: name: dissimilatory
   * arsB, acr3: name: efflux.pumps
   * arsC_glut, arsC_thio: name: reductases
* Use [`group.muscle.sh`](https://github.com/ShadeLab/Xander_arsenic/blob/master/phylogenetic_analysis/bin/group.muscle.sh) for full length sequences and [`short.group.muscle.sh`](https://github.com/ShadeLab/Xander_arsenic/blob/master/phylogenetic_analysis/bin/short.group.muscle.sh) for all sequences
* start in `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GROUP}`
* To execute, `../bin/./group.muscle.sh GROUP GENE1 GENE2 GENE3 CLUST`
  * GROUP = name of group; directory for this group should already exist with `reference_seqs.fa` in it
     * **Don't know what to put in reference_seqs.fa... seed sequences and FASTA files for the genes?**
  * GENE123 = will take up to 3 genes; if you are grouping two genes, simply put NA for gene 3
  * CLUST = what cluster cutoff you would like to run
* View in iTOL (note: do not need to adjust labels here)

