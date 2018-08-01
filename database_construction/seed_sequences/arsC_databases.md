
#arsC database construction
### Taylor Dunivin
## January 20, 2017
### Goals: 
* Determine distinguishing features between types of *arsC*
* Determine quality of FunGene database
* Distinguish *arsC* from *spxA*

### *arsC* distinguishing features
| NCBI protein family       | Type     | Feature 1      |  2 |  3 |  4 |  5 | Length (aa) |  Comments  |
| ------------- | ----- | ----- | ----- | ----- | ----- | ---- | ------ | :---------------------: |
| arsC_15kD    | Glutaredoxin | C (10) | |  N (56) | R (90) | F (103)| 111-112 | COG1393, nitrogenase assoc? |
| arsC_arsC   | Glutaredoxin | C/X (9) | | R (58) | R (92) | R (105) | 111 | crystal incl |
| arsC_YffB   | Glutaredoxin | C (9) | | N (56) | R (92) | F (106) | 104-106 | crystal incl |
| arsC_like  | Glutaredoxin | C (9) | | N (60) | R (96) | F (110) | 109-112 | |
| arsC_spx  | na | C (10) | C/S (13) | | | | 115-120| no confirmed As-relationship|
| arsC_pI258_fam | Thioredoxin | | | | | | 122-128 | crystal incl |

From the above table, I am now skeptical of the arsC_spx family as actually containing arsC since only one catalytic site is shared and there is no experimental evidence from the NCBI sequences presented to date that sequences from this protein family is an arsenate reductase. 

The below tree shows the arsC (glutaredoxin) sequences according to NCBI. Color code is as follows
* Yellow: arsC_arsC
* Grey: arsC_15kD
* Lime: arsC_spx
* Orange: arsC_like
* Blue: arsC_Yffb

![Image of arsC tree](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arsC_family_tree.gif)

Even the tree of the arsC (glutaredoxin) suggests that arsC_15kD and arsC_arsC are indeed separate from other protein families. With the above information considered, I would say that only protein families arsC_15kD and arsC_arsC are indeed indicative of glutaredoxin arsenate reductases. 

### Current arsC FunGene database
| Accession | Name | Prot Family | Lenth (aa) |
| --------- | ----- | ------ | :-----: |
| Q9CGN5_LACLA (Q9CGN5) | ykhE hypothetical protein | arsC_spx | 115 |
| YQGZ_BACSU (P54503) | regulatory protein MgsR | arsC_spx | 126 |
| Q986E7_RHILO (Q986E7) | arsenate reductase | arsC_YffB | 115 |
| Q9A7S8_CAUCR (Q9A7S8) | arsenate reductase | arsC_YffB | 131 |
| Q9HXX5_PSEAE (Q9HXX5) | arsenate reductase | arsC_YffB | 115 |
| Y103_HAEIN (P44515) | arsenate reductase | arsC_YffB | 114 |
| Q9CM21_PASMU (Q9CM21) | arsenate reductase | arsC | 114 |
| YFFB_ECOLI (P24178) | arsenate reductase arsC | PRK10853 | 118 |
| Q9KQ54_VIBCH (Q9KQ54) | arsenate reductase | arsC_YffB | 131 |
| Q9JZ90_NEIMB (Q9JZ90) | arsenate reductase | arsC_YffB | 124 |
| Q9PH31_XYLFA (Q9PH31) | arsenate reductase/ hypothet prot | (no specific) | 124 |
| YUSI_BACSU (O32175) | thioredoxin/ hypothet prot | arsC_like | 118 |
| Q9K785_BACHD (Q9K785) | hypothet prot/ arsenate reductase | arsC_like | 119 |
| Q9RY16_DEIRA (Q9RY16) | arsenate reductase | arsC | 127 |
| Q9A861_CAUCR (Q9A861) | arsenate reductase | arsC_arsC | 137 |
| Q9CJQ0_PASMU (Q9CJQ0) | arsenate reductase | arsC_arsC | 134 |
| Q9A083_STRP1 (Q9A083) | arsenate reductase | arsC_arsC | 146 |
| Q98J03_RHILO (Q98J03) | arsenate reductase | (no specific) | 140 |
| ARSC_SHIFL (P0AB97) | arsenate reductase | PRK10026 | 141 |
| Q9CLS9_PASMU (Q9CLS9) | arsenate reductase | arsC | 116 |
| Q9KQ39_VIBCH (Q9KQ39) | arsenate reductase | arsC_arsC | 116 |
| YFGD_ECOLI (P76569) | arsenate reductase | arsC_arsC | 119 |
| Q9I508_PSEAE (Q9I508) | arsenate reductase | arsC_arsC | 117 |
| ARSC_NEIMB (P63622) | arsenate reductase | arsC | 117 |
| SPX_BACSU (O31602) | regulatory protein Spx | spxA | 131 |
| SPX_BACHD (Q9K8Z1) | regulatory protein Spx | spxA | 131 |
| SPX_STRP1 (P60381) | regulatory protein Spx | spxA | 134 |
| SPX1_LACLA (Q9CI20) | regulatory protein Spx/ arsenate reductase | (no specific) | 128 |
| SPX_LACLM (P60376) | regulatory protein Spx/ arsenate reductase | (no specific) | 132 |
| Q99XP2_STRP1 (Q99XP2) | arsenate reductase/spx/arsR | spxA | 132 |
| Q9CFY7_LACLA (Q9CFY7) | regulatory protein Spx/ arsenate reductase | arsC_spx | 139 |
| Q9CH93_LACLA (Q9CH93) | arsR/ arsenate reductase| arsC_spx | 142 |
| Q9CFZ8_LACLA (Q9CFZ8) | hyp/spx-like/arsenate reductase | arsC | 125 |
| Y176_UREPA (Q9PQW7) | hypothet/spx/arsR | arsC_related | 128 |
| Y127_MYCGE (P47373) | regulatory/spx/hypothet| (no specific) | 145 |
| Y266_MYCPN (P75509) | hypothet/spx| (no specific) | 145 |

