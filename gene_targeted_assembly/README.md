## [Xander_bin](https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly/xander_bin)
* Includes scripts for quality control, site comparison, and phylogenetic analysis for gene-targeted assembly outputs

## [Diversity Analysis](https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly/diversity_analysis)
* Repository includes assembled sequence data post processing (OTU table analysis). All R scripts are in `bin/`
* `assembly_summary.R`: Script to make assembly summary figure
* `diversity_analysis.R` 
    * __Overarching goals__
       - Normalize AsRG to single copy _rplB_
       - Examine abundance/ distribution of arsenic resistance genes across diverse soil types
       - Examine community structure across diverse soil types using _rplB_
   * __Inputs__
      * `rformat_dist_0.1.txt`: OTU table for each gene of interest
      * `rplB_45_taxonabund.txt`: for each site of interest to examime taxon abundance of _rplB_
   * __Outputs__
      * `out_table_full.txt`: OTU table (for all AsRGs and _rplB_)
      * `rplB.summary.scg.txt`: coverage-adjusted abundance of _rplB_ in each metagenome
      * `metaG_normAbund.txt`: summary table for RefSoil comparison
   * __Figures__
   	  *	`asrg.quality.eps`: Quality of assembled AsRGs (percent identity to database vs. length in base pairs)
   	  * `shared.otus.eps`: AsRG OTUs present in at least 3 sites
      * `relative_abundace.eps`: relative proportions of AsRGs in soil metagenomes
      * `ordered.point.site.eps`: rank abundance of AsRG OTUs in soil metagenomes
      * `community.structure.full.eps`: Complete rplB relative abundance profile for each site      
      * `community.structure.top.eps`: Truncated rplB relative abundance profile for each site; contains only top 6 phyla to include 70% of each community
      * `refsoil_metaG_comparison_outlier.eps`: boxplots of normalized abundance of AsRGs in metagenomes and RefSoil database
* `iTOL_bargraphs.R`: Script to make bar graphs for phylogenies
* `iTOL_fissim_prep.R`: Prepare bar graphs for multi-gene (dissimilatory AsRG) tree
* `metaG_RefSoil_comparison.R`: Make figure comparing normalized abundance of AsRGs in metagenomes and RefSoil database

## [Gene resource](https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly/gene_resource)
* Directory contains information to run Xander on metagenomic data
* To add AsRGs to your RDPTools (where Xander_assembler) is housed, you can do the following
```
cp -R PATH/TO/GIT/meta_arsenic/gene_targeted_assembly/gene_resource/* PATH/TO/RDPTOOLs/Xander_assembler/gene_resource/
```
* If you only want to add one gene, for example arsB, you can do the following
```
cp -R PATH/TO/GIT/meta_arsenic/gene_targeted_assembly/gene_resource/arsB PATH/TO/RDPTOOLs/Xander_assembler/gene_resource/
```

## [Phylogenetic Analysis](https://github.com/ShadeLab/meta_arsenic/tree/master/gene_targeted_assembly/phylogenetic_analysis)
* Repository contains files of maximum likelihood trees visualized in iTOL as well as iTOL label and bar graph files
 
