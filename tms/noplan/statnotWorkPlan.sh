#!/bin/sh
BP=`dirname $0`
IP=`ifconfig bond0 |grep 'inet addr'|cut -d':' -f2|cut -d' ' -f1`
echo $IP
echo $BP
grep 'TMS-01002' $BP/logs/xclient.* |cut -d',' -f2-10|cut -d',' -f2,3,4,5,7,8 >$BP/notWorkPlan.log
echo "grep finish...."
#vi $BP/notWorkPlan.log -S $BP/nwp.vim
cat $BP/notWorkPlan.log | sed 's/ ,\w*=/\t/g'|sed 's/kind=//g'|sed 's/ ]//g'|sed 's/null//g'|sort|uniq >$BP/sortnotWorkPlan_$IP.csv
echo "vi finish ..."
#cat $BP/notWorkPlan.l |sort |uniq >$BP/sortnotWorkPlan.csv
echo "finish...."
rm -rf $BP/notWorkPlan.log