With the above table, I am not satisfied with the FunGene database for arsC. Lots of nonspecific sequences are included that have similar active sites are included, but I have not seen evidence that they are arsC and not spx. 


## February 6, 2017
### Goals: 
* Begin constructing new arsC glutaredoxin database 
* Determine length of arsC based on crystal structures

### Crystal structures of arsC (glutaredoxin)
* E. coli arsC (glutaredoxin)
  * Martin, et al., 2001
  * __141__ amino acides
  * catalytic residues: C12, R60, R94, R107
  * similar to arsC_arsC NCBI group (listed as high quality in previous analysis (Jan 20)
  * sequence: MSNITIYHNPACGTSRNTLEMIRNSGTEPTIILYLENPPSRDELVKLIADMGISVRALLRKNVEPYEQLGLAEDKFTDDQLIDFMLQHPILINRPIVVTPLGTRLCRPSEVVLDILQDAQKGAFTKEDGEKVVDEAGKRLK
 
 ### Alignment of trustworthy arsC sequence (crystal above) with current FunGene
 * Sequences were aligned using MEGA7
 * Maximum likelihood tree, 50 bootstraps (for speed)
 * Sequences clustering with or near arsC were selected. 
  * as expected, these sequences are generally "arsC_arsC" type
  * one PRK10026 group was also included based on fit 
  
 * The below tree shows the resulting group of sequences with thioredoxin-dependent arsC from S.aureus included for bootstrapping. 
  
 ![maximum likelihood of arsC seed sequences](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arsC_glut_boot.png)
 
* I will also move sequence Q9CM21 PASMU as it does not cluster with the remaining arsC sequences. Additionally, it is only classified as NCBI arsC not arsC_arsC (so even they technically separate them). 
 
* .seed sequences were submitted to the RDP to make a FunGene database for arsC (glutaredoxin)

## February 7, 2017
### Goals: 
* Study the structure of arsC (thioredoxin) to look for potential problems (similar proteins, etc.)
* Begin constructing new arsC thioredoxin database 
* Determine length of arsC based on crystal structures

### Crystal structures of arsC (thioredoxin)
* S. aureus arsC (thioredoxin)
 * Zegers, et al., 2001
 * __131__ amino acids
 * catalytic residues: C10, C82, C89
 * sequence: MDKKTIYFICTGNSCRSQMAEGWGKEILGEGWNVYSAGIETHGVNPKAIEAMKEVDIDISNHTSDLIDNDILKQSDLVVTLCSDADNNCPILPPNVKKEHWGFDDPAGKEWSEFQRVRDEIKLAIEKFKLR
 
* B. subtilis arsC (thioredoxin)
* Bennett, et al., 2001
* __134__ amino acids
* catalytic residues: 
* sequence 

### Find other arsC (thioredoxin) sequences
* Center search around quality (functional data, etc.), length (~131-124aa), and similarity to crystal structures (above)
* Strategy
 1. Protein BLAST crystal structure sequences
 2. Select protein group
 3. Examine resulting sequences for desired qualities
 4. Collect any extra sequences with >/=3 stars on UniProt (MUST contain 3 active sites)
 
* NCBI's protein group for arsC (thioredoxin) is arsC_pI258_fam
* According to the crystal structure publications, arsC (thioredoxin) is very similar to protein tyrosine phosphatases; however, there are distinguishing features, and they separate out in a ml tree

The below maximum likelihood tree (50 bootstraps) shows arsC (thioredoxin) sequences. Crystal structures are shown with black squares. Glutaredoxin arsC from E.coli was included to highlight the separation between the arsCs and is indicated with an open square. Open circles show PTPases that have the potential to interfere with HMMs. 

![maximum likelihood tree of arsC thiol](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arsC_thio_boot.png)

* Based on the above tree, I am not concerned about PTPases. It appears there are two clusters from the S.aureus arsC. As a cautionary measure since the second cluster of sequences were not ever confirmed through crystal structure, etc. I will remove them from the .seed sequences. The sequences are on the tree from A7GP55 to C0ZEV2. Otherwise the tree looks good. 

* I will also blast these sequences to be certain that they do not pick up extraneous sequences.
 * Blasting sequences showed they are highly specific
 * Move forward with submitting these sequences to FunGene
