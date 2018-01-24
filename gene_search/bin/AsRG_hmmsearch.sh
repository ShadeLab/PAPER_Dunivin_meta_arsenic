#!/bin/bash -login

## This script searches protein sequence data using HMMs of arsenic resistance genes
## This script does not involve assembly of arsenic resistance genes
## This overwrites previous search results

if [ $# -ne 2 ]; then
        echo "Requires two inputs : /path/hmmsearch_setenv.sh dataset"
        echo "  hmmsearch_setenv.sh is a file containing the parameter settings, requires absolute path."
        echo '  dataset should contain one or more protein sequence datasets to process with quotes around'
        echo 'Example command: /path/hmmsearch_setenv.sh "sequence1.faa sequence2.faa "'
        exit 1
fi

source $1
dataset=$2

for dataset in ${dataset}
	do 
		echo "### Search aa sequences ${dataset}"
		for gene in ${AsRG}
			do
			${HMMSEARCH} --cpu ${THREADS} -E ${evalue} -o ${WORKDIR}/${gene}.${dataset}.${evalue}.stdout.txt --domtblout ${WORKDIR}/${gene}.${dataset}.${evalue}.tbl.txt -A ${WORKDIR}/${gene}.${dataset}.${evalue}.alignment.txt ${REF_DIR}/gene_resource/${gene}/originaldata/${gene}.hmm ${SEQDIR}/${dataset} || { echo "hmmsearch failed for ${gene} in ${dataset}" ; continue; }
			if [[ -s ${WORKDIR}/${gene}.${dataset}.${evalue}.alignment.txt ]]; then 
                		echo "${gene} in ${dataset} was detected"
        		else
                		echo "${gene} ${dataset}" >> ${WORKDIR}/no_hits.txt
                		rm ${WORKDIR}/${gene}.${dataset}.*
			fi
		done
	done
