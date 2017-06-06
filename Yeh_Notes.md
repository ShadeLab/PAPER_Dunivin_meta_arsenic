#### Susanna Yeh
## June 2-6, 2017

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
* [Permafrost_USA](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#14-permafrost_usa)
* [Workflow](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#commands)

These are the files I am downloading from MG-RAST and performing FastQC on:
#### 1. Iowa_corn
ProjectID: mgp6369
* Sample1: mgm4539522.3;  fastq file, has the 2nd bp in the project (the file with the most bp is not in fastq format), <30% failed QC
  * FastQC: Sequence length 31-100, failed Kmer, everything else looks good
* Sample2: mgm4539523.3;   fastq file, has the 3rd most bp in the project, <30% failed QC
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
* Metadata from this project

#### 2. Iowa_agricultural
ProjectID: mgp2592
* Sample1: mgm4509400.3; fastq file, has the most bp, 23% failed QC
  * FastQC: seq length: 101, Sanger/Illumina 1.9, failed per base sequence quality, everything else looks good
* Sample2: mgm4509401.3; fastq file, has the 3rd most bp (the data with 2nd most bp has a failed QC of 38% so it is not used), 11% failed QC
  * FastQC: seq length 101, Sanger/Illumina 1.9, per base seq qaulity failed, per base seq content not very good below 9, everything else looks good
* Metadata from this project

#### 3. Mangrove
ProjectID: mgp11628
* Sample1: mgm4603402.3; fastq file, has the most bp, 3.65% failed QC
  * FastQC: seq length 151-291, Sanger/Illumina 1.9, has some Universal Illumina Adaptor, failed Kmer content
* Sample2: mgm4603270.3; fastq file, has the 2nd most bp, 3.1% failed QC
  * FastQC: seq length 31-100, seq. length distribution flagged, failed Kmer content, everything else looks good
* Metadata from this project

#### 4. Permafrost_Russia
ProjectID: mgp7176
* Sample1: mgm4546812.3; fastq file, has the most bp (tied with Sample2), 12% failed QC
  * *NOTE: Failed to process file Permafrost_Russia_mgm4546812.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: Ran out of data in the middle of a fastq entry.  Your file is probably truncated* <-- file is 22G
  * downloading file again
  * second download: 53G file: FastQC: seq length 100, per base seq. qual. not very good after 80, failed Kmer content, everything else looks good
* Sample2: mgm4546813.3; fastq file, has the most bp (tied with Sample1), 15% failed QC
  * FastQC: seq length 100, Sanger/Illumina 1.9, failed per base seq quality, failed Kmer content, everything else looks good
* Metadata from this project

#### 5. Iowa_prairie
ProjectID: mgp6377
* Sample1: mgm4539575.3; fastq file, has the most bp, 14% failed QC
  * FastQC: seq length 33-100, flagged per tile seq. qual., everything else looks good
* Sample2: mgm4539572.3; fastq file, has the 2nd most bp, 14% failed QC
  * FastQC: seq length 33-100, looks good
* Metadata from this project

#### 6. Brazilian_forest
ProjectID: mgp3731
* Sample1: mgm4546395.3; fastq file, has the most bp, 7% failed QC
  * FastQC: seq length 150-292, failed per base sequence quality, flagged per tile seq. quality, failed per base seq. content, flagged Kmer content
* Sample2: mgm4536139.3; fast1 file, has the 2nd most bp, 9% failed QC
  * FastQC: seq length 150-292, failed per base seq quality, per seq. qual. score peak ~21, failed per base seq. content, failed Kmer content
* Metadata from this project

#### 7. Illinois_soybean
ProjectID: mgp2076
* Sample1: mgm4502542.3; fastq file, has the most bp, 26% failed QC
  * FastQC: seq length 100, Sanger/Illumina 1.9, per base seq. qual not good from 75-100, per base seq. content not very good below 10
* Sample2: mgm4502540.3; fastq file, has the 2nd most bp, 11% failed QC
  * FastQC: seq length 100, Sanger/Illumina 1.9, bad per base seq. qual. 80-100, per base seq. content not very good below 12, everything else looks good
* Metadata from this project

#### 8. Minnesota_creek
ProjectID: mgp5588
* Sample1: mgm4541646.3; fastq file, has the most bp, 2.55% failed QC
  * FastQC: seq length 151, Sanger/Illumina 1.9, per base seq qual not good above 140, per base seq. content not very good below 9
* Sample2:mgm4541645.3; fastq file, has the 2nd most bp, 2.58% failed QC
  * FastQC: seq length 151, Sanger/Ilumina 1.9, per base sequence qual. not good above 140, per base seq. content not very good below 9, failed Kmer content
* Metadata from this project

#### 9. Disney_preserve
ProjectID: mgp13948
* Sample1: mgm4664918.3; fastq file, most bp, .05% failed QC
  * first download didn't work, downloading again
  * Second dowload: FastQC: seq length 12-190, failed per tile seq quality, per base seq content not very good below 10, everything else looks good
* Sample2: mgm4664925.3; fastq file, 2nd most bp, 
  * FastQC: seq. length 12-190, failed per tile sequence qual., per base sequence content not very good from 1-8
* Metadata from this project

#### 10. California_grassland
ProjectID: mgp1992
* Sample1: mgm4511061.3; fastq file, most bp, 19% failed QC
  * NOTE: *Failed to process file California_grassland_4511061.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: Ran out of data in the middle of a fastq entry.  Your file is probably truncated* <-- file is 5.4G
  * downloading file again
  * second download: 29G; FastQC: seq length: 100, Sanger/Illumina 1.9, per base seq qual not very good after 85, flagged per base sequence content, failed per sequence GC content, everything else looks good
* Sample2: mgm4511115.3; fastq file, 2nd most bp, 10% failed QC
  * FastQC: seq length: 100, Sanger/Illumina 1.9, Per base sequence quality not very good from position ~70-100, flag on per base sequence content, failed per sequence GC content, failed Kmer content
* Metadata from this project

#### 11. Illinois_soil
ProjectID: mgp14596
* Sample1: mgm4653791.3; fastq file, most bp, .05% failed QC
  * FastQC: seq. length 12-190, Sanger/Illumina 1.9, per base seq. content not very good below 9 and above 160, everything else looks good
* Sample2: mgm4653788.3; fastq file, 2nd most bp, .06% failed QC
  * FastQC: seq length: 12-190, Sanger/Illumina 1.9, seq. length 12-190, per base seq. content not very good below position 9, everything else looks good
* Metadata for this project

#### 12. Wyoming_soil
ProjectID: mgp15600
* Sample1: mgm4670122.3; fastq file, most bp, 6% failed QC
  * FastQC: seq length: 151, Sanger/Illumina 1.9, per base sequence count is a little skewed from position 1-8, everything else looks good
* Sample2: mgm4670120.3; fastq file, 2nd most bp, 6% failed QC
  * File was too small, downloading again
  * FastQC: seq length: 151, Sanger/Illumina 1.9, per base seq content not very good below 10, everything else looks good
* Metadata for this project

#### 13. Permafrost_Canada
ProjectID: mgp252
* Sample1: mgm4523778.3; fastq file, most bp, 8% failed QC
  * Files too small, downloading again
  * second download: 12K
  * #### NOTE: *Failed to process Permafrost_Canada_4523778.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*
* Sample2: mgm4523023.3; fastq file, 2nd most bp, 10% failed QC
  * Files too small, downloading again
  * Second download: 16G
  * FastQC: seq length: 102-192, Sanger/Illumina 1.9, failed per tile seq quality, per base seq. content bad below 20, flagged seq length distribution, failed Kmer content
* Metadata for this project

#### 14. Permafrost_USA 
ProjectID: mgp11953
* Sample1: mgm4469340.3; fq file, 2nd most bp in project (samplew ith most bp is fna format), 5% failed QC
  * #### NOTE: *Failed to process Permafrost_USA_4469340.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*
* Sample2: mgm4470009.3; fq file, 6th most bp, 0% failed QC
  * #### NOTE: *Failed to process Permafrost_USA_4470009.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*
* Metadata for this project

#### Note: Contaminated_Canada files are all in fna format, so I did not download
ProjectID: mgp79868

#### Note: Contaminated_China file is in fna format, so I did not download
ProjectID: mgp13736

#### Commands:
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
To run FastX, first download FastX using `module load FASTX/0.0.14` then get the quality stats using `fastx_quality_stats -i IowaCorn_4539522.3.fastq -o IowaCorn_4539522.3_quality.txt`. The -i preceeds the input and the -o preceeds the output filename. Use fast_quality_filter to trim the data using -Q64 (Illumina 1.5), -q 30 (minimum quality to keep), -p 50 (minimum percent of bases to have the -q quality), and -z (compress output to zipped file): 
```
fastq_quality_filter -Q 64 -q 30 -p 50 -i IowaCorn_4539522.3.fastq | gzip -9c > IowaCorn_4539522.3.qc.fastq.gz
```
*Note: found undocumented info on -Q: http://seqanswers.com/forums/showthread.php?t=9357: "Yeah, I found out about that -Q parameter on SEQanswers, it's "undocumented" in the Fastx toolkit. If the quality scores for your libraries are in the fastq sanger format (ascii(phred+33)), rather than the fastq illumina format (ascii(phred+64)), you would use the -Q33 parameter. fastq_quality_filter automatically assumes fastq illumina quality scores. See here for original explanation: http://seqanswers.com/forums/showthread.php?t=6701"*
