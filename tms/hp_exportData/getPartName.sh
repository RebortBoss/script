#!/bin/sh
BP=`dirname $0`
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=/oracle/app/oracle/product/11.2.0/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

#LogIn=cp_tms/tms@tmstz245
LogIn=cp_tms/tms@tmsdb
calcPtName=`sqlplus -S $LogIn <<EOF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
select h_part('TMS_MAIL_POSTING_INFO',sysdate) h_part_name from dual;
exit;
EOF
`
echo $calcPtName

