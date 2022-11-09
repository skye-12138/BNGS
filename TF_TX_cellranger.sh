#variables
ID=$1
input=$2
species=$3
output=$4
CORE=20
MEM=160
###########usage
#./.sh ${ID} ${input} mouse ${output}

##########
#cellranger=/data2/pingtai/software/cellranger-3.1.0/cellranger-cs/3.1.0/bin/cellranger
cellranger=/data2/pingtai/software/cellranger-6.0.1/bin/cellranger
#human or mouse or even modified ref
if [ $species = "mouse" ];then
	REF=/data2/pingtai/reference/refdata-cellranger-mm10-3.0.0
elif [ $species = "human" ];then
	REF=/data2/pingtai/reference/refdata-cellranger-GRCh38-3.0.0
else
	echo "the input species is not included !!!!"
fi
####################################################

#ulimit -n 16000 #generally cannot be modified for non root
ulimit -u 3000
#run cellranger count, some times you may want to modify the suffix A B C D to X or else.
#####judge ABCD/X
num=$(ls ${input}/*${ID}*gz |wc -l)
if [ $num = 8 ];then
	sample=${ID}A,${ID}B,${ID}C,${ID}D
elif [ $num = 2 ];then
	sample=${ID}X
else
	echo "the ID have wrong number of fastq files"
fi
cd ${output}
$cellranger count --id=cellranger_out_${ID} \
		--fastqs=${input} \
		--sample=${sample} \
                --transcriptome=${REF} \
                --localcores=${CORE} \
                --localmem=${MEM} \
		--r1-length=26 \

#remove this annoying folder with lots of small files
rm -rf ${output}/cellranger_out_${ID}/SC_RNA_COUNTER_CS

#remove bam to save space
#rm -rf cellranger_out_${ID}/outs/possorted_genome_bam.bam
summary=$(cat ${output}/cellranger_out_$ID/outs/metrics_summary.csv |tail -n +2)
time=$(date "+%Y.%m.%d")
if [ ${ID:0:2} = "TF" ];then
	echo ${ID},${summary},${time}  >>/data1/TF_summary.csv
else
	echo ${ID},${summary},${time}  >>/data1/TX_summary.csv
fi

cp ${output}/cellranger_out_$ID/outs/web_summary.html /data1/web_summary/${ID}_web_summary.html
