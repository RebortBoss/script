#!/bin/sh
export LANG=zh_CN.GB18030
BP=`dirname $0`
FILE=$1
echo "file name is $FILE"
if [ -z "$1" ];then
#  FILE=`$BP/getFile.sh|tail -1 |awk '{print $9}'`
  exit
fi;
MD_FILE=`date +"hp_exprot_cc_%Y%m%d.md"`
#$BP/getFile.sh $FILE
MAIN_NO=`head -1 $FILE|awk '{print $1}'`
if [ -z "$MAIN_NO" ];then
  echo "not data.."
else
  TM=`echo "$FILE"|cut -d'_' -f6|cut -d'.' -f1`
  $BP/zdd_mainpost.sh $MAIN_NO $FILE $TM |sed 's/^------------/> ------------/' >> $BP/$MD_FILE
fi;

#if [ "$FILE" != "" ];then
#  rm -rf $FILE >/dev/null 2>&1
#fi;
