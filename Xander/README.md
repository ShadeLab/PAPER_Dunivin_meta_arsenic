I used [Xander](https://github.com/rdpstaff/Xander_assembler), a gene-targeted metagenome assembler, to assemble contigs from my genes of interest. 
* [Xander results for AsRG](https://github.com/ShadeLab/meta_arsenic/blob/master/Xander/Xander_results.md)
* Scripts used:
    * Location: /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/SAMPLE
    * [`xander.qsub`](https://github.com/ShadeLab/meta_arsenic/blob/master/Xander/xander.qsub) builds, searches, and finds contigs of the gene of interest in the metagenome
        * To execute: `qsub xander.qsub`
    * [`run_xander_skel.sh`](https://github.com/ShadeLab/meta_arsenic/blob/master/Xander/run_xander_skel.sh) is the main script to run Xander assembly
    * [`xander.setenv.sh`](https://github.com/ShadeLab/meta_arsenic/blob/master/Xander/xander_setenv.sh) should be edited for each metagenome and gene, providing the file and name of metagenome, and minimum assembled protein contigs
    * More information about these scripts can be found [here](https://github.com/edamame-course/Xander/blob/master/Xander.md)
