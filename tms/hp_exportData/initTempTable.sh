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
drop_SQL="drop table ${TAB_NAME}_temp"
SQL="create table  ${TAB_NAME}_temp nologging parallel 8 as select /*+ index(t PK_MAIL_MONIT_INFO)*/ t.* from ${TAB_NAME} t where $3>=to_date('$4','yyyymmddhh24miss') and $3<=to_date('$5','yyyymmddhh24miss') $extquery"
echo $SQL
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
nextPoint=`sqlplus -S $LogIn <<EOF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
$drop_SQL;
$SQL;
exit;
EOF
`
echo $nextPoint
