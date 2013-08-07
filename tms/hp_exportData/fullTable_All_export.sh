#!/bin/bash
export LANG=zh_CN.GB18030
BN=$(basename $0)
PID=$$
OldPid=99999999
BP=`dirname $0`
PID_FILE="$BP/.$BN.pid"
if [ -f $PID_FILE ];then
  echo "has file"
  OldPid=`cat $PID_FILE`
  if [ "$OldPid" != "" ];then
   cc=`ps -ef|grep $BN|grep $OldPid|grep -v grep|wc -l` 
   echo $cc
   if [ $cc -gt 0 ];then
      echo "is running ... exit"
      exit;
    fi;
  fi;
else
  echo "not file"
fi;
echo $PID > $PID_FILE
TS=`date +'%Y%m%d_%H%M'`
rm -rf $BP/EMS_$TS.chk
cat $BP/cfg_fullTable_All.cfg | while read line
do
  $BP/table_export.sh $line $TS
done
$BP/putFile.sh $BP/EMS_$TS.chk
rm -rf $BP/EMS_$TS.chk
