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
call ZDD_CURT_EXPORTDATA_BEFOR();
select TO_CHAR(CURT_DATE,'YYYYMMDDHH24MISS') CURT_DATE,TO_CHAR(NEXT_DATE,'YYYYMMDDHH24MISS') NEXT_DATE from TMS_curt_EXPORT where id='hs';
exit;
EOF
`
echo $calcPtName
exit
