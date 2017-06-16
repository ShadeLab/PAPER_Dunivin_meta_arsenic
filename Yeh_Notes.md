#### Susanna Yeh
## June 2-8, 2017

#### Table of Contents:
* [Iowa_corn](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#1-iowa_corn)
* [Iowa_agricultural](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#2-iowa_agricultural)
* [Mangrove](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#3-mangrove)
* [Permafrost_Russia](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#4-permafrost_russia)
* [Iowa_prairie](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#5-iowa_prairie)
* [Brazilian_forest](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#6-brazilian_forest)
* [Illinois_soybean](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#7-illinois_soybean)
* [Minnesota_creek](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#8-minnesota_creek)
* [Disney_preserve](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#9-disney_preserve)
* [California_grassland](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#10-california_grassland)
* [Illinois_soil](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#11-illinois_soil)
* [Wyoming_soil](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#12-wyoming_soil)
* [Permafrost_Canada](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#13-permafrost_canada)
* [Workflow](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#commands)

These are the files I am downloading from MG-RAST and performing FastQC and FastX on:
#### 1. Iowa_corn
[ProjectID: mgp6368](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp6368)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539522.3): mgm4539522.3;  fastq file, has the 2nd bp in the project (the file with the most bp is not in fastq format), less than 30% failed QC; 8,298,450,011 bp, 19G
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
  * fastx: used -Q64 flag(Illumina 1.5)
  * 8,298,450,011 bp -- good :)
  * MicrobeCensus: average_genome_size:    5,248,659.14022; total_bases:    8,192,645,322; genome_equivalents:     1560.90252827

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539523.3): mgm4539523.3;   fastq file, has the 3rd most bp in the project, 13% failed QC; 8,223,202,056 bp, 19G
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
  * fastx: used -Q64 flag
  * 8,223,202,056 bases in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,208,064.83522; total_bases:    8,119,063,902; genome_equivalents:     1558.94063513
* Metadata from this project

#### 2. Iowa_agricultural
[ProjectID: mgp2592](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp2592)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4509400.3): mgm4509400.3; fastq file, has the most bp, 23% failed QC; 28,875,056,044 bp, 71G
  * FastQC: seq length: 101, Sanger/Illumina 1.9, failed per base sequence quality, everything else looks good
  * fastx: used -Q33 (Illumina 1.9)
  * 28,875,056,044 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size: 6,203,490.57042; total_bases:    24,978,407,768; genome_equivalents:     4026.50854136

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4509401.3): mgm4509401.3; fastq file, has the 3rd most bp (the data with 2nd most bp has a failed QC of 38% so it is not used), 11% failed QC; 8,831,209,922 bp, 22G
  * FastQC: seq length 101, Sanger/Illumina 1.9, per base seq qaulity failed, per base seq content not very good below 9, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 8,831,209,922 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size: 6,023,548.5101; total_bases: 7,858,262,277; genome_equivalents: 1304.59018697
* Metadata from this project

#### 3. Mangrove
[ProjectID: mgp11628](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp11628)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4603402.3): mgm4603402.3; fastq file, has the most bp, 3.65% failed QC; 55G; 25,815,320,787 bp
  * FastQC: seq length 151-291, Sanger/Illumina 1.9, has some Universal Illumina Adaptor, failed Kmer content
  * the output from `fastx_quality_stats -i Mangrove_4603402.3.fastq -o Mangrove_4603402.3_quality.txt` was of size 0, so i deleted it and ran the command again
  * fastX: used flag -Q33 (Illumina 1.9)
  * 25,815,320,787 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,979,725.46729; total_bases:    24,378,385,485; genome_equivalents:     4076.84025268
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4603270.3): mgm4603270.3; fastq file, has the 2nd most bp, 3.1% failed QC; ~~19G~~ 58G; 25,267,542,871 bp
  * FastQC: seq length 151-291, Sanger/Ilumina 1.9, per base seq content not very good below 9, has Illumina Universal Adaptor, failed Kmer content
  * 25,267,542,871 bp -- good :)
  * MicrobeCensus: average_genome_size:    6,005,221.20659; total_bases:    24,539,452,204; genome_equivalents:     4086.35275201
* Metadata from this project

#### 4. Permafrost_Russia
[ProjectID: mgp7176](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp7176)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546812.3): mgm4546812.3; fastq file, has the most bp (tied with Sample2), 12% failed QC; 21,951,850,400 bp, 53G
  * FastQC: seq length 100, per base seq. qual. not very good after 80, failed Kmer content, everything else looks good
  * FastX: used -Q33 flag (Illumina 1.9)
  * 21,951,850,400 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,135,678.5758; total_bases:    20,045,920,100; genome_equivalents:     3903.26610284
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546813.3): mgm4546813.3; fastq file, has the most bp (tied with Sample1), 15% failed QC; 21,951,850,400 bp, 53G
  * FastQC: seq length 100, Sanger/Illumina 1.9, failed per base seq quality, failed Kmer content, everything else looks good
  * FastX: used -Q33 flag (Illumina 1.9)
  * 21,951,850,400 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,131,959.93943; total_bases:    19,201,737,900; genome_equivalents:     3741.59933566
* Metadata from this project

#### 5. Iowa_prairie
[ProjectID: mgp6377](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp6377)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539575.3): mgm4539575.3; fastq file, has the most bp, 14% failed QC; 19,954,890,565 bp, 44G
  * FastQC: seq length 33-100,Illumina 1.5 flagged per tile seq. qual., everything else looks good
  * FastX: used -Q64 flag (Illumina 1.5)
  * 19,954,890,565 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    6,994,965.44095; total_bases:    18,794,418,950; genome_equivalents:     2686.84943602
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539572.3): mgm4539572.3; fastq file, has the 2nd most bp, 14% failed QC; 18,724,092,302 bp, 41G
  * FastQC: seq length 33-100, Illumina 1.5, looks good
  * 18,724,092,302 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    7,169,200.19245; total_bases:    17,582,137,098; genome_equivalents:     2452.45447554

* [Sample3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539576.3): mgm4539576.3; fastq file, 3rd most bp, 14% failed QC; 18,582,589,285 bp, 41G
  * Iowa_prairie_mgm4539576.3.qc.fastq.gz is of size 16G
  * MicrobeCensus: average_genome_size:    7,088,957.26281; total_bases:    17,427,453,635; genome_equivalents:     2458.39451261
* Metadata from this project

#### 6. Brazilian_forest
[ProjectID: mgp3731](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp3731)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546395.3): mgm4546395.3; fastq file, has the most bp, 7% failed QC; 17,999,861,638 bp, 39G
  * FastQC: seq length 150-292, Illumina 1.5, failed per base sequence quality, flagged per tile seq. quality, failed per base seq. content, flagged Kmer content
  * FastX: used flag -Q64 (Illumina 1.5)
  * 17,999,861,638 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,787,131.34446; total_bases:    13,274,737,374; genome_equivalents:     2293.83723712
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4536139.3): mgm4536139.3; fastq file, has the 2nd most bp, 9% failed QC; 17,631,239,942 bp, 38G
  * FastQC: seq length 150-292, failed per base seq quality, per seq. qual. score peak ~21, failed per base seq. content, failed Kmer content
  * FastX: used flag -Q64 (Illumina 1.5)
  * 17,631,239,942 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    8,789,768.62772; total_bases:    9,037,116,463; genome_equivalents:     1028.14042619

