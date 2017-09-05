## Diversity Analysis:
* Repository includes assembled sequence data post processing (contig table analysis)
* R_analysis.R 
    * Overarching goals
       1. Exmine alpha diversity of sequences
       2. Examine abundance/ distribution of arsenic resistance genes across diverse soil types
       3. Examine community structure across diverse soil types
       4. Compare AsRG with rplB across diverse soil types
   * Inputs
      * rformat_dist_0.1.txt: contig table for each gene of interest
      * rplB_0.1_FastTree.nwk: rough maximum likelihood tree of rplB (for UniFrac distance measures)
      * rplB_45_taxonabund.txt: for each site of interest to examime taxon abundance of rplB
   * Outputs
      * OTU table (for all arsenic resistance genes and rplB)
   * Figures
      * bar.sample: arsenic resistance gene abundance by sample 
      * bar.site: arsenic resistance gene abundance by site (shows average per sample)
      * community.structure.full: Complete rplB relative abundance profile for each site      
      * community.structure.top: Truncated rplB relative abundance profile for each site; contains only top 6 phyla to include 70% of each community
 
