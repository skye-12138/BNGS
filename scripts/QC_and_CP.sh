#!/bin/bash
prj_ID=$1
step=$2  ##cp or qc
selected_PI=$3
##prj_ID, like 220819_NHZY_1_fq, only have the first 2 character, 220819_NHZY
meta=/data1/src/10Xexperimet_record.csv
inputdir=/data1/seq_data_out/
ftp=/data3/file/
timeid=$(echo $prj_ID | cut -d "_" -f 1)
for i in $(ls -d ${inputdir}${prj_ID}*/data/*) 
do
	PI=$(echo $i |cut -d "/" -f 6)
	if [ ! -d ${ftp}${PI}_${timeid} ];then
		mkdir ${ftp}${PI}_${timeid}
	fi
	ppod=$(echo $i | cut -d "/" -f 1,2,3,4)
	sampleid=$(ls $i | cut -b 3-10 |uniq -)
	for sampleidd in $sampleid
	do
		if [ ! -d ${ftp}${PI}_${timeid}/${sampleidd} ];then
                	mkdir ${ftp}${PI}_${timeid}/${sampleidd}
        	fi
		if [ ! -d ${ftp}${PI}_${timeid}/${sampleidd}/data ];then
                        mkdir ${ftp}${PI}_${timeid}/${sampleidd}/data
		fi
		if [ ! -d ${ftp}${PI}_${timeid}/${sampleidd}/out ];then
                        mkdir ${ftp}${PI}_${timeid}/${sampleidd}/out
                fi
		if [ ! -d ${ftp}${PI}_${timeid}/${sampleidd}/QC ];then
                        mkdir ${ftp}${PI}_${timeid}/${sampleidd}/QC
			chmod 777 ${ftp}${PI}_${timeid}/${sampleidd}/QC
                fi
		if [ $step == "cp" ];then
			results=$(echo ${selected_PI} | grep ${PI} )
			if [[ $results != "" ]];then
				echo "begin to copy raw data of  " $sampleidd
				cp -fLr ${i}/*${sampleidd}* ${ftp}${PI}_${timeid}/${sampleidd}/data
				echo "raw data is done " $sampleidd
				echo "begin to copy out data of " $sampleidd	
				cp -fr ${ppod}/out/${PI}/* ${ftp}${PI}_${timeid}/${sampleidd}/out
				echo "the copy of processiong data is done" $sampleidd
			fi
		elif [ $step == "qc" ];then
			results=$(echo ${selected_PI} | grep ${PI} )
			if [[ $results != "" ]];then
				if [ ! -e ${ftp}${PI}_${timeid}/${sampleidd}/QC/${PI}_${timeid}_${sampleidd}.csv ];then
					## in this step, we delete some specific columns, not showing to labs
					cat $meta | head -n 1 | cut -d "," -f 1-3,9-18,20-25 >${ftp}${PI}_${timeid}/${sampleidd}/QC/${PI}_${timeid}_${sampleidd}.csv  
				fi
				for samplefullpath in $(ls -d ${i}/*${sampleidd}*)
				do
					samplefullid=$(echo $samplefullpath | cut -d "/" -f 7)
					cat $meta | cut -d "," -f 1-3,9-18,20-25 | grep $samplefullid >> ${ftp}${PI}_${timeid}/${sampleidd}/QC/${PI}_${timeid}_${sampleidd}.csv
					if [[ ${samplefullid:0:2} == "TF" ]] || [[ ${samplefullid:0:2} == "TX" ]] || [[ ${samplefullid:0:2} == "BC" ]] || [[ ${samplefullid:0:2} == "TC" ]];then
						mkdir ${ftp}${PI}_${timeid}/${sampleidd}/QC/report_sc
						chmod 777 ${ftp}${PI}_${timeid}/${sampleidd}/QC/report_sc
					#echo "cp cellranger websummary of " $samplefullid
					#cp -f ${ppod}/out/${PI}/*${samplefullid}*/outs/web_summary.html ${ftp}${PI}_${timeid}/${sampleidd}/QC/material/${samplefullid}_web_summary.html
						/home/wury/Download/biosoft/miniconda3/envs/report/bin/Rscript /home/wury/src/QC_report_sc.R ${ftp}${PI}_${timeid}/${sampleidd}/QC/report_sc ${PI}_${timeid}_${sampleidd}_QC_sc.html /data1/seq_data_out/${prj_ID}/out/${PI} /data2/pingtai/lib_QC False  
					elif [[ ${samplefullid:0:2} == "MS" ]] || [[ ${samplefullid:0:2} == "SC" ]];then
						echo "do fastqc on " $samplefullid
						mkdir ${ftp}${PI}_${timeid}/${sampleidd}/QC/material_bulk
						chmod 777 ${ftp}${PI}_${timeid}/${sampleidd}/QC/material_bulk
						mkdir ${ftp}${PI}_${timeid}/${sampleidd}/QC/report_bulk
						chmod 777 ${ftp}${PI}_${timeid}/${sampleidd}/QC/report_bulk
						fastqc ${ppod}/data/${PI}/${samplefullid}/*gz -o ${ftp}${PI}_${timeid}/${sampleidd}/QC/material_bulk 
						/home/wury/Download/biosoft/miniconda3/envs/report/bin/Rscript /home/wury/src/QC_report_bulk.R ${ftp}${PI}_${timeid}/${sampleidd}/QC/report_bulk ${PI}_${timeid}_${sampleidd}_QC_bulk.html /data1/seq_data_fq/${prj_ID}/${prj_ID}_meta.csv ${ftp}${PI}_${timeid}/${sampleidd}/QC/${PI}_${timeid}_${sampleidd}.csv /data2/pingtai/lib_QC ${ftp}${PI}_${timeid}/${sampleidd}/QC/material_bulk False
					
					elif [[ ${samplefullid:0:2} == "TT" ]];then
						continue
					fi
				done
			fi		 
		fi			
	done
done
	