* [Sample3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4535554.3): mgm4535554.3; fastq, 3rd most bp, 9.82% failed QC; 17,365,069,895 bp
  * I chose to download another sample from this project because the first two samples have different average genome sizes
  * MicrobeCensus: average_genome_size:    8,371,924.00995; total_bases:    9,686,371,640; genome_equivalents:     1157.00663653
* Metadata from this project

#### 7. Illinois_soybean
[ProjectID: mgp2076](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp2076)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4502542.3): mgm4502542.3; fastq file, has the most bp, 26% failed QC; 13,345,395,200 bp, 33G
  * FastQC: seq length 100, Sanger/Illumina 1.9, per base seq. qual not good from 75-100, per base seq. content not very good below 10
  * FastX: used flag -Q33 (Illumina 1.9)
  * 13,345,395,200 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    6,541,610.42007; total_bases:    12,538,228,600; genome_equivalents:     1916.68836798
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4502540.3): mgm4502540.3; fastq file, has the 2nd most bp, 11% failed QC; 11,312,148,300 bp, 28G
  * FastQC: seq length 100, Sanger/Illumina 1.9, bad per base seq. qual. 80-100, per base seq. content not very good below 12, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,312,148,300 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,850,740.66454; total_bases:    10,596,249,500; genome_equivalents:     1811.09539929
