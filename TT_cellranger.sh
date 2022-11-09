cellranger=/data2/pingtai/software/cellranger-3.1.0/cellranger-cs/3.1.0/bin/cellranger
ID=$1
library=$2
feature_ref=$3
species=$4
output=$5
#human or mouse or even modified ref
if [ $species = "mouse" ];then
        REF=/data2/pingtai/reference/refdata-cellranger-mm10-3.0.0/
elif [ $species = "human" ];then
        REF=/data2/pingtai/reference/refdata-cellranger-GRCh38-3.0.0/
else
        echo "the input species is not included !!!!"
fi
cd $output 
ulimit -u 3000
$cellranger count --id=cellranger_out_${ID} \
                --libraries=${library} \
                --transcriptome=${REF} \
                --feature-ref=${feature_ref} \
		--chemistry=auto \
		--nosecondary \
                --localcores=15 \
                --localmem=100 \

rm -rf ${output}/cellranger_out_${ID}/SC_RNA_COUNTER_CS

summary=$(cat ${output}/cellranger_out_$ID/outs/metrics_summary.csv |tail -n +2)
time=$(date "+%Y.%m.%d")
echo $ID","$summary","$time  >>/data1/TT_summary.csv
cp ${output}/cellranger_out_$ID/outs/web_summary.html /data1/web_summary/${ID}_web_summary.html
