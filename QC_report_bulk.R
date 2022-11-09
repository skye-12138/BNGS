#!/usr/bin/Rscript
#.libPaths(c("/home/JiangMH/doc/Rlibrary4.0", .libPaths()))
args <- commandArgs(trailingOnly = TRUE)
dir_out=args[1]
name_out=args[2]
files_meta=args[3]
files_meta2=args[4]
dir_qc=args[5]
dir_qc_fastq=args[6]
zip=args[7]

library("platform")
report_bulk(dir_out=dir_out, name_out = name_out,files_meta=files_meta, files_meta2=files_meta2,dir_qc=dir_qc, dir_qc_fastq=dir_qc_fastq,zip=zip)
