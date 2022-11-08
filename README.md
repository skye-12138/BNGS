# BNGS (Big NGS)
This is a repository containing scripts used for dealing with Big NGS data. In these scripts, I used some string manipulation strategies along with shell pipe to pre-processing multiple data in one line. By using these scripts and following the standerd rules, it is easy to get different analysis output of different data.

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
the date we send our sample to do sequencing, (could also changed to any 4-digit numbers )
- **CJ**  
we use these characters to present the lab, and we have a whole lab abbreviation table to make us easilly classify each sample data to to different lab 
- **HY**  
The name of the person who generate the sample,also used for identifing the sample
- **1**   
number used for indexing

## Structure

<img width="907" alt="image" src="https://user-images.githubusercontent.com/49186667/200536989-20f1bac0-d845-4569-ba62-3b7d8c792287.png">

**date_company_fq** represent the [prj_ID] below, we use sequencing date, and company abbrivation with _fq as unique [prj_ID]


## Requirements
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

- feature tag table for Totalseq demux

| id | name | read | pattern| sequence| feature_type |
| -- | ---- | ---- | ------ | ------- | ------------ |
| Bh_tag1 | B0251 anti-human Hashtag 1 | R2 | 5PNNNNNNNNNN(BC)NNNNNNNNN | GTCAACTCTTTAGCG | Antibody Capture |
| Bh_tag2 | B0252 anti-human Hashtag 2 | R2 | 5PNNNNNNNNNN(BC)NNNNNNNNN | TGATGGCCTATTGGG | Antibody Capture |

All the tag information can be found in 10X and biolengend (find sequence)


## Usage 

``` pipeline.sh [pri_ID] [regress_ID] ```

The [regress_ID] could be lab name or sample ID, and if there are many sample or lab does't need a preprocessing step, just add it behind, like regressID1regressID2regressID3


## Caution 
This version used a lot of loop to process the data, it does't use any paralelle processing management，if the server has high memory and multiple CPUs it could be inefficient. In most cases, we dealing with 1-2 projects in different server, each projects contain 1-2 lane data from Novaseq 6000. Using these scripts is enough to get the results in time. If you need a more efficient version [cumulus](https://github.com/klarman-cell-observatory/cumulus) could help.





