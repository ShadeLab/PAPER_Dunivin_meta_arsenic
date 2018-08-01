# arsB database construction
### Taylor Dunivin
## February 8, 2017
### Goals: 
* Determine quality of _arsB_ FunGene database
* Determine distinguishing features between *arsB* and *acr3*
* Begin listing seed sequences for *arsB*

### FunGene database quality
* My first thoughts on the db are that there are very few sequences. I think there is more quality diversity to include in the HMM for *arsB* today
* The table below shows each existing seed sequence, its NCBI hit name, its NCBI groups (multidomain, protein superfamily, specific group), length of sequence, and the UniProt annotation score (1-5). 

| Accession | Name | Multidomain | Super Family | Specific group | Lenth (aa) | UniProt Score |
| --------- | ----- | ---------- | --------- | -------- | ------- | :-----: |
| ARSB_STAXY (Q01255) | Arsenical pump membrane protein | arsB | ArsB_NhaD permease | PRK15445 | 429 | 2 |
| YDFA_BACSU (P96678) | Arsenical pump membrane protein | arsB | ArsB_NhaD permease | | 435 | 2 |
| O68021_PSEAE (O68021) | Arsenical pump membrane protein | arsB | ArsB_NhaD permease |  | 425 | 2 |
| ARSB2_ECOLX (P52146) | Arsenical pump membrane protein | arsB | ArsB_NhaD permease | | 429 | 2 |

### *arsB* Notes from FunGene searching
* all existing sequences have low scores and are inferred only by protein homology
* rather than catalytic residues, distinguishing features for *arsB* will likely be transmembrane domains (number and location)
* will need to distinguish between NhaD and ArsB
* ArsB is roughly 430 amino acids
* ArsB has 8-13 transmembrane domains

### Assessment of NCBI *arsB*
Below is a tree for the protein superfamily ArsB_NhaD permease, and colors indicate groups as follows
* red: SCL13_permease
* green: P_permease
* blue: YbiR_permease
* purple: ArsB_permease

![ncbi arsB tree](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arsB_ncbi_grps.gif)

This protein group tells me that there are roughly three other permeases similar to ArsB that I should be weary of when constructing the database. I will put my greatest emphasis on YbiR since it clusters with ArsB. 

### Assessment of new arsB information
1. ArsB from E. coli
  * Meng et al., 2004
  * offers protein function data (4 stars on Uniprot)
  * sequence in UniProt
  * 11 transmembrane domains
  * __429__ aa
  * >sequence
  MLLAGAIFVLTIVLVIWQPKGLGIGWSATLGAVLALVTGVVHPGDIPVVWNIVWNATAAF
  IAVIIISLLLDESGFFEWAALHVSRWGNGRGRLLFTWIVLLGAAVAALFANDGAALILTP
  IVIAMLLALGFSKGTTLAFVMAAGFIADTASLPLIVSNLVNIVSADFFGLGFREYASVMV
  PVDIAAIVATLVMLHLYFRKDIPQNYDMALLKSPAEAIKDPATFKTGWVVLLLLLVGFFV
  LEPLGIPVSAIAAVGALILFVVAKRGHAINTGKVLRGAPWQIVIFSLGMYLVVYGLRNAG
  LTEYLSGVLNVLADNGLWAATLGTGFLTAFLSSIMNNMPTVLVGALSIDGSTASGVIKEA
  MVYANVIGCDLGPKITPIGSLATLLWLHVLSQKNMTISWGYYFRTGIIMTLPVLFVTLAA
  LALRLSFTL

2. Multiple sequences exist with 3 stars. I will include those in my preliminary tree analyses. 

3. In the PURPLE section of the NCBI tree, I went through and selected all sequences that had a publication related to arsenic/ protein function. These are listed below. I did NOT include sequences inferred from homology (e.g. during genome assembly). 

  * ARSB_STAXY (Q01255)
    AUTHORS   Rosenstein,R., Peschel,A., Wieland,B. and Gotz,F.
      TITLE     Expression and regulation of the antimonite, arsenite, and arsenate
                resistance operon of Staphylococcus xylosus plasmid pSX267

  * ARSB2_ECOLX (P52146)
   AUTHORS   Bruhn,D.F., Li,J., Silver,S., Roberto,F. and Rosen,B.P.
    TITLE     The arsenical resistance operon of IncN plasmid R46

  * BAA24823.1 ArsB (plasmid) [Acidiphilium multivorum]
    AUTHORS   Suzuki,K., Wakao,N., Kimura,T., Sakka,K. and Ohmiya,K.
      TITLE     Expression and regulation of the arsenic resistance operon of
                Acidiphilium multivorum AIU 301 plasmid pKW301 in Escherichia coli

### Tree of potential seed sequences
I BLASTed sequences from Uniprot, the 3 NCBI recomended seq, old FunGene seq, and bootstraps to see if there would be any "contaminating" hits. Two aryl sulfatases popped up, so I selected those sequences to include in downstream analysis. 

Below is a maximum likelihood tree with 50 bootstraps. The tree includes sequences used for the current FunGene database (upside down triangles), high quality sequences according to uniprot (black squares), one less quality seq from UniProt (open black square), acr3 arsenite efflux pump for bootstrapping (diamond), and potential contamination aryl sulfatases (triangle)
![arsB tree with seed sequences](https://github.com/ShadeLab/Xander_arsenic/blob/master/images/arsB_boot.png)

It looks like the aryl sulfatases are almost exactly like arsB. BLASTing the sequences also comes up with hits to arsB. I think that this is a nomenclature issue, not a contamination issue. I will not exclude arylsulfatase-similar sequences from the seeds. This is something to keep in mind in downstream analyses though. 
