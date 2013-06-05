#!/bin/sh
echo $1 $2
if [ -z "$1" ];then
  echo "lastDate is null"
  exit 0;
fi;
#if [ -z "$2" ];then
#  echo "not part_table_name"
#  exit 0;
#fi;
#printf "TSP-1:当前取到的日期是:$1,下一分区表为:$2,是否继续(y/n)："
printf "TSP-1:当前取到的日期是: $1 ,是否继续(y/n)："
read -r passFlag
echo $passFlag
if [ ! "$passFlag" = "y" ]; then
  echo "退出...."
  exit;
fi;
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=$ORACLE_BASE/11.2.0
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
export NLS_DATE_FORMAT='yyyy-mm-dd hh24:mi:ss'

sdtmi=`date +'%s'`
LogIn=cp_tms/tms@tmsdb980_1
echo $LogIn
calcPtName=`sqlplus -S $LogIn <<EOF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
select h_part('TMS_MAIL_MONITOR_INFO',TO_DATE('$1','yyyymmddhh24miss')+1/12) h_part_name from dual;
EOF
`
echo $calcPtName

#if [ "$calcPtName" != "$2" ];then
#  printf "TSP-2:计算出来的分区表名与输入不下一致,输入:$2　查出来:$calcPtName ,是否继续(y/n)："
#  read -r pqc
#  echo $pqc
#  if [ ! "$pqc" = "y" ]; then
#   echo "退出...."
#   exit 0;
#  fi;
#fi;
if [ -z "$calcPtName" ];then
  printf "TSP-3:计算不出分区来,是否继续(y/n)："
  read -r pdt
  if [ ! "$pdt" = "y" ]; then
   echo "TSP-2:退出...."
   exit 0;
  fi;
fi;


sqlplus -S $LogIn <<SEF
set timing on;
set time on;
set show on;
set echo on;
select sysdate,'$1' p1,'$calcPtName' p2 from dual;
select h_part('TMS_MAIL_MONITOR_INFO',TO_DATE('$1','yyyymmddhh24miss')+1/12) h_part_name,'$calcPtName' parname from dual;

drop table LEE_TEMP_5 purge;

create table LEE_TEMP_5 nologging parallel 16 as
SELECT * FROM LEE_TEMP_1
WHERE UPDATE_TIME>=TO_DATE('$1','yyyymmddhh24miss') ;

commit;

drop table LEE_TEMP_1 purge;

create table LEE_TEMP_1 
nologging parallel 16 
as
select nm.mail_no,nm.ACTION_TYPE,
  nm.plan_agency,
  nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY,
  nm.ACTUAL_FREQUENCY,
  nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE,
  nm.NEXT_ORG_TIME,
  NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE,
  nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME from TMS_MAIL_MONITOR_INFO partition($calcPtName) nm
where ACTUAL_ACTION_TIME is not null;

insert /* +append parallel(nm 16)*/ into LEE_TEMP_1  select  nm.mail_no,nm.ACTION_TYPE,
  nm.plan_agency,
  nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY,
  nm.ACTUAL_FREQUENCY,
  nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE,
  nm.NEXT_ORG_TIME,
  NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE,
  nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME  from LEE_TEMP_5 nm;

commit;

create index IDE_LEE1 on LEE_TEMP_1(UPDATE_TIME) nologging parallel 16;

EXEC DBMS_STATS.GATHER_TABLE_STATS('cp_tms','LEE_TEMP_1',DEGREE =>16,CASCADE=>TRUE);
commit;

SEF

edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "finish ... cost $cost (s)"
