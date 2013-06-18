#!/bin/sh
bp=`dirname $0`
source $bp/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1
#LogIn=cp_tms/tms@tmstz580
echo $LogIn
startDT=`date +'%Y%m%d%H%M%S'`
sdtmi=`date +'%s'`

curtDateStr=`date +'%Y%m%d'`
echo $curtDateStr
echo "\$1 = $1"
Part0=`sh $bp/getPartNameByDate.sh $1`
expLog=$bp/full_expLog.log
SQL="select * from TMS_MAIL_MONITOR_INFO  partition($Part0) nm"
echo $SQL
TMP_FILE=$bp/full_tmp.dat
sqluldr2 user=$LogIn query="$SQL" charset=GBK file=$TMP_FILE field=0x09 record=0x0d0x0a >$expLog
count=`tail -n 1 $expLog|cut -d' ' -f15`
if [ -z "$count" ];then
  count=`cat $TMP_FILE|wc -l`
fi;
finlFileName="FULL_$1_${count}.TXT"
mv $TMP_FILE $bp/$finlFileName
echo "fileName is $finlFileName"
echo "$curtDateStr finish .... "

cat $expLog

endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "start ${startDT} to ${endDT} export file finish,export file name ${finlFileName} cost ${cost}(s) Total Count ${count}"
echo "==========================="
