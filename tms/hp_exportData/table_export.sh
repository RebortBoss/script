#!/bin/bash
usage(){
  echo "useage: $0 <TABLE_NAME> <timefmt>"
  exit
}
if [ "$1" = "" ];then
  usage
fi;
if [ -z "$2" ];then
  usage
fi;
BP=`dirname $0`
TAB_NAME="`echo $1|tr '[a-z]' '[A-Z]'`"
#TS=`date +'%Y%m%d_%H%M'`
TS=$2
SQL="select t.* from ${TAB_NAME} t"
echo "$SQL"
base_File="${TAB_NAME}_${TS}.dat"
TMP_FILE="$BP/${base_File}"
expLog="$BP/.log_${TAB_NAME}_${TS}.log"
echo "this export table file name is $TMP_FILE exportLogFlie $expLog"
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=/oracle/app/oracle/product/11.2.0/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'
#LogIn=cp_tms/tms@tmstz245
LogIn=cp_tms/tms@tmsdb
bp=`dirname $0`
startDT=`date +'%Y%m%d%H%M%S'`
sdtmi=`date +'%s'`
curtDateStr=`date +'%Y%m%d'`;
sqluldr2 user=$LogIn query="$SQL" charset=UTF8 file=$TMP_FILE field=0x09 record=0x0d0x0a >$expLog
count=`tail -n 1 $expLog|cut -d' ' -f15`
if [ -z "$count" ];then
  if [ -f $TMP_FILE ];then
    count=`cat $TMP_FILE|wc -l`
  else
    count=0
  fi;
fi;
rm -rf $expLog
FSize="`ls -l ${TMP_FILE}|awk '{print $5}'`"
endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "${startDT} export full_table $TAB_NAME ,file_name ${TMP_FILE} ,export finish ${endDT} cost ${cost}(s) , count ${count} ,file_size $FSize"
echo "end ======================"
echo -e "${base_File}\t${FSize}">> $BP/EMS_$TS.chk
$BP/putFile.sh ${TMP_FILE} && rm -rf ${TMP_FILE}