* Metadata from this project

#### 8. Minnesota_creek
[ProjectID: mgp5588](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp5588)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4541646.3): mgm4541646.3; fastq file, has the most bp, 2.55% failed QC; 11,702,083,089 bp, 27G
  * FastQC: seq length 151, Sanger/Illumina 1.9, per base seq qual not good above 140, per base seq. content not very good below 9
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,702,083,089 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    6,504,862.26434; total_bases:    10,652,021,539; genome_equivalents:     1637.54759227
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4541645.3): mgm4541645.3; fastq file, has the 2nd most bp, 2.58% failed QC; 10,745,529,044 bp, 25G
  * FastQC: seq length 151, Sanger/Ilumina 1.9, per base sequence qual. not good above 140, per base seq. content not very good below 9, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
  * 10,745,529,044 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    6,057,590.59715; total_bases:    9,765,252,144; genome_equivalents:     1612.06869091
* Metadata from this project

#### 9. Disney_preserve
[ProjectID: mgp13948](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp13948)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4664918.3): mgm4664918.3; fastq file, most bp, .05% failed QC; 11,665,934,500 bp, 26G
  * FastQC: seq length 12-190, Illumina 1.9, failed per tile seq quality, per base seq content not very good below 10, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,665,934,500 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    6,888,257.51994; total_bases:    11,196,718,426; genome_equivalents:     1625.47906979

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4664925.3): mgm4664925.3; fastq file, 2nd most bp, .04% failed QC; 4,319,683,800 bp, 9.6G
  * FastQC: seq. length 12-190, failed per tile sequence qual., per base sequence content not very good from 1-8
  * FastX: used flag -Q33 (Illumina 1.9)
  * 4,319,683,800 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    7,230,169.78764; total_bases:    4,140,346,138; genome_equivalents:     572.648535181
* Metadata from this project

#### 10. California_grassland
[ProjectID: mgp1992](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp1992)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511061.3): mgm4511061.3; fastq file, most bp, 19% failed QC; 11,650,135,800 bp, 29G
  * FastQC: seq length: 100, Sanger/Illumina 1.9, per base seq qual not very good after 85, flagged per base sequence content, failed per sequence GC content, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,650,135,800 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    41,173,627.473; total_bases:    11,084,443,800; genome_equivalents:     308.201884615
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511115.3): mgm4511115.3; fastq file, 2nd most bp, 10% failed QC; 7,009,796,000 bp, 18G
  * June 7: File size seems too small, I am downloading again under name "California_grassland_4511115.3_new.fastq"
  * FastQC: seq length: 100, Sanger/Illumina 1.9, per base seq quality bad after 80, per base seq content not very good below 10, failed per seq GC content, failed Kmer content.
  * 7,009,796,000 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    7,414,208.05852; total_bases:    6,504,798,300; genome_equivalents:     877.342293156
* Metadata from this project

