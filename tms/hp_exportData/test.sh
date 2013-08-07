#!/bin/bash
echo $LANG
GG_PATH=/oracle/rmanbackup/ggs/dirdat/ogg_hp
#ls -l $GG_PATH |grep 'data.dsv$'|awk '{print $5" "$8}'|while read line
#modified by sheng.yuan
#export LANG=zh_CN.UTF-8
locale
/bin/ls --full-time --time-style=full-iso $GG_PATH|awk '{print $5" "$9}'|while read line
do 
  fileSize=`echo $line|cut -d ' ' -f1`
  echo "$line"
  fileName=`echo $line|cut -d ' ' -f2`
  #echo "$fileName"
  #echo "$BP/putFile.sh $GG_PATH/$fileName"
  echo -e "$fileName\t$fileSize"
done
