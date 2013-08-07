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
startDT=`date +'%Y%m%d%H%M%S'`
sdtmi=`date +'%s'`

sqlplus -S $LogIn <<SEF
set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000
call ZDD_EXPORTDATA_AFTER(to_date('$1','YYYYMMDDHH24MISS'),to_date('$2','YYYYMMDDHH24MISS'));
select TO_CHAR(CURT_DATE,'YYYYMMDDHH24MISS') CURT_DATE,TO_CHAR(NEXT_DATE,'YYYYMMDDHH24MISS') NEXT_DATE from TMS_EXPORT where id='hs';
exit;
SEF
curtDateStr=`date +'%Y%m%d'`
echo $curtDateStr
chour=`date +'%H'`
frNum=`expr $chour / 3 + 1`
echo "curt hour $chour == $frNum"
expLog=$bp/expLogslice.log
cat $bp/text_next_dateslice.text
pd=$1
nd=$2
echo "pd=$pd"
echo "nd=$nd"
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
from ZDD_MONITOR M"
echo $SQL
TMP_FILE=$bp/tmpslice.dat
sqluldr2 user=$LogIn query="$SQL" charset=GBK file=$TMP_FILE field=0x09 record=0x0d0x0a >$expLog
count=`tail -n 1 $expLog|cut -d' ' -f15`
if [ -z "$count" ];then
  count=`cat $TMP_FILE|wc -l`
fi;
finlFileName="TMS01_${curtDateStr}_0${frNum}_${count}_${pd}_${nd}.TXT"
mv $TMP_FILE $bp/$finlFileName
echo "fileName is $finlFileName"
echo "$curtDateStr finish .... "

echo "$curtDateStr start  ...... " >> $bp/allExportLogslice.log
cat $expLog >>$bp/allExportLogslice.log
echo "$curtDateStr finish ...... " >> $bp/allExportLogslice.log
echo "===========" >>$bp/allExportLogslice.log
endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "start ${startDT} to ${endDT} export file finish,export file name ${finlFileName} cost ${cost}(s) Total Count ${count}"
sqlplus -S $LogIn <<EOF
insert into TMS_EXPORT_LOG(name,CURT_DATE,NEXT_DATE,start_exp_date,END_EXP_DATE,state,cnt,fre_num,file_name,costMI,qdate) VALUES ('hs',to_date('$pd','YYYYMMDDHH24MISS'),to_date('$nd','YYYYMMDDHH24MISS'),to_date('$startDT','YYYYMMDDHH24MISS'),to_date('$endDT','YYYYMMDDHH24MISS'),'finish',${count},'0${frNum}','$finlFileName',${cost},to_date('${curtDateStr}','YYYYMMDD'));
commit;
quit
EOF
ls -l $bp/$finlFileName 
#sh $bp/putFile.sh $bp/$finlFileName && rm -rf $bp/$finlFileName
sh $bp/putFile.sh $bp/$finlFileName
echo "==========================="