#### 11. Illinois_soil
[ProjectID: mgp14596](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp14596)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4653791.3): mgm4653791.3; fastq file, most bp, .05% failed QC; 8,078,926,770 bp, 18G
  * FastQC: seq. length 12-190, Sanger/Illumina 1.9, per base seq. content not very good below 9 and above 160, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 8,078,926,770 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    7,441,858.7299; total_bases:    7,948,915,988; genome_equivalents:     1068.13583494
  
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4653788.3): mgm4653788.3; fastq file, 2nd most bp, .06% failed QC; 7,255,603,912 bp, 16G
  * FastQC: seq length: 12-190, Sanger/Illumina 1.9, seq. length 12-190, per base seq. content not very good below position 9, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 7,255,603,912 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    6,954,025.89369; total_bases:    7,143,076,714; genome_equivalents:     1027.18580908
* Metadata for this project

#### 12. Wyoming_soil
[ProjectID: mgp15600](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp15600)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4670122.3): mgm4670122.3; fastq file, most bp, 6% failed QC; 7,678,885,748 bp, 2.0G
  * 7,678,885,748 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,354,164.77361; total_bases:    820,651,478; genome_equivalents:     153.27348199

    
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4670120.3): mgm4670120.3; fastq file, 2nd most bp, 6% failed QC; 7,003,222,356 bp, 16G
  * FastQC: seq length: 151, Sanger/Illumina 1.9, per base seq content not very good below 10, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 7,003,222,356 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    5,350,858.32398; total_bases:    6,407,352,347; genome_equivalents:     1197.44384154
* Metadata for this project

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
  * MicrobeCensus: average_genome_size:    3,932,079.96927; total_bases:    6,516,361,434; genome_equivalents:     1657.23013899

* [Sample 3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523145.3) (because Sample 1 didnt work with FastQC): mgm4523145.3; fastq file, third most bp, 17% failed QC; 5,614,599,082 bp, 13G
  * FastQC: seq length 102-192, Sanger/Illumina 1.9, per base seq content bad below 20, failed per seq GC content, flaggd seq length distribution, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
  * 5,614,599,082 bp in downloaded file -- good :)
  * MicrobeCensus: average_genome_size:    4,719,216.01282; total_bases:    5,523,397,608; genome_equivalents:     1170.40576083
* Metadata for this project

#### New Zealand Cole Mine all samples had about 80% failed QC
Project ID: mgp17652

#### Gold Uranium Mines all had > 35% failed QC
Project ID: mgp16411

#### Permafrost_USA *Failed to process Permafrost_USA_4469340.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'* wrong format

#### Contaminated_Canada files are all in fna format, so I did not download
ProjectID: mgp79868

#### Contaminated_China file is in fna format, so I did not download
ProjectID: mgp13736

#### Commands:
To find the samples, go to http://metagenomics.anl.gov/mgmain.html?mgpage=search, enter the project ID in the search bar (ex. mgp79868), and choose the field to be project ID. Then all the samples will come up in that project. On the left, click on the gears/settings button and choose "bp count" and "file type". Then have the samples order themselves by bp count.

