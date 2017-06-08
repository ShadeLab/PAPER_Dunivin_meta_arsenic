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
* [Permafrost_USA](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#14-permafrost_usa)
* [Workflow](https://github.com/ShadeLab/meta_arsenic/blob/master/Yeh_Notes.md#commands)

These are the files I am downloading from MG-RAST and performing FastQC and FastX on:
#### 1. Iowa_corn
[ProjectID: mgp6368](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp6368)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539522.3): mgm4539522.3;  fastq file, has the 2nd bp in the project (the file with the most bp is not in fastq format), less than 30% failed QC; 8,298,450,011 bp, 19G
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
  * fastx: used -Q64 flag(Illumina 1.5)
  * 8,298,450,011 bp -- good
  * MicrobeCensus: average_genome_size:    5,248,659.14022;
total_bases:    8,192,645,322;
genome_equivalents:     1560.90252827

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539523.3): mgm4539523.3;   fastq file, has the 3rd most bp in the project, 13% failed QC; 8,223,202,056 bp, 19G
  * FastQC: Sequence length 31-100, Illumina 1.5, failed Kmer, everything else looks good
  * fastx: used -Q64 flag
  * 8,223,202,056 bases in downloaded file -- good
  * MicrobeCensus: average_genome_size:    5,208,064.83522;
total_bases:    8,119,063,902;
genome_equivalents:     1558.94063513
* Metadata from this project

#### 2. Iowa_agricultural
[ProjectID: mgp2592](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp2592)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4509400.3): mgm4509400.3; fastq file, has the most bp, 23% failed QC; 28,875,056,044 bp, 71G
  * FastQC: seq length: 101, Sanger/Illumina 1.9, failed per base sequence quality, everything else looks good
  * fastx: used -Q33 (Illumina 1.9)
  * MicrobeCensus: average_genome_size: 6,203,490.57042;
total_bases:    24,978,407,768;
genome_equivalents:     4026.50854136

* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4509401.3): mgm4509401.3; fastq file, has the 3rd most bp (the data with 2nd most bp has a failed QC of 38% so it is not used), 11% failed QC; 8,831,209,922 bp, 22G
  * FastQC: seq length 101, Sanger/Illumina 1.9, per base seq qaulity failed, per base seq content not very good below 9, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * MicrobeCensus: average_genome_size: 6,023,548.5101; total_bases: 7,858,262,277; genome_equivalents: 1304.59018697
* Metadata from this project

#### 3. Mangrove
[ProjectID: mgp11628](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp11628)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4603402.3): mgm4603402.3; fastq file, has the most bp, 3.65% failed QC; 55G; 25,815,320,787 bp
  * FastQC: seq length 151-291, Sanger/Illumina 1.9, has some Universal Illumina Adaptor, failed Kmer content
  * the output from `fastx_quality_stats -i Mangrove_4603402.3.fastq -o Mangrove_4603402.3_quality.txt` was of size 0, so i deleted it and ran the command again
  * fastX: used flag -Q33 (Illumina 1.9)
  * MicrobeCensus: average_genome_size:    5,979,725.46729;
total_bases:    24,378,385,485;
genome_equivalents:     4076.84025268
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4603270.3): mgm4603270.3; fastq file, has the 2nd most bp, 3.1% failed QC; 19G; 25,267,542,871 bp
  * FastQC: seq length 31-100, seq. length distribution flagged, failed Kmer content, everything else looks good
  * fastX: used flag -Q33 (Illumina 1.9)
* Metadata from this project

#### 4. Permafrost_Russia
[ProjectID: mgp7176](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp7176)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546812.3): mgm4546812.3; fastq file, has the most bp (tied with Sample2), 12% failed QC; 21,951,850,400 bp, 53G
  * *NOTE: Failed to process file Permafrost_Russia_mgm4546812.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: Ran out of data in the middle of a fastq entry.  Your file is probably truncated* <-- file is 22G
  * downloading file again
  * second download: 53G file: FastQC: seq length 100, per base seq. qual. not very good after 80, failed Kmer content, everything else looks good
  * FastX: used -Q33 flag (Illumina 1.9)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546813.3): mgm4546813.3; fastq file, has the most bp (tied with Sample1), 15% failed QC; 21,951,850,400 bp, 53G
  * FastQC: seq length 100, Sanger/Illumina 1.9, failed per base seq quality, failed Kmer content, everything else looks good
  * FastX: used -Q33 flag (Illumina 1.9)
* Metadata from this project

