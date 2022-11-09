#!/bin/bash
id=$1
fastqs=$2
species=$3
sample=$4
image=$5
slide_SN=$6
area=$7
output=$8

cd $output

if [ ${species} = "human" ];then
	transcriptome=/data1/reference/cellranger/spatial/refdata-gex-GRCh38-2020-A
elif [ ${species} = "mouse" ];then
	transcriptome=/data1/reference/cellranger/spatial/refdata-gex-mm10-2020-A
else
	echo " the specie" ${species} "doesn\'t included !" 
fi
spaceranger=/data1/software/spaceranger-1.3.1/bin/spaceranger
$spaceranger count --id=cellranger_out_${id} \
		--transcriptome=${transcriptome} \
		--fastqs=${fastqs} \
		--sample=${sample} \
		--image=${image} \
		--slide=${slide_SN} \
		--area=${area} 