To download samples, use curl with the API command. For example: IowaCorn_4539522.3:
```
curl "http://api.metagenomics.anl.gov/1/download/mgm4539522.3?file=050.1" > IowaCorn_4539522.3.fastq
```
To run FastQC, first download FastQC, unzip and change mode of fastqc so you can run it: 
```
wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip
unzip fastqc_v0.11.3.zip
cd FastQC
chmod 755 fastqc
cd ..
```
Then copy your .fastq files in the FastQC directory, and perform FastQC. Then I copied the .html file into my home directory so I could move the file onto my dekstop and open it. For example: IowaCorn_4539522.3.fastq:
```
cp IowaCorn_4539522.3.fastq /directory/FastQC
cd FastQC
/.fastqc IowaCorn_4539522.3.fastq
cp IowaCorn_4539522.3_fastq.html /your-home-directory
```
To run FastX, first download FastX using `module load FASTX/0.0.14` then get the quality stats using `fastx_quality_stats -i IowaCorn_4539522.3.fastq -o IowaCorn_4539522.3_quality.txt`. The -i preceeds the input and the -o preceeds the output filename. Then use fast_quality_filter to trim the data using -Q64 (Illumina 1.5), -q 30 (minimum quality to keep), -p 50 (minimum percent of bases to have the -q quality), and zip the output: 
```
fastq_quality_filter -Q 64 -q 30 -p 50 -i IowaCorn_4539522.3.fastq | gzip -9c > IowaCorn_4539522.3.qc.fastq.gz
```
*Note: found undocumented info on -Q: https://www.biostars.org/p/137049/ and http://seqanswers.com/forums/showthread.php?t=9357: "If the quality scores for your libraries are in the fastq sanger format (ascii(phred+33)), rather than the fastq illumina format (ascii(phred+64)), you would use the -Q33 parameter. fastq_quality_filter automatically assumes fastq illumina quality scores. See here for original explanation: http://seqanswers.com/forums/showthread.php?t=6701"*

Then, get the quality stats of the trimmed output file is through `fastx_quality_stats -i IowaCorn_4539522.3.qc.fastq.gz -o IowaCorn_4539522.3_qc_quality.txt`

To count the number of basepairs in a file, I used this (example is Disney_preserve_4664918.3.fastq) `cat Disney_preserve_4664918.3.fastq | paste - - - - | cut -f2 | tr -d '\n'| wc -c`