#### 5. Iowa_prairie
[ProjectID: mgp6377](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp6377)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539575.3): mgm4539575.3; fastq file, has the most bp, 14% failed QC; 19,954,890,565 bp, 44G
  * FastQC: seq length 33-100,Illumina 1.5 flagged per tile seq. qual., everything else looks good
  * FastX: used -Q64 flag (Illumina 1.5)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4539572.3): mgm4539572.3; fastq file, has the 2nd most bp, 14% failed QC; 18,724,092,302 bp, 41G
  * FastQC: seq length 33-100, looks good
  * FastX: used -Q64 flag (Illumina 1.5)
* Metadata from this project

#### 6. Brazilian_forest
[ProjectID: mgp3731](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp3731)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4546395.3): mgm4546395.3; fastq file, has the most bp, 7% failed QC; 17,999,861,638 bp, 39G
  * FastQC: seq length 150-292, Illumina 1.5, failed per base sequence quality, flagged per tile seq. quality, failed per base seq. content, flagged Kmer content
  * FastX: used flag -Q64 (Illumina 1.5)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4536139.3): mgm4536139.3; fast1 file, has the 2nd most bp, 9% failed QC; 17,631,239,942 bp, 38G
  * FastQC: seq length 150-292, failed per base seq quality, per seq. qual. score peak ~21, failed per base seq. content, failed Kmer content
  * FastX: used flag -Q64 (Illumina 1.5)
* Metadata from this project

#### 7. Illinois_soybean
[ProjectID: mgp2076](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp2076)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4502542.3): mgm4502542.3; fastq file, has the most bp, 26% failed QC; 13,345,395,200 bp, 33G
  * FastQC: seq length 100, Sanger/Illumina 1.9, per base seq. qual not good from 75-100, per base seq. content not very good below 10
  * FastX: used flag -Q33 (Illumina 1.9)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4502540.3): mgm4502540.3; fastq file, has the 2nd most bp, 11% failed QC; 11,312,148,300 bp, 28G
  * FastQC: seq length 100, Sanger/Illumina 1.9, bad per base seq. qual. 80-100, per base seq. content not very good below 12, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
* Metadata from this project

#### 8. Minnesota_creek
[ProjectID: mgp5588](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp5588)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4541646.3): mgm4541646.3; fastq file, has the most bp, 2.55% failed QC; 11,702,083,089 bp, 27G
  * FastQC: seq length 151, Sanger/Illumina 1.9, per base seq qual not good above 140, per base seq. content not very good below 9
  * FastX: used flag -Q33 (Illumina 1.9)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4541645.3): mgm4541645.3; fastq file, has the 2nd most bp, 2.58% failed QC; 10,745,529,044 bp, 25G
  * FastQC: seq length 151, Sanger/Ilumina 1.9, per base sequence qual. not good above 140, per base seq. content not very good below 9, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
* Metadata from this project

#### 9. Disney_preserve
[ProjectID: mgp13948](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp13948)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4664918.3): mgm4664918.3; fastq file, most bp, .05% failed QC; 11,665,934,500 bp, 26G
  * FastQC: seq length 12-190, Illumina 1.9, failed per tile seq quality, per base seq content not very good below 10, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * 11,665,934,500 bp in downloaded file -- good, matches what is stated on MG-RAST
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4664925.3): mgm4664925.3; fastq file, 2nd most bp, .04% failed QC; 4,319,683,800 bp, 9.6G
  * FastQC: seq. length 12-190, failed per tile sequence qual., per base sequence content not very good from 1-8
  * FastX: used flag -Q33 (Illumina 1.9)
  * 4,319,683,800 bp -- good, this matches!
* Metadata from this project

#### 10. California_grassland
[ProjectID: mgp1992](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp1992)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511061.3): mgm4511061.3; fastq file, most bp, 19% failed QC; 11,650,135,800 bp, 29G
  * NOTE: *Failed to process file California_grassland_4511061.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: Ran out of data in the middle of a fastq entry.  Your file is probably truncated* <-- file is 5.4G
  * downloading file again
  * second download: 29G; FastQC: seq length: 100, Sanger/Illumina 1.9, per base seq qual not very good after 85, flagged per base sequence content, failed per sequence GC content, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4511115.3): mgm4511115.3; fastq file, 2nd most bp, 10% failed QC; 7,009,796,000 bp, 1.9G
  * FastQC: seq length: 100, Sanger/Illumina 1.9, Per base sequence quality not very good from position ~70-100, flag on per base sequence content, failed per sequence GC content, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
  * June 7: File size seems too small, I am downloading again under name "California_grassland_4511115.3_new.fastq"
    * The new download is 18G. The first download must not have finished for some reason. The job script did not abort so I don't know why it did't download all the way. I will scratch the files from the first download and re-do fastQC and fastX for this new download
* Metadata from this project

