#!/bin/bash
usage(){
  echo "useage: $0 <timefmt> <TABLE_NAME> <FILE_NAME> <StartTime> <endTime> [ext_query]"
  exit
}
if [ -z "$5" ];then
  usage
fi;
if [ -z "$4" ];then
  usage
fi;
if [ -z "$3" ];then
  usage
fi;
if [ -z "$2" ];then
  usage
fi;
if [ -z "$1" ];then
  usage
fi;
extquery=""
if [ "$6" != "" ] ;then
  extquery=" and $6"
fi;
BP=`dirname $0`
TAB_NAME="`echo $2|tr '[a-z]' '[A-Z]'`"
TS=$1

Part0=`sh $BP/getPartName.sh`
echo "Part0 is "$Part0

SQL="select t.* from ${TAB_NAME} partition($Part0) t where $3>=to_date('$4','yyyymmddhh24miss') and $3<=to_date('$5','yyyymmddhh24miss') $extquery"
echo $SQL
base_File="${TAB_NAME}_${TS}.dat"
TMP_FILE="$BP/${base_File}"
touch $TMP_FILE
expLog="${BP}/.log_${TAB_NAME}_${TS}.log"
#echo "this export table file name is $TMP_FILE exportLogFlie $expLog"
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
echo `ls -l ${TMP_FILE}`
FSize="`ls -l ${TMP_FILE}|awk '{print $5}'`"
echo "FSize is "$FSize
endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "${startDT} increment export $TAB_NAME $3 gte $4 lt $5 , file_name ${TMP_FILE} , ${endDT} export finish cost ${cost} (s), count ${count} , file_size $FSize"
echo -e "${base_File}\t${FSize}">> $BP/EMS_$TS.chk
if [ "$TAB_NAME" = "TMS_MAIL_POSTING_INFO" ];then
  #数�怀出抽查
  $BP/final_zdd.sh ${TMP_FILE}
fi;
$BP/putFile.sh ${TMP_FILE} && rm -rf ${TMP_FILE}
echo "end ======================"

