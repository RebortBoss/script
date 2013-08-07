#!/bin/bash
export LANG=zh_CN.GB18030
BN=$(basename $0)
PID=$$
OldPid=99999999
BP=`dirname $0`
PID_FILE="$BP/.$BN.pid"
if [ -f $PID_FILE ];then
  echo "has file $PID_FILE"
  OldPid=`cat $PID_FILE`
  if [ "$OldPid" != "" ];then
   cc=`ps -ef|grep $BN|grep $OldPid|grep -v grep|wc -l` 
   echo $cc
   if [ $cc -gt 0 ];then
      echo "`date +'%Y%m%d_%H%M'` is running ... exit"
      exit;
    fi;
  fi;
else
  echo "not file $PID_FILE"
fi;
echo $PID > $PID_FILE
#TS=`date +'%Y%m%d_%H%M'`
TS=`date -d "3 minute ago" +'%Y%m%d_%H%M'`
echo "TS IS "$TS
rm -rf $BP/EMS_$TS.chk

#modify by sheng.yuan
$BP/read_all_GG.sh $BP/EMS_$TS.chk
$BP/delele_all_GG.sh
nfmonit="$BP/.nextPoint_TMS_MAIL_MONITOR_INFO.pt"
prePoint=""
if [ -f $nfmonit ];then
  prePoint="`cat $nfmonit`"
else
  prePoint="`$BP/getNextPoint.sh tms_mail_monitor_info create_time 20`"
fi;
echo $prePoint
nextPoint="`$BP/getNextPoint.sh tms_mail_monitor_info create_time`"
echo $nextPoint
$BP/initTempTable.sh ${TS} tms_mail_monitor_info create_time ${prePoint} ${nextPoint}
$BP/new_increment_export.sh ${TS} tms_mail_monitor_info create_time ${prePoint} ${nextPoint}
echo $nextPoint >$nfmonit



nfPost="$BP/.nextPoint_TMS_MAIL_POSTING_INFO.pt"
prePost=""
if [ -f $nfPost ];then
  prePost="`cat $nfPost`"
else
  #prePost="`$BP/getNextPoint.sh TMS_MAIL_POSTING_INFO INSERT_TIME 20 'posting_date=trunc(sysdate)'`"
  prePost="`$BP/getNextPoint.sh TMS_MAIL_POSTING_INFO INSERT_TIME  20`"
fi;
echo $prePost
#nextPost="`$BP/getNextPoint.sh TMS_MAIL_POSTING_INFO INSERT_TIME 5 'posting_date=trunc(sysdate)'`"
nextPost="`$BP/getNextPoint.sh TMS_MAIL_POSTING_INFO INSERT_TIME`"
echo $nextPost
$BP/increment_export.sh ${TS} TMS_MAIL_POSTING_INFO INSERT_TIME ${prePost} ${nextPost}
echo $nextPost >$nfPost

#modify by sheng.yuan
#$BP/read_all_GG.sh $BP/EMS_$TS.chk

$BP/putFile.sh $BP/EMS_$TS.chk && rm -rf $BP/EMS_$TS.chk
