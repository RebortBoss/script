#!/bin/sh
BP=`dirname $0`
strDate=`sh $BP/getNextTime.sh`
echo $strDate
pd=`echo $strDate|awk {'print $1'}`
nd=`echo $strDate|awk {'print $2'}`
echo "pd=$pd"
echo "nd=$nd"

