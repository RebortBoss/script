#!/bin/sh
sdtmi=`date +'%s'`
startDT=`date +'%Y%m%d%H%M%S'`
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
Part1=`sh $BP/getPartName.sh 1`
echo "$Part1 $Part0"

curtDateStr=`date +'%Y%m%d'`
chour=`date +'%H'`
frNum=`expr $chour / 3 + 1`
echo $frNum 
sqlplus -S $LogIn <<EOF
set timing on;
drop table zdd_curt_tmp_0 purge;
create table zdd_curt_tmp_0 
nologging parallel(degree 16) 
as
select nm.mail_no,nm.ACTION_TYPE,nm.plan_agency,nm.PLAN_FREQUENCY,
  nm.ACTUAL_AGENCY, nm.ACTUAL_FREQUENCY, nm.plan_action_time,nm.actual_action_time,
  nm.TRIP_FLIGHTS_CODE,nm.ROUTE_CODE,nm.ACTION_PRESON, nm.NEXT_ORGCODE,
  nm.NEXT_FRE, nm.NEXT_ORG_TIME, NM.ROUTE_NAME,NM.TRIP_FLIGHTS_NAME, NM.UNUSUAL_RESON, NM.MAIL_BAG_LABEL,NM.PKG_BUSI_KIND_CODE, 
  nm.DLV_STS_CODE,nm.UNDLV_NEXT_ACTN_CODE, nm.CREATE_TIME, nm.DIRECTION, nm.SEAL_ORG_CODE,nm.RCV_ORG_CODE, 
  NM.UPDATE_TIME from TMS_MAIL_MONITOR_INFO  partition($Part0) nm
where ACTUAL_ACTION_TIME is not null;
commit;
create index IDE_zddcurt_tmp0 on zdd_curt_tmp_0(UPDATE_TIME) nologging parallel 16;

drop table zdd_curt_tmp_data purge;
create table zdd_curt_tmp_data
nologging parallel(degree 16)
as
select * from zdd_curt_tmp_0 where UPDATE_TIME>=TO_DATE('$pd','yyyymmddhh24miss') and UPDATE_TIME <TO_DATE('$nd','yyyymmddhh24miss') ;
commit;

drop table zdd_curt_tmp_1 purge;
create table zdd_curt_tmp_1 
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

create index Idx_zddcurt_tmp1 on zdd_curt_tmp_1(UPDATE_TIME) nologging parallel 16;

drop table zdd_curt_data_1 purge;
create table zdd_curt_data_1 
nologging parallel(degree 16) 
as
select * from zdd_curt_tmp_1 NM where UPDATE_TIME>=TO_DATE('$pd','yyyymmddhh24miss') and UPDATE_TIME <TO_DATE('$nd','yyyymmddhh24miss');
commit;

insert /* +append */ into zdd_curt_tmp_data nologging  select * from zdd_curt_data_1 NM;
commit;


exit;
EOF

edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "export befor finish ... cost $cost (s)"

SQL="SELECT DECODE(M.UPDATE_TIME-M.CREATE_TIME,0,'I','U') INORUP,
  M.MAIL_NO,
  M.ACTION_TYPE,
  H_ACTION_NAME(m.ACTION_TYPE) ACTION_NAME,
  M.PLAN_AGENCY,
  H_DEPTNAME(PLAN_AGENCY)  PLAN_AGEN_NAME,
  M.PLAN_FREQUENCY,
  H_FRENAME(M.PLAN_FREQUENCY) PLAN_FREQ_NAME,
  M.ACTUAL_AGENCY,
  H_DEPTNAME(ACTUAL_AGENCY) OPER_AGEN_NAME,
  M.ACTUAL_FREQUENCY,
  H_FRENAME(M.ACTUAL_FREQUENCY) OPER_FREQ_NAME,
  M.plan_action_time,
  M.actual_action_time,
  M.action_preson,
  M.TRIP_FLIGHTS_CODE,
  M.ROUTE_CODE,
  M.ACTION_PRESON,
  M.NEXT_ORGCODE,
  H_DEPTNAME(NEXT_ORGCODE) NEXT_ORG_NAME,
  M.NEXT_FRE,
  H_FRENAME(M.NEXT_FRE) NEXT_FRE_NAME,
  M.NEXT_ORG_TIME,
  M.ROUTE_NAME,
  M.trip_flights_name,
  M.unusual_reson,
  M.MAIL_BAG_LABEL,
  M.PKG_BUSI_KIND_CODE,
  M.DLV_STS_CODE,
  M.UNDLV_NEXT_ACTN_CODE,
  TO_CHAR(M.CREATE_TIME,'YYYY/MM/DD HH24:MI:SS') CREATE_TIME,
  M.DIRECTION,
  M.SEAL_ORG_CODE,
  M.RCV_ORG_CODE,
  TO_CHAR(M.UPDATE_TIME,'YYYY/MM/DD HH24:MI:SS') UPDATE_TIME,
  '' NEXTFLAG
from zdd_curt_tmp_data m "
echo $SQL
TMP_FILE=$BP/curt_tmp.dat
AE_LOG=$BP/curt_allExportLog.log
expLog=$BP/curt_expLog.log
/usr/local/bin/sqluldr2 user=$LogIn query="$SQL" charset=GBK file=$TMP_FILE field=0x09 record=0x0d0x0a >$expLog
count=`tail -n 1 $expLog|cut -d' ' -f15`
if [ -z "$count" ];then
  count=`cat $TMP_FILE|wc -l`
fi;
finlFileName="TMS01_${curtDateStr}_0${frNum}_${count}_${pd}_${nd}.TXT"
mv $TMP_FILE $BP/$finlFileName
echo "fileName is $finlFileName"
echo "$curtDateStr finish .... "

echo "$curtDateStr start  ...... " >> $AE_LOG
cat $expLog >>$AE_LOG
echo "$curtDateStr finish ...... " >> $AE_LOG
echo "===========" >>$AE_LOG
endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "start ${startDT} to ${endDT} export file finish,export file name ${finlFileName} cost ${cost}(s) Total Count ${count}"
sqlplus -S $LogIn <<EOF
insert into TMS_EXPORT_LOG(name,CURT_DATE,NEXT_DATE,start_exp_date,END_EXP_DATE,state,cnt,fre_num,file_name,costMI,qdate) VALUES ('hs',to_date('$pd','YYYYMMDDHH24MISS'),to_date('$nd','YYYYMMDDHH24MISS'),to_date('$startDT','YYYYMMDDHH24MISS'),to_date('$endDT','YYYYMMDDHH24MISS'),'finish',${count},'0${frNum}','$finlFileName',${cost},to_date('${curtDateStr}','YYYYMMDD'));
commit;
quit
EOF
ls -l $BP/$finlFileName 
sh $BP/putFile.sh $BP/$finlFileName && rm -rf $BP/$finlFileName
echo "==========================="



