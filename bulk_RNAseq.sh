#tophat need bowtie in bin, export ...
#export PATH=$PATH:/public/software/bowtie2-2.2.6/
ID=$1
input=$2
species=$3
output=$4

mkdir ${output}/${ID}
output=${output}/${ID}
HISAT=/data2/pingtai/software/rnaseq/bin/hisat2
SAMTOOLS=/data2/pingtai/software/rnaseq/bin/samtools
PYTHON=/data2/pingtai/software/rnaseq/bin/python
#####mouse/human choose
if [ $species = "mouse" ];then
        SEQ=/data2/pingtai/reference/mus_tran/genome_tran
	ANNO=/data2/pingtai/reference/Mus_musculus.GRCm38.84.gtf
elif [ $species = "human" ];then
        SEQ=/data2/pingtai/reference/grch38_tran/genome_tran
	ANNO=/data2/pingtai/reference/Homo_sapiens.GRCh38.91.gtf
elif [ $species = "rnor" ];then
	SEQ=/data2/pingtai/reference/Rnor/Rnor_tran/genome_tran
	ANNO=/data2/pingtai/reference/Rnor/Rattus_norvegicus.Rnor_6.0.100.gtf
else
        echo "the input species is not included !!!!"
fi
#########################
##########################

META_FILE=${output}/meta.stat_${ID}

####for mingma RNAseq
READ_SUFFIX=.fastq.gz
TRIM3=30

rand=$RANDOM


#generate list of sample names
ls ${input}/*R1.fastq*|awk -F"/" '{print $NF}' |cut -d_ -f1 > ${output}/mylist
#generate sample name
#name=$(ls ${input}/${ID}/*R1.fastq*|awk -F"/" '{print $NF}' |cut -d_ -f1)
rm -rf $META_FILE
echo -e "Sample_ID\tFragIn\tMapped_pct\tConcord_pct\tMeanFragLen\tFragAccounted\tFragNoFeature\tFragAmbig" > $META_FILE

for name in $(cat ${output}/mylist)
do
echo $name
#run hisat
$HISAT -p 4 -3 $TRIM3 --summary-file ${output}/${name}.hisat_summary --new-summary -x $SEQ -1 ${input}/${name}*R1${READ_SUFFIX} -2 ${input}/${name}*R2${READ_SUFFIX}  | $SAMTOOLS view -Shb - | $SAMTOOLS sort -T ${output}/${name}_${rand} - > ${output}/${name}.sort.bam
$SAMTOOLS index ${output}/${name}.sort.bam
#run samtools to filter and sort bam
$SAMTOOLS view -h ${output}/${name}.sort.bam |grep -E '^\@|\bNH:i:1\b' | $SAMTOOLS view -Shb - | $SAMTOOLS sort -T ${output}/${name}_${rand} -n - > ${output}/${name}.uniq.nsort.bam
# new version use mapQ to filter >= 5 seems good
$SAMTOOLS view -q 5 -h ${output}/${name}.sort.bam | $SAMTOOLS view -Shb - | $SAMTOOLS sort -T ${output}/${name}_${rand} -n - > ${output}/${name}.uniq.nsort.bam
#run HTSeq
#$SAMTOOLS view ${i}.uniq.nsort.bam | python -m HTSeq.scripts.count--mode=union --stranded=reverse - $HUMAN_ANNO > ${i}.count.union.reverse
$SAMTOOLS view  ${output}/${name}.uniq.nsort.bam | $PYTHON -m HTSeq.scripts.count --mode=union --stranded=no - $ANNO > ${output}/${name}.count.union.no

PctMap=$(grep "Overall alignment rate" ${output}/${name}.hisat_summary | awk '{print $4}')
PctConc=$(grep "Aligned concordantly 1 time" ${output}/${name}.hisat_summary | awk '{print $6}'|sed 's/[()]//g')
AvgFragL=$($SAMTOOLS view ${output}/${name}.uniq.nsort.bam|awk '{if($9>0) print $9}'| awk '{n+=1;if($1>500) x+=500;else x+=$1} END {print x/n}')
FragIn=$(zcat ${input}/${name}*R1${READ_SUFFIX}|wc -l)
let "FragIn/=4"
Acc=$(cat ${output}/${name}.count.*| awk '{x+=$2} END {print x}')
NoFeat=$(cat ${output}/${name}.count.*|grep "no_feature" |cut -f2)
Ambig=$(cat ${output}/${name}.count.*|grep "ambiguous" |cut -f2)

echo -e "$i\t$FragIn\t$PctMap\t$PctConc\t$AvgFragL\t$Acc\t$NoFeat\t$Ambig" >> $META_FILE

done


