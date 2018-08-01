# Retrieving sequences from FunGene
### Taylor Dunivin

---
## Filter options (FunGene)

| Protein |  version |min HMM score | min length (aa) | min HMM coverage (%) |  # seq | derep # seq | Comments |
| --------- | ----- | ---------- | --------- | -------- | -------- | -------- |:-----: |
| RpoB | 1 | 1000 | 1175 | 90 | 92,507 | 14876 | u + Eisen '08 scg; Tringe |
| GyrB | 1 | 500 | 750 | 90 | 25,932 | 7521 |  |
| PyrG | 1 | 610 | 500 | 90 | 56065 | 14107 | Wu + Eisen '08 scg | 
| lepA | 1 | 800 | 550 | 90 | 55998 | 14587 | Tringe paper lists as single copy gene | 
| IntI | 1 | 90 | 315 | 80 | 9418 | 2562 |  |
| TetQ | 1 | na | na | na | na | 235 |  | 
| ArsB | 1 | 150 | 400 | 80 | 23680 | 5250 |  | 
| ACR3 | 1 | 140 | 300 | 80 | 2035 | 8002 |  | 
| ArsC_glut | 1 | 80 | 120 | 85 | 18,082 | 9635 |  | 
| ArsC_thio | 1 | 172 | 100 | 80 | 7,180 |  |  | 
| ArrA | 1 | 175 | 75 | 5 | 1,621 | 1487 | allowed low HMM score due to many quality, short PCR products | 
| AioA | 1 | 800 | 800 | 80 | 382 | 293 |  | 
| ArsM | 1 | 200 | 100 | 30 | 3446 | 2948 | only selected As-related seqs; sort aplhabetical | 
| Resfam_vanZ | 1 | 80 | 120 | 80 | 1042 | 189 |  | 
| Resfam_vanY | 1 | 220 | 300 | 80 | 250 | 35 |  | 
| Resfam_vanX | 1 | 100 | 150 | 80 | 16689 | 2340 |  | 
| Resfam_vanW | 1 | 130 | 220 | 80 | 1311 | 423 |  | 
| Resfam_vanT | 1 | 600 | 650 | 80 | 304 | 97 |  | 
| Resfam_vanA | 1 | 700 | 300 | 80 | 250 | 28 |  | 
| Resfam_vanB | 1 | 624 | 300 | 80 | 304 | 38 |  | 
| Resfam_vanC | 1 | 730 | 300 | 80 | 35 | 29 |  | 
| Resfam_vanD | 1 |  |  |  |  |  | Excluding since database cannot distinguish between other van proteins | 
| Resfam_vanH | 1 | 500 | 280 | 80 | 438 | 61 |  | 
| Resfam_vanR | 1 |  |  |  |  |  | Did not include since it's a regulatory protein | 
| Resfam_tetA | 1 | 680 | 390 | 80 | 2060 | 70 |  | 
| Resfam_tetD | 1 | 795 | 350 | 80 | 261 | 9 |  | 
| Resfam_tetX | 1 | 300 | 360 | 80 | 227 | 112 |  | 
| tetQ | 1 | 650 | 600 | 80 | 242 | 70 |  | 
| tetM | 1 | 1175 | 600 | 80 | 5531 | 543 |  | 
| tetW | 1 | 1260 | 600 | 80 | 345 | 169 |  | 
| strA | 1 | 400 | 230 | 80 | 4286 | 154 | aka APH3 | 
| strB | 1 | 159 | 230 | 80 | 4695 | 222 | aka APH6 | 
| Resfam_Qnr | 1 | 230 | 200 | 80 | 2562 | 558 | Resfam_QuinoloneResistanceProteinQnr | 
| Resfam_ermB | 1 | 400 | 200 | 80 | 2090 | 182 |  | 
| Resfam_ermC | 1 | 265 | 200 | 80 | 7173 | 246 |  | 
| repA | 1 | 400 | 220 | 80 | 387 | 31 |  | 
| CAT | 1 | 195 | 200 | 80 | 9996 | 1299 | Resfam_Chloramphenicol_Acetyltransferase_CAT | 
| AAC3-Ia | 1 | 250 | 130 | 80 | 594 | 38 |  | 
| AAC6-Ia | 1 | 100 | 170 | 80 | 757 | 112 |  | 
| AAC6-Ib | 1 | 250 | 170 | 80 | 3081 | 366 |  | 
| AAC6-II | 1 | 300 | 170 | 80 | 3066 | 355 |  | 
| ANT3 | 1 | 310 | 245 | 80 | 7806 | 790 |  | 
| ANT6 | 1 | 130 | 260 | 80 | 4097 | 1066 |  | 
| ANT9 | 1 | 400 | 245 | 80 | 4044 | 41 |  | 
| Class A | 1 | 179 | 275 | 80 | 34258 | 5713 |  | 
| Class B | 1 | 76 | 255 | 80 | 9853 | 2087 |  | 
| Class C | 1 | 400 | 370 | 80 | 12916 | 3641 |  | 
| arsA | 1 | 200 | 400 | 80 | 4373 | 2381 |  | 
| arsD | 1 | 80 | 100 | 80 | 5404 | 876 |  | 
| arxA | 1 | 600 | 800 | 80 | 67 | 54 | low quality db; will rely on phylogenetic analysis | 
| sul2 | 1 | 200 | 245 | 80 | 9031 | 298 | "tet-sul2" | 
| dfra1 | 1 | 100 | 135 | 80 | 4659 | 211 |  | 
| dfra12 | 1 | 90 | 130 | 80 | 26637 | 1252 |  | 
| tolC | 1 | 350 | 430 | 80 | 19431 | 3189 | Resfam_tolC | 
| CEP | 1 | 298 | 390 | 80 | 3747 | 491 | Chloramphenicol efflux pump | 
| mexC | 1 | 300 | 340 | 80 | 2569 | 720 |  | 
| mexE | 1 | 400 | 390 | 80 | 1567 | 665 |  | 
| adeB | 1 | 1400 | 1000 | 80 | 53493 | 10025 |  | 








