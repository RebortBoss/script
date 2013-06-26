BP=`dirname $0`
jarFileName=$BP/tms_client_1.0.jar
echo $$
nohup java -jar $jarFileName  -Dfile.encoding=uft-8 "$@" | /usr/sbin/rotatelogs $BP/logs/xclient.$!.log 3600 2>&1 &