I then used MicrobeCensus to estimate the average genome size in each metagenome. Instructions can be found [here](https://github.com/snayfach/MicrobeCensus). First I [set up a Python virtural environment](https://wiki.hpcc.msu.edu/display/hpccdocs/Using+Python+virtualenv+on+the+HPCC) then downloaded MicrobeCensus using `pip install MicrobeCensus`. I ran MicrobeCensus on each metagenome. Here is an example qsub script I used for the Iowa_agricultural data:
```
#!/bin/bash --login

#PBS -l nodes=1:ppn=1
#PBS -l walltime=16:00:00
#PBS -l mem=500gb

#PBS -j oe
#PBS -M my_email
#PBS -m abe
#PBS -N IowaAgCensus

### myPy2 is what I named my Python virtualenv
cd /my-directory/myPy2/bin

module load NumPy
module load SciPy
module load Biopython
source /my-directory/myPy2/bin/activate

python run_microbe_census.py /my-directory/Iowa_agricultural_4509400.3.qc.fastq.gz Iowa_agricultural_4509400.3_census

python run_microbe_census.py /my-directory/Iowa_agricultural_4509401.3.qc.fastq.gz Iowa_agricultural_4509401.3_census
```


#### Assembly Assessment Xander automation:
you have to type the gene and sample name after calling this script, for example if this script is called scriptName.sh, type "$./scriptName.sh arsB cen10" into the commandline. This will create a folder "blastdatabases_SAMPLENAME" and put several files into that folder for the blast database, it will also make and put 4 files made from R into that folder: GENENAME_readssummary.txt, GENENAME_kmerabundancedist.png, GENENAME_stats.txt, and GENENAME_e.values.txt. Then it will find the GC content of the SAMPLENAME_GENENAME_45_final_nucl.fasta file and place the output of that in a folder called GENENAME_gc in my directory
```
#!/bin/bash

#you have to type the gene and sample names after calling this script, for example "$./testAutomation.sh arsB cen10"
#$1 means the first argument (arsB in the example, so the variable GENE would be arsB), $2 is site name
GENE=$1
SAMPLE=$2

#load blast
module load GNU/4.4.5
module load Gblastn/2.28

#switch into correct directory. (Not sure which directory you want)
#cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment
cd /mnt/home/${USER}/examples/test
mkdir databases_${SAMPLE}
cd databases_${SAMPLE}

#make database from diverse gene sequences
makeblastdb -in /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/RDPTools/Xander_assembler/gene_resource/${GENE}/originaldata/nucl.fa  -dbtype nucl -out ${GENE}_database

#blast xander results against db
#tabular format, show seq id, query id (and description), e-value, only show 1 match
blastn -db ${GENE}_database -query /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/${SAMPLE}/k45/${GENE}/cluster/*_final_nucl.fasta -out ${GENE}_blast.txt -outfmt "6 qseqid salltitles evalue" -max_target_seqs 1

#make a list of reads from *match_reads.fa
grep "^>" /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/${SAMPLE}/k45/${GENE}/cluster/*match_reads.fa | sed '0~1s/^.\{1\}//g' > ${GENE}_matchreadlist.txt

##Extract info for stats calculations in R
#take the framebot stats
grep "STATS" /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/${SAMPLE}/k45/${GENE}/cluster/*_framebot.txt > ${GENE}_framebotstats.txt

#take the list of matching reads (from sequencing)
grep "^>" /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/${SAMPLE}/k45/${GENE}/cluster/*match_reads.fa | sed '0~1s/^.\{1\}//g' >${GENE}_matchreadlist.txt

# USE R TO CREATE STATISTIC FILES

#start in cluster directory from xander output!
#cd /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/${SAMPLE}/k45/${GENE}/cluster/
cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/cluster_example_aioA_cen10

# swap and load the version of R you want to use here with module commands
module load GNU/4.9
module load OpenMPI/1.10.0
module load R/3.3.0
 
# Run R Command with input script myRprogram.R
#R script should read in files from the cluster and create 4 new files
R < /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/assembly_assessmentR.R --no-save

#move R files to databases_${SAMPLE}

mv readssummary2.txt ${GENE}_readssummary.txt
mv ${GENE}_readssummary.txt /mnt/home/${USER}/examples/test/databases_${SAMPLE}

mv kmerabundancedist2.png ${GENE}_kmerabundancedist.png
mv ${GENE}_kmerabundancedist.png /mnt/home/${USER}/examples/test/databases_${SAMPLE}

mv stats2.txt ${GENE}_stats.txt
mv ${GENE}_stats.txt /mnt/home/${USER}/examples/test/databases_${SAMPLE}

mv e.values2.txt ${GENE}_e.values.txt
mv ${GENE}_e.values.txt /mnt/home/${USER}/examples/test/databases_${SAMPLE}


#GET GC COUNT OF THIS SAMPLE!

cd /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment

#load perl
module load perl/5.24.1
#get GC count and put output into ${GENE}_gc folder
./get_gc_counts.pl /mnt/research/ShadeLab/WorkingSpace/Dunivin/xander/analysis/${SAMPLE}/k45/${GENE}/cluster/${SAMPLE}_${GENE}_45_final_nucl.fasta

mv gc_out.txt ${SAMPLE}_${GENE}_gc_out.txt
mkdir ${GENE}_gc
mv ${SAMPLE}_${GENE}_gc_out.txt /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/Assessment/${GENE}_gc

```
#### Assessment by Gene:
to count number of unique gene descriptions and tally how many hits to each unique gene description, use commands 
```
cat descriptor.blast | awk -F '[|[]' '{print $3}' > file.txt
sort file.txt | uniq -c > file2.txt
```
That will create a file, file.txt, that contains all the gene descriptions. The command awk finds and replaces text and the -F flag is where you give the delimiters. In our case, since the descriptor.blast file has many lines that are organized like this: `>ref|WP_007602791.1| arsenite oxidase large subunit [Bradyrhizobium sp. WSM1253]`, we want the description that is between the | and [ characters. The `{print $3}'` tells awk to print the third column. Then the next command will print duplicate lines only, with counts, so the output file will look something like this: 
```
     12  arsenate reductase (azurin)
     58  arsenite oxidase large subunit
      7  Arsenite oxidase large subunit
     12  arsenite oxidase large subunit, partial
```
