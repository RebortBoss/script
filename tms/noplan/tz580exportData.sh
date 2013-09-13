#!/bin/sh
#export ORACLE_BASE=/home/oracle
export ORACLE_BASE=/home/oracle
export ORACLE_HOME=$ORACLE_BASE/11.2.0
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
LogIn=cp_tms/tms@tmsdb980_1
#LogIn=cp_tms/tms@tmstz580
bp=`dirname $0`
echo $bp
startDT=`date +'%Y%m%d%H%M%S'`
sdtmi=`date +'%s'`
curtDateStr=`date +'%Y%m%d'`
echo $curtDateStr
chour=`date +'%H'`
frNum=`expr $chour / 3`
if [ $frNum -eq 0 ]; then
    frNum=8;
fi;
echo "curt hour $chour == $frNum"
expLog=$bp/expLog.log
pd=$1
nd=$2
echo "pd=$pd"
echo "nd=$nd"
SQL="SELECT   /*+ index(nm ide_lee1)*/ *
  FROM lee_temp_3 nm 
  where  NM.UPDATE_TIME >=TO_DATE('20130503235937','yyyymmddhh24miss')"
echo $SQL
TMP_FILE=$bp/tmp.dat
/home/oracle/11.2.0/bin/sqluldr2 user=$LogIn query="$SQL" charset=UTF8 file=$TMP_FILE field=0x09 record=0x0d0x0a >$expLog
count=`tail -n 1 $expLog|cut -d' ' -f15`
finlFileName="TMS01_${curtDateStr}_0${frNum}_${count}.TXT"
mv $TMP_FILE $bp/$finlFileName
echo "fileName is $finlFileName"
echo "$curtDateStr finish .... "

endDT=`date +'%Y%m%d%H%M%S'`
edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "from ${startDT} to ${endDT} export file finish,export file name ${finlFileName} cost ${cost}(s) Total Count ${count}"
