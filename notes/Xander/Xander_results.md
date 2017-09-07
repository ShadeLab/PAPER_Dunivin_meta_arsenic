#### Xander results:
* arsC_glut, arsC_thio, and arsD uses `MIN_LENGTH=50  # minimum assembled protein contigs` because they are <150 aa long
* arsM uses `MIN_LENGTH=160  # minimum assembled protein contigs`
* The rest of the genes use `MIN_LENGTH=150`
* some of my clusters have files beginning with the name `cen01_45` because I forgot to change the name 
* "cluster" means there is a cluster, "done" means I executed `assessment.sh`, "copied" means i copied the `final_prot.fasta` file fom the cluster to the `/xander/databases_GENE` folder

| | arsB  | aioA | arrA | acr3 | arxA | arsC_glut | arsC_thio | arsD | arsM | rplB |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Iowa_corn22.3 | -  | - | - | cluster,done | - | cluster, done, copied | - | - | cluster, done, copied | cluster, done, copied  |
| Iowa_corn23.3  | -  | - | - | cluster,done | - | cluster, done, copied | - | - | cluster, done, copied | cluster, done, copied |
| Iowa_agricultural00.3  | -  | cluster, done | - | cluster,done | - | cluster, done, copied | - | cluster, done, copied, **cannot stat `e.values.txt`** | cluster, done, copied | cluster, done, copied |
| Iowa_agricultural01.3  | -  | - | - | - | - | cluster, done, copied | - | - | - | cluster, done, copied |
| Mangrove02.3  | -  | cluster, done | cluster, done | cluster, done | cluster, done, copied | cluster, done, copied | cluster, done, copied | cluster, done, copied, **blast.txt empty** | cluster, done, copied | cluster, done, copied |
| Mangrove70.3  | -  | cluster, done | cluster,done | - | cluster, done, copied | cluster, done, copied | cluster, done, copied | cluster, done, copied | cluster, done, copied | **cluster, copied... ./assessment.sh not working because no kmerabundanceist** |
| **Permafrost_Russia12.3**  | - | - | - | - | - | - | - | - | - | - |
| Permafrost_Russia13.3  | - | cluster, done, copied  | cluster, done, copied | cluster, done, copied | cluster, done, copied, **blast.txt empty** | cluster, done, copied | cluster, done, copied | cluster, done, copied, **blast.txt empty** | cluster, done, copied | cluster, done, copied |
| Iowa_prairie75.3  | -  | cluster, done, copied | - | - | - | cluster, done, copied | - | - | cluster, done, copied | cluster, done, copied |
| Iowa_prairie72.3  | - | cluster, done, copied | - | cluster, done, copied | - | cluster, done, copied | - | - | cluster, done, copied | cluster, done, copied |
| Iowa_prairie76.3  | - | cluster, done | - | - | - | cluster, done, copied | cluster, done, copied | - | cluster, done, copied | cluster, done, copied |
| Brazilian_forest95.3  | - | - | - | - | - | cluster, done, copied | - | - | cluster, done, copied  | cluster, done, copied |
| Brazilian_forest39.3  | -  | - | - | - | - | cluster, done, copied | cluster, done, copied | - | cluster, done, copied | cluster, done, copied |
| Brazilian_forest54.3  | -  | cluster, done | - | - | - | cluster, done, copied | cluster, done, copied | - | cluster, done, copied | cluster, done, copied |
| Illinois_soybean42.3  | -  | - | - | - | - | cluster, done, copied | - | - | cluster, **blast.txt empty**, copied | **redoing** |
| Illinois_soybean40.3  | -  | - | - | - | - | cluster, done, copied | - | - | - | **redoing** |
| Minnesota_creek46.3  | - | at first, there was a cluster, I deleted it and retried twice and there is no cluster | - | cluster, done | - | cluster, done, copied | - | - | cluster, done, copied | cluster, done, copied |
| Minnesota_creek45.3  | - | - | - | - | - | cluster, done, copied | cluster, **blast.txt empty**, copied  | - | cluster, done, copied | cluster, done, copied |
| Disney_preserve18.3  | -  | - | - | cluster, done | - | cluster, done, copied | cluster, done, copied | cluster, done, copied, **blast.txt empty** | cluster, done, copied | cluster, done, copied |
| Disney_preserve25.3  | -  | - | - | cluster, done | - | cluster, done, copied | cluster, done, copied | - | cluster, done, copied | cluster, done, copied |
| California_grassland15.3  | cluster, done, copied | - | - | cluster, done | - | cluster, done, copied | cluster, done | - | - | cluster, done, copied |
| California_grassland62.3  | cluster, done, copied | - | - | cluster, done | - | cluster, done, copied | - | - | - | cluster, done, copied |
| Illinois_soil91.3  | -  | cluster, done | - | cluster,done | - | cluster, done, copied | cluster: **blast.txt empty** | cluster | cluster, done, copied | cluster, done, copied |
| Illinois_soil88.3  | -  | cluster, done | - | cluster, done | - | cluster,done, copied | cluster: **blast.txt empty** | cluster | cluster, done copied | cluster, done, copied |
| **Wyoming_soil20.3**  | -  | - | - | - | - | - | - | - | - | - |
| Wyoming_soil22.3  | -  | - | - | cluster, done | - | cluster, done, copied | - | - | cluster, done, copied | cluster, done, copied |
| Permafrost_Canada23.3  | cluster, done | cluster, done | - | cluster,done | - | cluster, done, copied | cluster, done, copied | cluster, done, copied | cluster done, copied | cluster, done, copied |
| Permafrost_Canada45.3  | - | cluster, done, copied | - | acr3: cluster, done, copied | - | arsC_glut: cluster, copied, done | arsC_thio: cluster, done, copied | arsD: cluster, done, copied | cluster, done, copied | cluster, done, copied |

#### Genes and the respective proteins, with Xander's success
![protein_name](https://user-images.githubusercontent.com/28952961/27612824-72f0ee76-5b66-11e7-9934-73e761fa9312.PNG)
