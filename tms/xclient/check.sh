#!/bin/bash
fn(){
	if [ "$3" == "$4" ];then
		echo "$1 $2 Ok.";
	else
		echo "$1 $2 Error.";
	fi;
}

testPing(){
	rs="`ping -c 1 $1|grep loss|cut -d' ' -f 6|cut -d '%' -f1`";
	fn "ping" "$1" "$rs" "0"; 
}
#testPing 10.3.50.221;
#testPing 10.3.50.12;
testNmap(){
	rs="`nmap -p $2 $1|grep '/tcp'|cut -d' ' -f2`";
	fn "nmap" "$1:$2" "$rs" "open"
}
#testNmap 10.3.50.40 1521
#testNmap 10.3.50.40 1561
mongs=10.3.31.1,10.3.50.221,10.3.51.1,10.3.50.224,10.3.50.226,10.3.50.226,10.3.50.117,10.3.50.118
weblogics=10.3.50.152,10.3.50.241,10.3.50.249,10.3.50.234,10.3.50.231,10.3.50.215
oracles=10.3.32.213,10.3.50.40,10.3.50.41,10.3.50.44,10.3.50.85,10.3.50.240

for i in ${mongs//,/ };do
	testNmap $i 27017
done;
for i in ${weblogics//,/ };do
	testNmap $i 7011
done;
for i in ${oracles//,/ };do
	testNmap $i 1521
done;
testNmap 10.3.18.93 8080
