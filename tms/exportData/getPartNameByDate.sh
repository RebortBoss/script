#!/bin/sh
BP=`dirname $0`
source $BP/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1
calcPtName=`sqlplus -S $LogIn <<EOF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
select h_part('TMS_MAIL_MONITOR_INFO',to_date('$1','yyyymmdd')) h_part_name from dual;
exit;
EOF
`
echo $calcPtName

