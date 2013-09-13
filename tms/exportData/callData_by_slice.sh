#!/bin/sh
bp=`dirname $0`
echo "\$1=$1 \$2=$2"
if [ -z "$1" ];then
   echo "每一个参数为空了.exit ... "
   exit 0;
fi;
if [ -z "$2" ];then
  echo "每二个参数为空了.exit ... "
  exit 0;
fi;
source $bp/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1
#LogIn=cp_tms/tms@tmstz580
echo $LogIn

sqlplus -S $LogIn <<SEF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
call ZDD_EXPORTDATA_AFTER(to_date('$1','YYYYMMDDHH24MISS'),to_date('$2','YYYYMMDDHH24MISS'));
commit;
exit;
SEF
echo "call finish..."
