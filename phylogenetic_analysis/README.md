#### Check Phylogeny
* Script title: `phylo.sh`
* Location: `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/bin`
* [Written by TD](https://github.com/ShadeLab/Xander_arsenic/blob/master/phylogenetic_analysis/bin/phylo.sh) 
* Pre-script activities: 
  * add file `reference_seqs.fa`
      * consists of: **FASTA** (see directions below), **seeds** (from `/mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Xander_assembler/gene_resource/GENE/originaldata/GENE.seeds`), and **root**.
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
         * **rplB: [protein blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE=Proteins) `rplB.seeds`, did not see any related family-- did not create tree for rplB**
       * FASTA file directions: save `GENE.ncbi.input.txt`, upload to [batch entrez](https://www.ncbi.nlm.nih.gov/sites/batchentrez), select "Protein", click "Retrieve", "Retrieve records for # UID(s)", click on the pull down menu "Summar" and "FASTA (text), copy and paste into `reference_seqs.fa`
  * Copy all *final_prot_aligned.fasta* from clusters to the `/OTUabudances/GENE/alignment` directory and the *_coverage.txt* files to the `OTUabundances/GENE` folder. For example, for arsB:
  * `GENE=arsB; for i in California_grassland15.3 California_grassland62.3 Permafrost_Canada23.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*final_prot_aligned.fasta /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GENE}/alignment/${i}_${GENE}_45_final_prot_aligned.fasta; done`
  * `GENE=aioA; for i in Brazilian_forest54.3 Illinois_soil88.3 Illinois_soil91.3 Iowa_agricultural00.3 Iowa_prairie72.3 Iowa_prairie75.3 Iowa_prairie76.3 Mangrove02.3 Mangrove70.3 Minnesota_creek46.3 Permafrost_Canada23.3 Permafrost_Canada45.3 Permafrost_Russia13.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*final_prot_aligned.fasta /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GENE}/alignment/${i}_${GENE}_45_final_prot_aligned.fasta; done`
  
  
  * `GENE=arsB; for i in California_grassland15.3 California_grassland62.3 Permafrost_Canada23.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*_coverage.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GENE}/${i}_${GENE}_45_coverage.txt; done`
  
  * `GENE=aioA; for i in Brazilian_forest54.3 Illinois_soil88.3 Illinois_soil91.3 Iowa_agricultural00.3 Iowa_prairie72.3 Iowa_prairie75.3 Iowa_prairie76.3 Mangrove02.3 Mangrove70.3 Minnesota_creek46.3 Permafrost_Canada23.3 Permafrost_Canada45.3 Permafrost_Russia13.3; do cp /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/${i}/k45/${GENE}/cluster/*_coverage.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/${GENE}/${i}_${GENE}_45_coverage.txt; done`
  * In the scripts above, replace GENE and i with the gene and samples which have clusters at that gene
* Relevant outputs:
  * `${GENE}_${CLUST}_labels_short.txt`: Labels of all sequences (short) for incorporating into iTOL trees
  * `${GENE}_${CLUST}_tree_short.nwk`: Maximum likelihood tree of all sequences (short) for iTOL tree
* From `/mnt/research/ShadeLab/WorkingSpace/Yeh/xander/OTUabundances/GENE`, to execute: `../bin/./phylo.sh GENE CLUST`
* I did this for each gene, at clusters of 0.1 and 0.3

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

**NOTES: dissimilatory group: complete.clust_full_rep_seqs_${CLUST}_unaligned.fasta files for aioA and arxA were empty.There were no sequences >=90% of the full HMM. I will create a dissimilatory group tree with short sequences.

| gene | short tree (.1) | long tree (.1) | abundances |
| --- | --- | --- | ---|
| arsB | first tree was wrong, it was mislabeled. The dissimilar 7 was the root. There are 3 OTUs ![arsb_0 1_short](https://user-images.githubusercontent.com/28952961/28029278-8202eaca-656d-11e7-8a0e-7403b5712e59.PNG) | no OTU (longest is <90%) | did not add abundances |
| aioA | looks good ![aioa_0 1_short](https://user-images.githubusercontent.com/28952961/28029390-e18ebca8-656d-11e7-9c8b-fbe50f4f2202.PNG) | no OTU's, the only site with sequences >= 90% is Permafrost_Russia13.3, but somehow no OTUs are on the tree ![aioa_0 1](https://user-images.githubusercontent.com/28952961/28029701-e3c2ce46-656e-11e7-8290-d74885dbc0a1.PNG) | did not add abundances |
| arrA | many OTU's (the bottom of the tree is just OTU's) ![arra_0 1_short](https://user-images.githubusercontent.com/28952961/28029959-d8f5f8de-656f-11e7-8e37-d675f58d6bc0.PNG) | looks good ![arra_0 1](https://user-images.githubusercontent.com/28952961/28030058-2a8002e4-6570-11e7-908a-c20fff204fda.PNG) | abundances from both Mangrove sites only |
| acr3 | looks good, very large | has OTUs ![acr3_0 1](https://user-images.githubusercontent.com/28952961/28139174-472590b4-6721-11e7-8c2a-b1d35b4f962b.PNG) | **WILL ADD ABUNDANCES** |
| arxA | one group without any OTUs: ![arxa_0 1_short](https://user-images.githubusercontent.com/28952961/28030546-346fd66a-6572-11e7-8ec1-d11648b813e8.PNG) | no OTUs, nothing >=90% ![arxa_0 1](https://user-images.githubusercontent.com/28952961/28031115-4a19faca-6574-11e7-9b60-c5242b11769d.PNG) | dod not add abundances |
| arsC_glut | lots of OTUs, sequences between OTUs, not adding picture because it'd be too hard to read | ![arsc_glut_0 1](https://user-images.githubusercontent.com/28952961/28031284-c4ca1a2a-6574-11e7-8712-7ce08e129cc6.PNG) | added abundances ![arsc_glut_0 1_abundances](https://user-images.githubusercontent.com/28952961/28075942-fb2a3d32-662a-11e7-997c-84521dc9c09e.PNG) |
| arsC_thio | lots of OTUs and sequences, looks good | no OTUs (nothing <=90%) ![arsc_thio_0 1](https://user-images.githubusercontent.com/28952961/28031382-162ae520-6575-11e7-85f0-12ddbd68b0ad.PNG) | did not add abundances |
| arsD | looks good ![arsd_0 1_short](https://user-images.githubusercontent.com/28952961/28033443-48ad6ad4-657c-11e7-99b7-251fa86dce32.PNG) | no OTUs,nothing >=90% | did not add abundances |
| arsM | looks good | ![arsm_0 1](https://user-images.githubusercontent.com/28952961/28033343-ecbc038e-657b-11e7-9bcd-e798aa7ff826.PNG) | abundances from mangrove, Disney_preserve, Iowa_praire, Illinois_soil, Permafrost_Canada ![arsm_0 1_abundances](https://user-images.githubusercontent.com/28952961/28076058-76580836-662b-11e7-9130-c48d1c825707.PNG) |
| dissimilatory | tree file was 0, even when I used short sequences  | long tree | abundances |
| efflux pumps | - | no OTUs ![efflux pumps_0 1](https://user-images.githubusercontent.com/28952961/28036336-e2dbbf12-6585-11e7-8bce-bbd69358e7f7.PNG) | - |
| reductases | - | no OTUS ![reducatases_0 1](https://user-images.githubusercontent.com/28952961/28036400-25356606-6586-11e7-91d4-06a671e5e8c5.PNG) | - |
