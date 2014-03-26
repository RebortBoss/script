#!/bin/bash
#
#-----------------------
# Author: zhoudd
# Create: 2013-11-1
#----------------------
#


#script name
_me=${0##*/}
usage(){
    echo "
$_me Version 1.0
 
 usage :
  $_me <argc> <argv>

 eg :
   $_me args0 args1 ";
   #quit 
   exit 0;
}
case $1 in
    "help"|"-h"|"-v"|"--help"|"--version"|"-version") usage
esac

start_server(){
    arr=(${1//,/ })
    echo "ssh ${arr[0]} ${arr[1]}/start_server.sh ${arr[2]}"
}

ALL="10.3.50.241,/root/baseDomain,server_tms01
10.3.50.249,/root/baseDomain2,server_tms02
"
for domain in ${ALL//\\r};do
    start_server $domain;
done;
