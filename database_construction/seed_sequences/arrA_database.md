# arrA database construction
### Taylor Dunivin
## March 1, 2017
### Goals: 
* Find full length sequences for *arrA*
* Begin listing seed sequences for *arrA*

### Finding sequences for arrA
* the arrA database construction will have to be a bit different than others
  * no reviewed uniprot sequences exist
  * most information known of arrA sequence diversity comes from primers that do not cover the length of the gene
* I will start by looking to see of NCBI has an arrA section
  * BLASTed first uniprot sequence that appeard to be arrA (dissimilatory arsenate reductase) 
  * I then selected the protein group that appeared: molybdopterin binding superfamily
    * it is know that arrA has two molybdopterin binding sites
  * From that super group, I selected the specific domain hit: MobB_Arsenate-R
    * This specific domain perfectly matched the blast sequence
  * The below tree was given by NCBI for this group
  * ![arrA_ncbi_tree](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arra_ncbi.gif)
  * From this tree, I examined all sequences
    * Sequences were considered "good" if 
      * they came from a paper that specifically tested arsenate reduction in some way
      * if they clustered with sequences that tested arsenate reduciton
    * Sequences were excluded if
      * They were assigned by simmilarity only
      * They did not cluster with high wuality genes
    * This only left the top 3 sequences in the tree
    * This is not unexpected since arrA is the least characterized of the As genes I am testing
    
### Testing the specificity of the 3 arrA sequences
* I will boot the tree with aioA since it is closely related
* If aioA is the most distant, I am confident in the specificity
* Below is an ml tree with 50 bootstraps testing this
* ![arrA_seeds](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arrA_boot.png)
* The tree looks great! I will move forward with these seeds. 
