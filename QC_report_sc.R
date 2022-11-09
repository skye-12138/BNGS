#!/usr/bin/Rscript
#.libPaths(c("/home/JiangMH/doc/Rlibrary4.0", .libPaths()))
args <- commandArgs(trailingOnly = TRUE)
dir_out=args[1]
name_out=args[2]
dir_html=args[3]
dir_qc=args[4]
zip=args[5]

library("platform")
report_sc(dir_out=dir_out, name_out = name_out , dir_html=dir_html, dir_qc=dir_qc, zip=zip)
