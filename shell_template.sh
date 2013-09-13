#!/bin/bash
#
#-----------------------
# Author: zhoudd
# Create: 2013-08-22
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