#### 11. Illinois_soil
[ProjectID: mgp14596](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp14596)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4653791.3): mgm4653791.3; fastq file, most bp, .05% failed QC; 8,078,926,770 bp, 18G
  * FastQC: seq. length 12-190, Sanger/Illumina 1.9, per base seq. content not very good below 9 and above 160, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4653788.3): mgm4653788.3; fastq file, 2nd most bp, .06% failed QC; 7,255,603,912 bp, 16G
  * FastQC: seq length: 12-190, Sanger/Illumina 1.9, seq. length 12-190, per base seq. content not very good below position 9, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
* Metadata for this project

#### 12. Wyoming_soil
[ProjectID: mgp15600](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp15600)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4670122.3): mgm4670122.3; fastq file, most bp, 6% failed QC; 7,678,885,748 bp, 2.0G
  * FastQC: seq length: 151, Sanger/Illumina 1.9, per base sequence count is a little skewed from position 1-8, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
  * June 7: File size seems to small, I am downloading again with command `curl "http://api.metagenomics.anl.gov/1/download/mgm4670122.3?file=050.1" > Wyoming_soil_4670122.3_new.fastq`
    * The new download is 18G. The first download must not have finished for some reason. The job script did not abort so I don't know why it did't download all the way. I will scratch the files from the first download and re-do fastQC and fastX for this new download
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4670120.3): mgm4670120.3; fastq file, 2nd most bp, 6% failed QC; 7,003,222,356 bp, 16G
  * File was too small, downloading again
  * FastQC: seq length: 151, Sanger/Illumina 1.9, per base seq content not very good below 10, everything else looks good
  * FastX: used flag -Q33 (Illumina 1.9)
* Metadata for this project

#### 13. Permafrost_Canada
[ProjectID: mgp252](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp252)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523778.3): mgm4523778.3; fastq file, most bp, 8% failed QC; 7,078,859,018 bp, 12K
  * Files too small, downloading again
  * second download: 12K
  * #### NOTE: *Failed to process Permafrost_Canada_4523778.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*
  * didnt do FastX
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523023.3): mgm4523023.3; fastq file, 2nd most bp, 10% failed QC; 6,700,261,439 bp, 16G
  * Files too small, downloading again
  * Second download: 16G
  * FastQC: seq length: 102-192, Sanger/Illumina 1.9, failed per tile seq quality, per base seq. content bad below 20, flagged seq length distribution, failed Kmer content
  * Submitted a job for only this file to run fastq_quality_filter and it's walltime of 1 hour expired (only 3.6G of the output was made)... submitted a new job with longer walltime
  * FastX: used flag -Q33 (Illumina 1.9)
* [Sample 3](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4523145.3) (because Sample 1 didnt work with FastQC): mgm4523145.3; fastq file, third most bp, 17% failed QC; 5,614,599,082 bp, 13G
  * FastQC: seq length 102-192, Sanger/Illumina 1.9, per base seq content bad below 20, failed per seq GC content, flaggd seq length distribution, failed Kmer content
  * FastX: used flag -Q33 (Illumina 1.9)
* Metadata for this project

#### 14. Permafrost_USA 
[ProjectID: mgp11953](http://metagenomics.anl.gov/mgmain.html?mgpage=project&project=mgp11953)
* [Sample1](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4469340.3): mgm4469340.3; fq file, 2nd most bp in project (samplew ith most bp is fna format), 5% failed QC; 8,421,304,260 bp, 9.6G
  * #### NOTE: *Failed to process Permafrost_USA_4469340.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*
  * downloading again... second download had same problem
  * didnt do FastX
* [Sample2](http://metagenomics.anl.gov/mgmain.html?mgpage=overview&metagenome=mgm4470009.3): mgm4470009.3; fq file, 6th most bp, 0% failed QC; 4,667,382,870 bp, 5.4G
  * #### NOTE: *Failed to process Permafrost_USA_4470009.3.fastq uk.ac.babraham.FastQC.Sequence.SequenceFormatException: ID line didn't start with '@'*
  * downloading again... second download had same problem
  * didnt do FastX
* Metadata for this project

#### Note: Contaminated_Canada files are all in fna format, so I did not download
ProjectID: mgp79868

#### Note: Contaminated_China file is in fna format, so I did not download
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
#PBS -M susanna.yeh@gmail.com
#PBS -m abe
#PBS -N IowaAgCensus

cd /mnt/research/ShadeLab/WorkingSpace/Yeh/myPy2/bin

module load NumPy
module load SciPy
module load Biopython
source /mnt/research/ShadeLab/WorkingSpace/Yeh/myPy2/bin/activate

python run_microbe_census.py /mnt/scratch/f0002188/MG-RAST_samples/Iowa_agricultural_4509400.3.qc.fastq.gz Iowa_agricultural_4509
400.3_census

python run_microbe_census.py /mnt/scratch/f0002188/MG-RAST_samples/Iowa_agricultural_4509401.3.qc.fastq.gz Iowa_agricultural_4509
401.3_census
```
