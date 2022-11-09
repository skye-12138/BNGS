fileID=$1
regressID=$2
data_reduction=/data1/src/data_reduction
TBC=/data1/src/TC_BC_cellranger.sh
TFX=/data1/src/TF_TX_cellranger.sh
modallname=/data1/src/modallname
bulkrna=/data1/src/bulk_RNAseq.sh
TT=/data1/src/TT_cellranger.sh
ST=/data1/src/ST_cellranger.sh
feature_ref=/data1/feature_ref.csv

input=/data1/seq_data_out/${fileID}/data/
output=/data1/seq_data_out/${fileID}/out/

meta=/data1/seq_data_fq/${fileID}/${fileID}_meta.csv

for i in $(ls -d ${input}*/*)
do
	PI=$(echo $i |awk -F"/" '{print $6}')
	ID=$(echo $i |awk -F"/" '{print $7}')
	if [[ $(echo $regressID |grep $ID) ]] || [[ $(echo $regressID |grep $PI) ]];then
		continue
	fi
	if [ ! -d ${output}${PI} ];then
		mkdir ${output}${PI}
	fi
	echo $ID
	#mkdir ${output}${PI}/${ID}
	type=${ID:0:2}
	species=$(cat $meta |grep ${ID}|cut -d "," -f 7 |uniq - )
	
#	if [ $(echo $regressID |grep $ID) ];then
#		echo "$ID is regressed"
#		time=$(date "+%Y.%m.%d")
#		echo ${fileID} ${PI} ${ID} ${time} >> unfinished.txt
#		continue
#	fi 
	if [[ $type = "MS" ]] || [[ $type = "SC" ]];then
		echo $ID
		echo ${input}${PI}/${ID}
		echo $species 
		echo ${output}${PI}
		$bulkrna $ID ${input}${PI}/${ID} $species ${output}${PI}
	elif [[ $type = "BC" ]] || [[ $type = "TC" ]];then
		$TBC $ID ${input}${PI}/${ID} $species ${output}${PI}
	elif [ $type = "ST" ];then
		area=$(cat $meta |grep ${ID}|cut -d "," -f 8 )
		SN=$(cat $meta |grep ${ID}|cut -d "," -f 9 )
		###specify the images path
		images=/data1/seq_data_fq/${fileID}/ST_HE_rotate/${ID}X.jpg
		$ST ${ID} ${input}${PI}/${ID} $species ${ID}X ${images} ${SN} ${area} ${output}${PI}
	elif [[ $type = "TF" ]] || [[ $type = "TX" ]];then
		ttfile=$(find /data1/seq_data_out -name TT${ID:2}*R1*gz)
		if [ ! $ttfile ];then 
			$TFX $ID ${input}${PI}/${ID} $species ${output}${PI}
		else
			echo "$ID is a total seq data" 
			mkdir ${output}${PI}/TT_${ID}
			echo "fastqs,sample,library_type" >> ${output}${PI}/TT_${ID}/TT_${ID}_Libraries.csv
			for line in $(ls $i/*R1*gz)
			do
				fastqs=$(echo $line |cut -d "/" -f 1,2,3,4,5,6,7)
                                sample=$(echo $line |cut -d "/" -f 8 |cut -d "_" -f 1 )
                                Library_type="Gene Expression"
				echo ${fastqs}","${sample}","$Library_type >> ${output}${PI}/TT_${ID}/TT_${ID}_Libraries.csv
			done
			for line in $ttfile
			do
				fastqs=$(echo $line |cut -d "/" -f 1,2,3,4,5,6,7)
				sample=$(echo $line |cut -d "/" -f 8 |cut -d "_" -f 1 )
				Library_type="Antibody Capture"
				echo ${fastqs}","${sample}","$Library_type >> ${output}${PI}/TT_${ID}/TT_${ID}_Libraries.csv
			done
		###generate reffile
			feature_type=$(cat $meta | grep TT${ID:2} | awk -F"," '{print $8}')
			OLD_IFS="$IFS"
                	IFS="-"
                	arr=($feature_type)
                	echo "id,name,read,pattern,sequence,feature_type" >${output}${PI}/TT_${ID}/TT_${ID}_feature_ref.csv
                	for feature in ${arr[@]}
                	do
                		echo $feature
				cat $feature_ref |grep $feature >>${output}${PI}/TT_${ID}/TT_${ID}_feature_ref.csv
                	done
                	IFS="$old_IFS"

			echo TT_$ID
			echo ${output}${PI}/TT_${ID}/TT_${ID}_Libraries.csv
			echo ${output}${PI}/TT_${ID}/TT_${ID}_feature_ref.csv
			echo $species
			echo ${output}${PI}

                	$TT TT_$ID ${output}${PI}/TT_${ID}/TT_${ID}_Libraries.csv ${output}${PI}/TT_${ID}/TT_${ID}_feature_ref.csv $species ${output}${PI}

		fi
	fi

done

