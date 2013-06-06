#!/bin/sh
sdtmi=`date +'%s'`
BP=`dirname $0`
echo $BP
source $BP/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1
pd=`date -d "1 days ago" +%Y%m%d`
nd=`date +%Y%m%d`
echo "pd=$pd"
echo "nd=$nd"

Part3=`sh $BP/getPartName.sh 3`
Part2=`sh $BP/getPartName.sh 2`
Part1=`sh $BP/getPartName.sh 1`
echo "$Part3 $Part2 $Part1"

sqlplus -S $LogIn <<EOF
set timing on;
drop table zdd_curt_his_1 purge;
create table zdd_curt_his_1 
nologging parallel(degree 16)
as
select nm.mail_no,nm.ACTION_TYPE,nm.plan_agency,nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY, nm.ACTUAL_FREQUENCY, nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE, nm.NEXT_ORG_TIME, NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE, nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME from TMS_MAIL_MONITOR_INFO partition($Part1) nm
where ACTUAL_ACTION_TIME is not null;
commit;

create index IDx_zddhis_up1 on zdd_curt_his_1(UPDATE_TIME) nologging parallel 16;

drop table zdd_curt_his_data purge;
create table zdd_curt_his_data
nologging parallel(degree 16) 
as
select * from zdd_curt_his_1 where UPDATE_TIME>=TO_DATE('$pd','yyyymmdd') and UPDATE_TIME <TO_DATE('$nd','yyyymmdd') ;
commit;


drop table zdd_curt_his_2 purge;
create table zdd_curt_his_2 
nologging parallel(degree 16)
as
select nm.mail_no,nm.ACTION_TYPE,nm.plan_agency,nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY, nm.ACTUAL_FREQUENCY, nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE, nm.NEXT_ORG_TIME, NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE, nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME from TMS_MAIL_MONITOR_INFO partition($Part2) nm
where ACTUAL_ACTION_TIME is not null;
commit;
create index IDx_zddhis_up2 on zdd_curt_his_2(UPDATE_TIME) nologging parallel 16;

insert /* +append parallel(nm 16)*/ into zdd_curt_his_data nologging 
select * from zdd_curt_his_2 nm where UPDATE_TIME>=TO_DATE('$pd','yyyymmdd') and UPDATE_TIME <TO_DATE('$nd','yyyymmdd') ;
commit;

drop table zdd_curt_his_3 purge;
create table zdd_curt_his_3
nologging parallel(degree 16)
as
select nm.mail_no,nm.ACTION_TYPE,nm.plan_agency,nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY, nm.ACTUAL_FREQUENCY, nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE, nm.NEXT_ORG_TIME, NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE, nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME from TMS_MAIL_MONITOR_INFO partition($Part3) nm
where ACTUAL_ACTION_TIME is not null;
commit;
create index IDx_zddhis_up3 on zdd_curt_his_3(UPDATE_TIME) nologging parallel 16;

insert /* +append parallel(nm 16)*/ into zdd_curt_his_data nologging 
select * from zdd_curt_his_3 nm where UPDATE_TIME>=TO_DATE('$pd','yyyymmdd') and UPDATE_TIME <TO_DATE('$nd','yyyymmdd') ;
commit;
exit;
EOF

edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "finish ... cost $cost (s)"
