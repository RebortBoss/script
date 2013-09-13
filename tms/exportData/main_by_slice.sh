#!/bin/sh
bp=`dirname $0`
echo "\$1=$1 \$2=$2"
if [ -z "$1" ];then
   echo "每一个参数为空了.exit ... "
   exit 0;
fi;
if [ -z "$2" ];then
  echo "每二个参数为空了.exit ... "
  exit 0;
fi;
source $bp/oracle.profile
startDT=`date +'%Y%m%d%H%M%S'`
sdtmi=`date +'%s'`
LogIn=cp_tms/tms@tmsdb980_1
sh $bp/callData_by_slice.sh $@
curtDateStr=`date +'%Y%m%d'`
echo $curtDateStr
chour=`date +'%H'`
frNum=`expr $chour / 3 + 1`
echo "curt hour $chour == $frNum"
expLog=$bp/expLogslice.log
#cat $bp/text_next_dateslice.text
pd=$1
nd=$2
echo "pd=$pd"
echo "nd=$nd"
TMP_FILE=$bp/tmpslice.dat
sh $bp/test_slice.sh >$expLog
count=`tail -n 1 $expLog|cut -d' ' -f15`
if [ -z "$count" ];then
  count=`cat $TMP_FILE|wc -l`
  exit;
fi;

finlFileName="TMS01_${curtDateStr}_0${frNum}_${count}_${pd}_${nd}.TXT"
mv $TMP_FILE $bp/$finlFileName
echo "fileName is $finlFileName"
echo "$curtDateStr finish .... "

echo "$curtDateStr start  ...... " >> $bp/allExportLogslice.log
cat $expLog >>$bp/allExportLogslice.log
echo "$curtDateStr finish ...... " >> $bp/allExportLogslice.log
echo "===========" >>$bp/allExportLogslice.log
endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "start ${startDT} to ${endDT} export file finish,export file name ${finlFileName} cost ${cost}(s) Total Count ${count}"
sqlplus -S $LogIn <<EOF
insert into TMS_EXPORT_LOG(name,CURT_DATE,NEXT_DATE,start_exp_date,END_EXP_DATE,state,cnt,fre_num,file_name,costMI,qdate) VALUES ('hs',to_date('$pd','YYYYMMDDHH24MISS'),to_date('$nd','YYYYMMDDHH24MISS'),to_date('$startDT','YYYYMMDDHH24MISS'),to_date('$endDT','YYYYMMDDHH24MISS'),'finish',${count},'0${frNum}','$finlFileName',${cost},to_date('${curtDateStr}','YYYYMMDD'));
commit;
quit
EOF
ls -l $bp/$finlFileName 
#sh $bp/putFile.sh $bp/$finlFileName && rm -rf $bp/$finlFileName
sh $bp/putFile.sh $bp/$finlFileName
echo "==========================="
exit
