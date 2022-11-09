#export PATH=$PATH:/public/home/server_mgmt/software/cellranger-3.1.0/cellranger-cs/3.1.0/bin
cellranger=/data2/pingtai/software/cellranger-6.0.1/bin/cellranger
ID=$1
input=$2
species=$3
output=$4
###############
ulimit -u 3000
#human or mouse or even modified ref
if [ $species = "mouse" ];then
        REF=/data2/pingtai/reference/refdata-cellranger-vdj-GRCm38-alts-ensembl-3.1.0/
elif [ $species = "human" ];then
        REF=/data2/ref/refdata-cellranger-vdj-GRCh38-alts-ensembl-4.0.0/
else
        echo "the input species is not included !!!!"
fi
#######ABCD/X
num=$(ls ${input}/*${ID}*gz |wc -l)
if [ $num = 8 ];then
        sample=${ID}A,${ID}B,${ID}C,${ID}D
elif [ $num = 2 ];then
        sample=${ID}X
else
        echo "the ID have wrong number of fastq files"
fi
###########BCR/TCR
if [ ${ID:0:2} = "BC" ];then
	chain="IG"
elif [ ${ID:0:2} = "TC" ];then
	chain="TR"
else
	echo "not BCR/TCR data"
fi

##
echo $REF
echo $chain
cd $output
$cellranger vdj --id=cellranger_out_$ID \
                 --reference=${REF}\
                 --fastqs=${input} \
                 --sample=$sample \
		 --chain=$chain \
		 --localcores=15 \
		 --localmem=100 \

rm -fr ${output}/cellranger_out_$ID/SC_RNA_COUNTER_CS

summary=$(cat ${output}/cellranger_out_$ID/outs/metrics_summary.csv |tail -n +2)
time=$(date "+%Y.%m.%d")
echo ${ID},${summary},${time}  >>/data1/BC_TC_summary.csv

cp ${output}/cellranger_out_$ID/outs/web_summary.html /data1/web_summary/${ID}_web_summary.html
