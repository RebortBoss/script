BP=`dirname $0`
echo "`ps -ef|grep java|grep 'tms_client.* -r'|grep -v grep|wc -l`"
ps -ef|grep java|grep 'tms_client.* -r'|grep -v grep|awk '{print $2}'|xargs kill 
