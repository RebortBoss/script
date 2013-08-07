#!/bin/bash
BP=`dirname $0`
echo $BP
if [ -z "$1" ];then
  exit;
fi;
chkFile=$1
GG_PATH=/oracle/rmanbackup/ggs/dirdat/ogg_hp
#ls -l $GG_PATH |grep 'data.dsv$'|awk '{print $5" "$8}'|while read line
#modified by sheng.yuan
export LANG=zh_CN.GB18030
/bin/ls -l --full-time --time-style=full-iso $GG_PATH |grep '_D_.*_data.dsv$'|awk '{print $5" "$9}'|while read line
do 
  fileSize=`echo $line|cut -d ' ' -f1`
  #echo "file size $fileSize"
  fileName=`echo $line|cut -d ' ' -f2`
  #echo "$fileName"
  #echo "$BP/putFile.sh $GG_PATH/$fileName"
  $BP/putFile.sh $GG_PATH/$fileName
  rm -rf $GG_PATH/$fileName
  echo -e "$fileName\t$fileSize" >>$chkFile
done
