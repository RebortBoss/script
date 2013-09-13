#!/bin/sh
bp=`dirname $0`
source $bp/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1
TMP_FILE=$bp/tmpslice.dat
sqluldr2 user=$LogIn sql="$bp/zdd_monitor.sql" charset=GBK file=$TMP_FILE field=0x09 record=0x0d0x0a
#ls -ls $TMP_FILE
exit
