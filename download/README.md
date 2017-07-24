I [downloaded metagenomes](https://github.com/ShadeLab/meta_arsenic/blob/master/download/download_notes.md) from MG-RAST.
Next I:
* Performed [FastQC](https://github.com/ShadeLab/meta_arsenic/blob/master/download/FastQC.md) to look at the quality
* Ran FastX to filter the data
    * 1. Download FastX using `module load FASTX/0.0.14`
    * 2. Get the quality stats using fastx_quality_stats
        * [Example qsub script](https://github.com/ShadeLab/meta_arsenic/blob/master/download/fastx1.qsub)
        * Location: /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/download_scripts/fastX
    * 3. Trim data using fast_quality_filter
        * [Example qsub script](https://github.com/ShadeLab/meta_arsenic/blob/master/download/fastxBrazilian.qsub)
        * Location: /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/download_scripts/fastX
    * 4. Get the quality stats of the trimmed output file is through `fastx_quality_stats`
        * [Example qsub script](https://github.com/ShadeLab/meta_arsenic/blob/master/download/qc_quality.qsub)
        * Location: /mnt/research/ShadeLab/WorkingSpace/Yeh/xander/download_scripts/fastX
* Counted the number of basepairs in the files
    * Example, Disney_preserve_4664918.3.fastq: `cat Disney_preserve_4664918.3.fastq | paste - - - - | cut -f2 | tr -d '\n'| wc -c`
* Used [MicrobeCensus](https://github.com/snayfach/MicrobeCensus) to estimate the average genome size for each metagenome
    * 1. [Set up a Python virtural environment](https://wiki.hpcc.msu.edu/display/hpccdocs/Using+Python+virtualenv+on+the+HPCC) 
    * 2. Download MicrobeCensus using `pip install MicrobeCensus`
    * 3. Run MicrobeCensus: [Example qsub script](https://github.com/ShadeLab/meta_arsenic/blob/master/download/census.qsub)
        * Location: /mnt/research/ShadeLab/WorkingSpace/Yeh/census
