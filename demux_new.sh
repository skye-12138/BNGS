#!/bin/bash

prj_ID=$1
raw_directory=$2

bcl2fastq -R ${raw_directory} -o /data1/seq_data_fq/${prj_ID} --sample-sheet /data1/seq_data_fq/${prj_ID}/${prj_ID}.csv -r 20  -p 20 -w 20 --barcode-mismatches 0 --ignore-missing-filter --ignore-missing-positions --ignore-missing-bcls --ignore-missing-controls --no-bgzf-compression --use-bases-mask y151,i10,i10,y151 --fastq-compression-level 8 --no-lane-splitting  --interop-dir /data1/seq_data_fq/${prj_ID}/Interop
