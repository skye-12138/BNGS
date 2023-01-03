this directory containing the scripts used for single cell RNAseq data analysis, the main programming lauguage is R, so we use Seurat as our main tool.

the pipeline could be divided into the following part

# 1. QC
# 2. integration(for multiple samples)
There are many ways for us to perform integration on multi-samples. we can integrate samples by just combinning them together without remove batch or using integration methods like Seurat integration or harmony to remove batches from different data.

There are no perfect methods in this section

So we suggest that if samples are homogenesis (like all samples are CRC tumor and from the same data source), we can use methods without remove batch effect, if samples are almost homogenesis (all samples from the same tiissue, some are tumor, some are adjacent tissue), we usually use Harmony to remove batch from tumor to adjacent tissue. if the samples are heterogenesis, we believe that seurat integration have the enough power to remove batch better.

the scripts used for different integration are listed in integration section.

# 3. reduct dimension and clustering
# 4. annotation
# 5. basic description of scRNAseq data (marker plot, cell ratio)
# 6. pathway analysis 
# 7. cnv analysis 
# 8. trajectory analysise 
