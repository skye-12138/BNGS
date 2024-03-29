# BNGS (Big NGS)
This is a repository containing scripts used for dealing with Big NGS data. In these scripts, I used some string manipulation strategies along with shell pipe to pre-processing multiple data in one line. By using these scripts and following the standerd rules, it is easy to get different analysis output of different data types. And to benefit for platforms, I also write a script to sent data to ftp server directory according to different laboratory names.

## The scripts now support the following sequencing data analysis 
- single cell RNAseq (including transcriptome, BCR, TCR, totalseq)
- spatial RNAseq
- Bulk RNAseq (including smart_seq and bulk RNA seq)

## RULES
The sequencing data should follow the standard naming rules: \
  **TC2210CJHY1_S1_L001_R1.fastq.gz**  
-  **TC**  
the first 2 characters define the sample type, which could be TC(TCR), BC(BCR), ST(spatial transcriptome), TF(5' transcriptome), TX(3' transcriptome), TT(total seq tag), MS(bulk RNAseq)，SC(smart seq)

- **2210** \
The date we send our sample to do sequencing, (could also changed to any 4-digit numbers )

- **CJ**  
We use these characters to present the lab, and we have a whole lab abbreviation table to make us easilly classify each sample data to to different lab 

- **HY**  
The name of the person who generate the sample,also used for identifing the sample

- **1**   
Number used for indexing

Other part following rules of 10X

## Structure

### pre-processing server (/data1, in this case)

<img width="1186" alt="image" src="https://user-images.githubusercontent.com/49186667/200621085-350cbd93-c11b-437b-9983-01bb5da58010.png">


**date_company_fq** represents the [prj_ID] below, we use sequencing date, and company abbrivation with _fq as unique [prj_ID]

### deliver ftp server (/data3, in this case)
<img width="1315" alt="image" src="https://user-images.githubusercontent.com/49186667/200586656-276386c6-6454-49fe-8711-55ad477120fb.png">

The web_report is generated by [platform](https://github.com/mhjiang97/platform).


## Requirements

### for demuxing 
- [prj_ID].csv \
Sample sheet for bcl demuxing, following the standard sample sheet format in [bcl2fastq](https://support.illumina.com/content/dam/illumina-support/documents/documentation/software_documentation/bcl2fastq/bcl2fastq2-v2-20-software-guide-15051736-03.pdf)

### for pre-processing 
- [prj_ID]_meta.csv

| sample ID | Collaborator |   Lib_Type   |   Operator   |   Description1   | Description2 | Species | tag_area | SN |
| --------- | ------------ | ---- | ---- | ---- | ---- | --------- | --------- | --------- |
| ST2208ZSCR4X | Zhang_Shan | ST | ZM |      |      | human | A1 | V11D08-111 |
| TF2207LSHC2X | Li_Si | TF | LS |      |      | mouse |  |  |
 
**sample ID** and **species** is neccessary \
**tag_area** is applicable, when the data type is totalseq or spatial transcriptome. When data type is TT, write the tag ID using "_" to add multiple tags, the tag ID should consistent to the ID recorded in feature tag table. When the data type is ST, write the area information here, in 10X, it's A1,B1,C1 or D1. \
**SN** only applicable in ST data type, record the Serial Number

- lab abbreviation table

| PI         | SII_ID |
| --------- | ------------ |
| Zhang_Shan | ZS     |
| Li_Si      | LS     |

- feature tag table for Totalseq demux (applicable when there have totalseq data)

| id | name | read | pattern| sequence| feature_type |
| -- | ---- | ---- | ------ | ------- | ------------ |
| Bh_tag1 | B0251 anti-human Hashtag 1 | R2 | 5PNNNNNNNNNN(BC)NNNNNNNNN | GTCAACTCTTTAGCG | Antibody Capture |
| Bh_tag2 | B0252 anti-human Hashtag 2 | R2 | 5PNNNNNNNNNN(BC)NNNNNNNNN | TGATGGCCTATTGGG | Antibody Capture |

All the tag information can be found in 10X and biolengend (find sequence)

- ST_HE directory
 Containing HE images, name as [sampleID].jpeg or other suffix supported by spaceranger. 
 In spaceranger V1.3, the images should be adjusted to the right position by manually rotate the images, let the triangle corner in the left bottom and one side parallel to bottom side of the image.
 
 
### for deliver 
- experiment recording table \
A table containing all experiment information
The first column should be [sampleID] 

- quality control images directory \
Containing all cDNA and 2100 quality control images. 

## Usage 

### Step1 - demux sample from bcl data

```
demux_bcl.sh [prj_ID] [raw_directory] 
```
**[raw_directory]** should be the parent directory of *Data* 
**/data1/seq_data_fq/[prj_ID]/[prj_ID].csv** is the index file for demux
**--use-bases-mask** should be consistant with the fastq index. In our cases, it almost fixed to y151,i10,i10,y151


### Step2 - classify all fastq data into different lab directory 

Make a lnk directory in seq_data_fq/[prj_ID] containing all the fastq link files with proper name in that directory.

``` 
data_reduction.sh [prj_ID]
```


### Step3 - rum the main preprocessing step 

```
pipeline.sh [prj_ID] [regress_ID] 
```

The [regress_ID] could be [lab_name] or [sampleID], and if there are many sample or lab does't need a preprocessing step, just add it behind, like regressID1regressID2regressID3

### Step4 - deliver data to ftp server

``` 
    ## generate a qc report to ftp server
    QC_and_CP.sh [prj_ID] qc [lab_name]
    
    ## for cp selected group of data to ftp server
    QC_and_CP.sh [prj_ID] cp [lab_name]
    
```
[lab_name] should be the complete name in lab abbreviation table not the abbreviation name.



## Caution 
This version used a lot of loop to process the data, it does't use any paralelle processing management，if the server has high memory and multiple CPUs it could be inefficient. In most cases, we dealing with 1-2 projects in different server, each projects contain 1-2 lane data from Novaseq 6000. Using these scripts is enough to get the results in time. If you need a more efficient version [cumulus](https://github.com/klarman-cell-observatory/cumulus) could help.





