#!/bin/bash
#create 2013-10-30 <zhoudd>
#filename runRemoteCmd.sh
#--------------
# 远程主机上执行脚本
#usage runRemoteCmd.sh <cmd>
# e.g runRemoteCmd.sh "date"

cat "$(dirname $0)/hosts"|while read HOST
do
    echo $HOST
    ssh $HOST $1
done;
