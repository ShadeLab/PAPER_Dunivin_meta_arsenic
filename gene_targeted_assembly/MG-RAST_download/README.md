# MG-RAST download and quality filtering workflow

1. [Downloaded metagenomes](https://github.com/ShadeLab/meta_arsenic/blob/master/gene_targeted_assembly/MG-RAST_download/download_notes.md) from MG-RAST.
2. Run FastX to filter the data
* FastX version 0.0.14
* Get the quality stats using `fastx_quality_stats`
* Trim data using `fast_quality_filter`

```
fastq_quality_filter -Q64 -q 30 -p 50 -i ${SAMPLE}.fastq | gzip -9c > ${SAMPLE}.qc.fastq.gz
```        

* Check the quality stats of the trimmed output file is through `fastx_quality_stats`

```
fastx_quality_stats -i ${SAMPLE}.qc.fastq.gz -o ${SAMPLE}_qc_quality.txt
```

* Counted the number of basepairs in the files to see how much needed to be quality filtered
```
cat ${SAMPLE}.fastq | paste - - - - | cut -f2 | tr -d '\n'| wc -c
```