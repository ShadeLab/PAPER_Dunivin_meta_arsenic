## Summary of Sites 

To find the samples, go to http://metagenomics.anl.gov/mgmain.html?mgpage=search, enter the project ID in the search bar (ex. mgp79868), and choose the field to be project ID. Then all the samples will come up in that project. On the left, click on the gears/settings button and choose "bp count" and "file type". Then have the samples order themselves by bp count.

To download samples, use curl with the API command. For example: SITE=IowaCorn_4539522.3 and ProjectID=mgm4539522.3:
```
curl "http://api.metagenomics.anl.gov/1/download/${ProjectID}?file=050.1" > ${SITE}.fastq
```

#### Table of Contents:
* [Iowa_corn](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#1-iowa_corn)
* [Iowa_agricultural](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#2-iowa_agricultural)
* [Mangrove](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#3-mangrove)
* [Permafrost_Russia](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#4-permafrost_russia)
* [Iowa_prairie](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#5-iowa_prairie)
* [Brazilian_forest](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#6-brazilian_forest)
* [Illinois_soybean](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#7-illinois_soybean)
* [Minnesota_grassland](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#8-minnesota_grassland)
* [Disney_preserve](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#9-disney_preserve)
* [California_grassland](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#10-california_grassland)
* [Illinois_corn](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#11-illinois_corn)
* [Wyoming_soil](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#12-wyoming_soil)
* [Permafrost_Canada](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md#13-permafrost_canada)

#### 1. Iowa_corn
[ProjectID: mgp6368](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp6368)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539522.3): mgm4539522.3;  fastq file, has the 2nd bp in the project (the file with the most bp is not in fastq format), less than 30% failed QC; 8,298,450,011 bp, 19G
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
  * fastx: used -Q64 flag(Illumina 1.5)
  * 8,298,450,011 bp -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539523.3): mgm4539523.3;   fastq file, has the 3rd most bp in the project, 13% failed QC; 8,223,202,056 bp, 19G
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
  * fastx: used -Q64 flag
  * 8,223,202,056 bases in downloaded file -- good :)

#### 2. Iowa_agricultural
[ProjectID: mgp2592](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp2592)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4509400.3): mgm4509400.3; fastq file, has the most bp, 23% failed QC; 28,875,056,044 bp, 71G
  * FastQC: seq length: 101, Sanger/Illumina 1.9, failed per base sequence quality, everything else looks good
  * fastx: used -Q33 (Illumina 1.9)
  * 28,875,056,044 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4509401.3): mgm4509401.3; fastq file, has the 3rd most bp (the data with 2nd most bp has a failed QC of 38% so it is not used), 11% failed QC; 8,831,209,922 bp, 22G
  * FastQC: seq length 101, Sanger/Illumina 1.9, per base seq qaulity failed, per base seq content not very good below 9, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 8,831,209,922 bp in downloaded file -- good :)


#### 3. Mangrove
[ProjectID: mgp11628](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp11628)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4603402.3): mgm4603402.3; fastq file, has the most bp, 3.65% failed QC; 55G; 25,815,320,787 bp
  * FastQC: seq length 151-291, Sanger/Illumina 1.9, has some Universal Illumina Adaptor, failed Kmer content
  * the output from `fastx_quality_stats -i Mangrove_4603402.3.fastq -o Mangrove_4603402.3_quality.txt` was of size 0, so i deleted it and ran the command again
  * fastX: used flag -Q33 (Illumina 1.9)
  * 25,815,320,787 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4603270.3): mgm4603270.3; fastq file, has the 2nd most bp, 3.1% failed QC; ~~19G~~ 58G; 25,267,542,871 bp
  * FastQC: seq length 151-291, Sanger/Ilumina 1.9, per base seq content not very good below 9, has Illumina Universal Adaptor, failed Kmer content
  * 25,267,542,871 bp -- good :)


#### 4. Permafrost_Russia
[ProjectID: mgp7176](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp7176)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546812.3): mgm4546812.3; fastq file, has the most bp (tied with Sample2), 12% failed QC; 21,951,850,400 bp, 53G
  * FastQC: seq length 100, per base seq. qual. not very good after 80, failed Kmer content, everything else looks good
  * FastX: used -Q33 flag (Illumina 1.9)
  * 21,951,850,400 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546813.3): mgm4546813.3; fastq file, has the most bp (tied with Sample1), 15% failed QC; 21,951,850,400 bp, 53G
  * FastQC: seq length 100, Sanger/Illumina 1.9, failed per base seq quality, failed Kmer content, everything else looks good
  * FastX: used -Q33 flag (Illumina 1.9)
  * 21,951,850,400 bp in downloaded file -- good :)


#### 5. Iowa_prairie
[ProjectID: mgp6377](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp6377)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539575.3): mgm4539575.3; fastq file, has the most bp, 14% failed QC; 19,954,890,565 bp, 44G
  * FastQC: seq length 33-100,Illumina 1.5 flagged per tile seq. qual., everything else looks good
  * FastX: used -Q64 flag (Illumina 1.5)
  * 19,954,890,565 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539572.3): mgm4539572.3; fastq file, has the 2nd most bp, 14% failed QC; 18,724,092,302 bp, 41G
  * FastQC: seq length 33-100, Illumina 1.5, looks good
  * 18,724,092,302 bp in downloaded file -- good :)

