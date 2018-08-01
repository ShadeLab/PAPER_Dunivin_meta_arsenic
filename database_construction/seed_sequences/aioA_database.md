# aioA database construction
### Taylor Dunivin
## February 14, 2017
### Goals: 
* Compile full length AioA sequences
* Assess NCBI classification of AioA
* distinguish between AioA and potential contaminants

### AioA crystal structures
* Ellis et al., 2001
  * 5 UniProt stars (experiment at protein-level; crystal struct)
  * 3 3Fe-4S clusters
  * 1 charge transfer site
  * 4 substrate binding sites
  * __826__ amino acids
  * sequence MSRPNDRITLPPANAQRTNMTCHFCIVGCGYHVYKWPELQEGGRAPEQNALGLDFRKQLPPLAVTLTPAMTNVVTEHNGRRYNIMVVPDKACVVNSGLSSTRGGKMASYMYTPTGDGKQRLKAPRLYAADQWVDTTWDHAMALYAGLIKKTLDKDGPQGVFFSCFDHGGAGGGFENTWGTGKLMFSAIQTPMVRIHNRPAYNSECHATREMGIGELNNAYEDAQLADVIWSIGNNPYESQTNYFLNHWLPNLQGATTSKKKERFPNENFPQARIIFVDPRETPSVAIARHVAGNDRVLHLAIEPGTDTALFNGLFTYVVEQGWIDKPFIEAHTKGFDDAVKTNRLSLDECSNITGVPVDMLKRAAEWSYKPKASGQAPRTMHAYEKGIIWGNDNYVIQSALLDLVIATHNVGRRGTGCVRMGGHQEGYTRPPYPGDKKIYIDQELIKGKGRIMTWWGCNNFQTSNNAQALREAILQRSAIVKQAMQKARGATTEEMVDVIYEATQNGGLFVTSINLYPTKLAEAAHLMLPAAHPGEMNLTSMNGERRIRLSEKFMDPPGTAMADCLIAARIANALRDMYQKDGKAEMAAQFEGFDWKTEEDAFNDGFRRAGQPGAPAIDSQGGSTGHLVTYDRLRKSGNNGVQLPVVSWDESKGLVGTEMLYTEGKFDTDDGKAHFKPAPWNGLPATVQQQKDKYRFWLNNGRNNEVWQTAYHDQYNSLMQERYPMAYIEMNPDDCKQLDVTGGDIVEVYNDFGSTFAMVYPVAEIKRGQTFMLFGYVNGIQGDVTTDWTDRNIIPYYKGTWGDIRKVGSMEEFKRTVSFKSRRFA
 
### Full length, quality AioA sequences
* No publication
  * 4 Uniprot stars (experiment at transcript level)
  * 3 3Fe-4S clusters
  * 1 charge transfer site
  * 4 substrate binding sites
  * __826__ amino acids
  * sequence
  MSKNRDRVALPPVNAQKTNMTCHFCIVGCGYHVYKWDENKEGGRAANQNALGLDFTKQLPPFATTLTPAMTNVITAKNGKRSNIMIIPDKECVVNQGLSSTRGGKMAGYMYAADGMTADRLKYPRFYAGDQWLDTSWDHAMAIYAGLTKKILDQGNVRDIMFATFDHGGAGGGFENTWGSGKLMFSAIQTPTVRIHNRPAYNSECHATREMGIGELNNSYEDAQVADVIWSIGNNPYETQTNYFLNHWLPNLNGSTEEKKKQWFAGEPVGPGLMIFVDPRRTTSIAIAEQTAKDRVLHLDINPGTDVALFNGLLTYVVQQGWIAKEFIAQHTVGFEDAVKTNQMSLADCSRITGVSEDKLRQAAEWSYKPKAAGKMPRTMHAYEKGIIWGNDNYNIQSSLLDLVIATQNVGRRGTGCVRMGGHQEGYVRPPHPTGEKIYVDQEIIQGKGRMMTWWGCNNFQTSNNAQALREVSLRRSQIVKDAMSKARGASAAEMVDIIYDATSKGGLFVTSINLYPTKLSEAAHLMLPAAHPGEMNLTSMNGERRMRLSEKFMDAPGDALPDCLIAAKAANTLKAMYEAEGKPEMVKRFSGFDWKTEEDAFNDGFRSAGQPGAEPIDSQGGSTGVLATYTLLRAAGTNGVQLPIKRVENGKMIGTAIHYDDNKFDTKDGKAHFKPAPWNGLPKPVEEQKAKHKFWLNNGRANEVWQSAYHDQYNDFVKSRYPLAYIELNPGDAQSLGVAAGDVVEVFNDYGSTFAMAYPVKDMKPSHTFMLFGYVNGIQGDVTTDWVDRNIIPYYKGTWGSVRRIGSIEQYKKTVSTKRRAFDNV
  
### NCBI AioA classififcations
* This section will be a little different from others since AioA has two "specific" domains
 * MopB-Arsenite-Ox 
 * MopB-CT-Arsenite-Ox 

* MopB-Arsenite-Ox 
  * The hot pink in the middle of the tree is expected AioA. All of the other colors show sequences belonging to the Mo-binding protein family. It may be difficult to distinguish between these proteins during analysis. I will need to be _highly_ specific. 
  * ![aioA NCBI tree](https://github.com/ShadeLab/meta_arsenic/blob/master/database_construction/images/aioA.cgi.gif)
  * Here is a zoomed in look at AioA sequences only
  * ![aioA NCBI truncated](https://github.com/ShadeLab/meta_arsenic/blob/master/database_construction/aioA_truncated.gif)
  * Analysis of quality/ confidence in NCBI's AioA sequences
   * Crystal struct is there (Ellis)
   * Similar prot w experimental evidence (AAR05656.1)
   * All other sequences 1) cluster away from these two with high confidence and 2) have no supporting experimental evidence, so they will be excluded. 
   
* MopB-CT-Arsenite-Ox
 * The dark orange (between red and yellow) is the arsenite oxidase-ct
 * ![aioA_ct ncbi](https://github.com/ShadeLab/meta_arsenic/blob/master/database_construction/images/aioA_ct.gif)
 * Once again, there are many Mo-contaminating proteins that I will need to be weary of
 * Here's a zoomed in look at AioA_ct only
 * ![aioA_ct ncbi truncated](https://github.com/ShadeLab/meta_arsenic/blob/master/database_construction/images/aioA_ct_truncated.gif)
 * Analysis of quality/confidence in NCBI's AioA_ct sequences
  * Crystal structure is included (Ellis)
  * Similar prot w experimental evidence (AAR05656.1)
  * All other sequences 1) cluster away from these two with high confidence and 2) have no supporting experimental evidence, so they will be excluded. 
 
* Information from MopB-Arsenite-Ox and MopB-CT-Arsenite-Ox NCBI groups was the same

* I am left with only three sequences total for AioA. I will plot them with a dissimilatory arsenate reductase to be sure that they at least separate from those sequences. 

### ML Tree of aioA seeds + arxA bootstrap
* ![aioA seeds](https://github.com/ShadeLab/meta_arsenic/blob/master/database_construction/images/aioA_boot.pdf)
* Black box represents the sequence from aioA crystal structure; open circle is arxA for bootstrapping
* The tree looks good overal. I am confident in the sequences chosen. I will examine the FunGene database once it is constructed to be sure that I capture enough diversity with these sequences. For now, I am more concerned about specificity. 
  



