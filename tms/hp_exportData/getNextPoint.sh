#!/bin/sh
if [ -z "$1" ];then
  exit
fi;
if [ -z "$2" ];then
  exit
fi;
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=/oracle/app/oracle/product/11.2.0/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'
#LogIn=cp_tms/tms@tmstz245
LogIn=cp_tms/tms@tmsdb
extQuery=""
if [ "$4" != "" ];then
  extQuery=" where $4"
fi;
oldMin=5
if [ "$3" != "" ];then
  oldMin=$3
fi;
#$1="dual"
#SQL="SELECT to_char(max($2)-$oldMin/24/60,'yyyymmddhh24miss') max_time FROM $1 $extQuery"
#SQL="SELECT to_char(max($2),'yyyymmddhh24miss') max_time FROM $1 $extQuery"
SQL="SELECT to_char(sysdate,'yyyymmddhh24miss') max_time FROM dual"
#echo $SQL
nextPoint=`sqlplus -S $LogIn <<EOF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
$SQL;
exit;
EOF
`
echo $nextPoint
