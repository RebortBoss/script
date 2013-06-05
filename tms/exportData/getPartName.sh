#!/bin/sh
export ORACLE_BASE=/home/zhoudd/setup/oracle/oracle
export ORACLE_HOME=$ORACLE_BASE/11.2.0
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
export NLS_DATE_FORMAT='yyyy-mm-dd hh24:mi:ss'
LogIn=cp_tms/tms@tmsdb980_1
calcPtName=`sqlplus -S $LogIn <<EOF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
select h_part('TMS_MAIL_MONITOR_INFO',sysdate-$1) h_part_name from dual;
EOF
`
echo $calcPtName

