#!/bin/sh
BP=`dirname $0`
CURTDATE=`date +%Y%m%d`
echo "$BP -- $CURTDATE"
ssh 10.3.50.222 /root/projects/xclient/statnotWorkPlan.sh
sftp 10.3.50.222:/root/projects/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.223 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.50.223:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.38 /root/projects/xclient/statnotWorkPlan.sh
sftp 10.3.50.38:/root/projects/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.39 /root/projects/xclient/statnotWorkPlan.sh
sftp 10.3.50.39:/root/projects/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.90 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.50.90:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.91 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.50.91:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.227 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.50.227:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.50.228 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.50.228:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.51.2 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.51.2:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

ssh 10.3.51.3 /root/project/xclient/statnotWorkPlan.sh
sftp 10.3.51.3:/root/project/xclient/sortnotWorkPlan*.csv $BP/data/

cat $BP/data/sortnotWorkPlan_*.csv|sort |uniq >$BP/data/all_$CURTDATE.csv && rm -rf $BP/data/sortnotWorkPlan_*.csv

export ORACLE_BASE=/home/oracle
export ORACLE_HOME=$ORACLE_BASE/11.2.0
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'

sqlldr userid=cp_tms/tms@tmstz580 data=$BP/data/all_$CURTDATE.csv  log=$BP/log/all_$CURTDATE.log bad=$BP/bad/all_$CURTDATE.bad control=$BP/ldr/notworkplan.ctl

