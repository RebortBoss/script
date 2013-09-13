#!/bin/sh
sdtmi=`date +'%s'`
startDT=`date +'%Y%m%d%H%M%S'`
BP=`dirname $0`
echo $BP
source $BP/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1

sqlplus -S $LogIn <<EOF >err.err
select t.* from zdd_abc_noTabl;
exit;
EOF



