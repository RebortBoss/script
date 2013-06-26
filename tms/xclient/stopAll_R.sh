BP=`dirname $0`
echo "`ps -ef|grep 'tms_client_1.0.jar -Dfile.encoding=uft-8 -r'|grep -v grep|wc -l`"
ps -ef|grep 'tms_client_1.0.jar -Dfile.encoding=uft-8 -r'|grep -v grep|awk '{print $2}'|xargs kill 
