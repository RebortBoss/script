#/bin/sh
export ORACLE_BASE=/home/oracle
export ORACLE_HOME=$ORACLE_BASE/11.2.0
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
SQLLogin=cp_tms/tms@tmstz580
echo $1
if [ -z "$1" ]; then
  echo "datafile is null"
  exit 1;
fi
sqlldr userid=$SQLLogin data=$1  log=all_tmp.log bad=all_tmp.bad control=notworkplan.ctl 2>&1 >/dev/null
