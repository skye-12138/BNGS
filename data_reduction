#!/bin/bash
newfile=$1
metadata=${newfile}_meta.csv

PI_ID=/data2/pingtai/src/PI_SII_ID.csv
#PI_ID=/data1/src/PI_SII_ID.csv
inputdir=/data1/seq_data_fq/
outputdir=/data1/seq_data_out/



mkdir ${outputdir}${newfile}
mkdir ${outputdir}${newfile}/data ${outputdir}${newfile}/out

input=${inputdir}${newfile}/
outdata=${outputdir}${newfile}/data/
out=${outputdir}${newfile}/out/
###extract meta information
sampleID=$(cat ${input}/${metadata} | tail -n +2 |awk -F"," '{print $1}')

#####group data by ID and PI
for i in $(echo ${sampleID})
do
###make PI directory
	PI_simple=$(echo ${i:6:2})
        PI=$(cat $PI_ID |grep $PI_simple |cut -d ',' -f 1)
        if [ ! -d ${outdata}${PI} ];then
                mkdir ${outdata}${PI}
        fi
####deliver data to dir
	if [[ ${i:0:2} = "MS" ]] || [[ ${i:0:2} = "SC" ]];then
		a=${i:0:10}
	fi
	n=$(echo ${i:0-1:1})
	if [ $n = "X" ];then
		a=${i:0:11}
		i=${i:0:11} 
	fi
	if [ ! -d ${outdata}${PI}/${a} ];then
		mkdir ${outdata}${PI}/${a}
	fi
	if [ ! -d ${input}lnk ];then
		ln -s ${input}/*${i}*.gz ${outdata}${PI}/${a}
	else
		mv ${input}lnk/*${i}*.gz ${outdata}${PI}/${a}
	fi
done

##########useage ./.sh 210413_MM_fq
 
cat ${input}/${metadata} | tail -n +2 >/data1/src/tmp.csv
while read LINE
do
time=$(date "+%Y.%m.%d")
echo ${newfile}","$LINE","$time>> /data1/meta.csv
done < /data1/src/tmp.csv
rm -fr /data1/src/tmp.csv


	