* [Sample3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539576.3): mgm4539576.3; fastq file, 3rd most bp, 14% failed QC; 18,582,589,285 bp, 41G
  * Iowa_prairie_mgm4539576.3.qc.fastq.gz is of size 16G


#### 6. Brazilian_forest
[ProjectID: mgp3731](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp3731)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546395.3): mgm4546395.3; fastq file, has the most bp, 7% failed QC; 17,999,861,638 bp, 39G
  * FastQC: seq length 150-292, Illumina 1.5, failed per base sequence quality, flagged per tile seq. quality, failed per base seq. content, flagged Kmer content
  * FastX: used flag -Q64 (Illumina 1.5)
  * 17,999,861,638 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4536139.3): mgm4536139.3; fastq file, has the 2nd most bp, 9% failed QC; 17,631,239,942 bp, 38G
  * FastQC: seq length 150-292, failed per base seq quality, per seq. qual. score peak ~21, failed per base seq. content, failed Kmer content
  * FastX: used flag -Q64 (Illumina 1.5)
  * 17,631,239,942 bp in downloaded file -- good :)

* [Sample3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4535554.3): mgm4535554.3; fastq, 3rd most bp, 9.82% failed QC; 17,365,069,895 bp
  * I chose to download another sample from this project because the first two samples have different average genome sizes


#### 7. Illinois_soybean
[ProjectID: mgp2076](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp2076)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4502542.3): mgm4502542.3; fastq file, has the most bp, 26% failed QC; 13,345,395,200 bp, 33G
  * FastQC: seq length 100, Sanger/Illumina 1.9, per base seq. qual not good from 75-100, per base seq. content not very good below 10
  * FastX: used flag -Q33 (Illumina 1.9)
  * 13,345,395,200 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4502540.3): mgm4502540.3; fastq file, has the 2nd most bp, 11% failed QC; 11,312,148,300 bp, 28G
  * FastQC: seq length 100, Sanger/Illumina 1.9, bad per base seq. qual. 80-100, per base seq. content not very good below 12, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,312,148,300 bp in downloaded file -- good :)

#### 8. Minnesota_grassland
[ProjectID: mgp5588](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp5588)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4541646.3): mgm4541646.3; fastq file, has the most bp, 2.55% failed QC; 11,702,083,089 bp, 27G
  * FastQC: seq length 151, Sanger/Illumina 1.9, per base seq qual not good above 140, per base seq. content not very good below 9
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,702,083,089 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4541645.3): mgm4541645.3; fastq file, has the 2nd most bp, 2.58% failed QC; 10,745,529,044 bp, 25G
  * FastQC: seq length 151, Sanger/Ilumina 1.9, per base sequence qual. not good above 140, per base seq. content not very good below 9, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
  * 10,745,529,044 bp in downloaded file -- good :)


#### 9. Disney_preserve
[ProjectID: mgp13948](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp13948)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4664918.3): mgm4664918.3; fastq file, most bp, .05% failed QC; 11,665,934,500 bp, 26G
  * FastQC: seq length 12-190, Illumina 1.9, failed per tile seq quality, per base seq content not very good below 10, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,665,934,500 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4664925.3): mgm4664925.3; fastq file, 2nd most bp, .04% failed QC; 4,319,683,800 bp, 9.6G
  * FastQC: seq. length 12-190, failed per tile sequence qual., per base sequence content not very good from 1-8
  * FastX: used flag -Q33 (Illumina 1.9)
  * 4,319,683,800 bp in downloaded file -- good :)


