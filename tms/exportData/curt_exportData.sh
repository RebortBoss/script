#!/bin/sh
sdtmi=`date +'%s'`
BP=`dirname $0`
echo $BP
source $BP/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1
strDate=`sh $BP/getNextTime.sh`
echo $strDate
pd=`echo $strDate|awk {'print $1'}`
nd=`echo $strDate|awk {'print $2'}`
echo "pd=$pd"
echo "nd=$nd"

Part0=`sh $BP/getPartName.sh 0`
echo "$Part2 $Part1 $Part0"

sqlplus -S $LogIn <<EOF
set timing on;
drop table zdd_curt_tmp_0 purge;
create table zdd_curt_tmp_0 
nologging parallel 16 
as
select nm.mail_no,nm.ACTION_TYPE,nm.plan_agency,nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY, nm.ACTUAL_FREQUENCY, nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE, nm.NEXT_ORG_TIME, NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE, nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME from TMS_MAIL_MONITOR_INFO partition($Part0) nm
where ACTUAL_ACTION_TIME is not null;
commit;

create index IDx_zddcurt_up0 on zdd_curt_tmp_0(UPDATE_TIME) nologging parallel 16;

drop table zdd_curt_tmp_data purge;
create table zdd_curt_tmp_data
nologging parallel 16 
as
select * from zdd_curt_tmp_0 where UPDATE_TIME>=TO_DATE('$pd','yyyymmddhh24miss') and UPDATE_TIME <TO_DATE('$nd','yyyymmddhh24miss') ;
commit;

exit;
EOF

edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "finish ... cost $cost (s)"
