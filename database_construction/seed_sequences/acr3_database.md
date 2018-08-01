#acr3 database construction
### Taylor Dunivin
## February 10, 2017
### Goals: 
* Determine distinguishing features between types of *acr3*
* Find full length sequences

### Existing acr3 information
Villadangos et al., 2012
* Annotation score 4 (Protein-level information)
* Full length sequence
* 10 transmembrane domains
* __370__ amino acids
* sequence
MTNSTQTRAKPARISFLDKYIPLWIIAMAFGLFLGRSVSGLSGFLGAMEVGGISLPIALGLLVMMYPPLAKVRYDKTKQIATDKHLMGVSLILNWVVGPALMFALAWLFLPDQPELRTGLIIVGLARCIAMVLVWSDMSCGDREATAVLVAINSVFQVAMFGALGWFYLQVLPSWLGLPTTTAQFSFWSIVTSVLVFLGIPLLAGVFSRIIGEKIKGREWYEQKFLPAISPFALIGLLYTIVLLFSLQGDQIVSQPWAVVRLAIPLVIYFVGMFFISLIASKLSGMNYAKSASVSFTAAGNNFELAIAVSIGTFGATSAQAMAGTIGPLIEIPVLVGLVYAMLWLGPKLFPNDPTLPSSARSTSQIINS

Fu et al., 2009
* Annotation score 3 (protein-level information)
* 10 transmembrane domains
* __357__ amino acids
* sequence
MGNENVVHEGKGIGFFERYLTVWVAACIIVGVAIGQLLPAVPETLSRWEYAQVSIPVAILIWLMIYPMMLKIDFTSIVEATKKPKGIIVTCVTNWLIKPFTMYLIAAFFFKIVFQNLIPESLANDYLAGAVLLGAAPCTAMVFVWSHLTKGDPAYTLVQVAVNNIILLFAFTPIVAILLGITDVIVPYDTLFLSVVLFIVIPLVGGYLSRKYIVQSKGIEYFENVFLKKFDNVTIVGLLLTLIIIFTFQAEVILSNPLHVLLIAVPLTIQTFFIFFLAYGWSKAWKLPHNVASPAGMIGASNFFELAVAVAITLFGLNSGATLATVVGVLVEVPVMLTLVKISNRTRHWFPEVAREN

Other protein sequences were chosen from UniProt as long as they had
1. Score of 2 or more
2. >320 amino acids
3. 10 transmembrane domains

### Look for potential contaminations (BLAST existing sequences)
* 9 sequences fit criteria from UniProt
* I will blast them all to see whether nonspecific hits come up
* bile acid symporter comes up with some sequences, but this always occurs with acr3 as an alternative title
  * I know of publications that call this symporter acr3
  * I will proceed with these sequences

### Examine NCBI superfamily acr3
* Brings up concerns for the following proteins (due to overlap/similarity)
  * sbf
  * YfeH
 * acr3 is the longest. This will be an important consideration in results if I do not get full length protein sequences
 
### Visualize sequences
* all potential seed sequences were used
* E.coli arsB was used for bootstrapping
* maximum likelihood tree with 50 bootstraps
* highest quality sequences (publications) are indicated with black boxes

![acr3 tree](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/acr3_boot.png)

Based on the above tree (distance) and blast results (acr3 not listed as specific protein hit, just yfeh), I removed sequences Q9X0Q5_THEMA. All other sequences were kept