#### 10. California_grassland
[ProjectID: mgp1992](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp1992)
* ~~[Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511061.3): mgm4511061.3; fastq file, most bp, 19% failed QC; 11,650,135,800 bp, 29G~~
  * ~~FastQC: seq length: 100, Sanger/Illumina 1.9, per base seq qual not very good after 85, flagged per base sequence content, failed per sequence GC content, everything else looks good~~
  * ~~FastX: used flag -Q33 (Illumina 1.9)~~
  * ~~11,650,135,800 bp in downloaded file -- good :)~~
  * ~~MicrobeCensus: average_genome_size:    41,173,627.473; total_bases:    11,084,443,800; genome_equivalents:     308.201884615~~
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511115.3): mgm4511115.3; fastq file, 2nd most bp, 10% failed QC; 7,009,796,000 bp, 18G
  * June 7: File size seems too small, I am downloading again under name "California_grassland_4511115.3_new.fastq"
  * FastQC: seq length: 100, Sanger/Illumina 1.9, per base seq quality bad after 80, per base seq content not very good below 10, failed per seq GC content, failed Kmer content.
  * 7,009,796,000 bp in downloaded file -- good :)

* Metadata from this project
* [Sample 3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511062.3): mgm4511062.3; fastq file, 4rd most bp (sample with 3rd most bp had >30% failed QC), 22.8% failed QC; 5,909,734,300 bp, 15G
  * FastQC: seq length 100, Sanger/Illumina 1.9, per base quality not very good above 85, failed per tile seq, per base seq content not vey good below 10, flagged per seq GC content, failed Kmer content
  * 5,909,734,300 bp -- good :)


#### 11. Illinois_corn
[ProjectID: mgp14596](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp14596)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4653791.3): mgm4653791.3; fastq file, most bp, .05% failed QC; 8,078,926,770 bp, 18G
  * FastQC: seq. length 12-190, Sanger/Illumina 1.9, per base seq. content not very good below 9 and above 160, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 8,078,926,770 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4653788.3): mgm4653788.3; fastq file, 2nd most bp, .06% failed QC; 7,255,603,912 bp, 16G
  * FastQC: seq length: 12-190, Sanger/Illumina 1.9, seq. length 12-190, per base seq. content not very good below position 9, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 7,255,603,912 bp in downloaded file -- good :)

#### 12. Wyoming_soil
[ProjectID: mgp15600](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp15600)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4670122.3): mgm4670122.3; fastq file, most bp, 6% failed QC; 7,678,885,748 bp, 2.0G
  * 7,678,885,748 bp in downloaded file -- good :)

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4670120.3): mgm4670120.3; fastq file, 2nd most bp, 6% failed QC; 7,003,222,356 bp, 16G
  * FastQC: seq length: 151, Sanger/Illumina 1.9, per base seq content not very good below 10, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 7,003,222,356 bp in downloaded file -- good :)


#### 13. Permafrost_Canada
[ProjectID: mgp252](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp252)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523778.3): mgm4523778.3; fastq file, most bp, 8% failed QC; 7,078,859,018 bp, 12K
  * ~~Files too small, downloading again~~
  * ~~second download: 12K~~
  * ~~NOTE: *Failed to process Permafrost_Canada_4523778.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*~~
  * ~~didnt do FastX~~
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523023.3): mgm4523023.3; fastq file, 2nd most bp, 10% failed QC; 6,700,261,439 bp, 16G
  * Files too small, downloading again
  * Second download: 16G
  * FastQC: seq length: 102-192, Sanger/Illumina 1.9, failed per tile seq quality, per base seq. content bad below 20, flagged seq length distribution, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
  * 6,700,261,439 bp in downloaded file -- good :)

* [Sample 3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523145.3) (because Sample 1 didnt work with FastQC): mgm4523145.3; fastq file, third most bp, 17% failed QC; 5,614,599,082 bp, 13G
  * FastQC: seq length 102-192, Sanger/Illumina 1.9, per base seq content bad below 20, failed per seq GC content, flaggd seq length distribution, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
  * 5,614,599,082 bp in downloaded file -- good :)
