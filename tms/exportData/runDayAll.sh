#$/bin/sh
BP=`dirname $0`
echo $BP
printf "TSP-1:确定要执行该脚本吗?:(y/n)："
read -r passFlag
if [ ! "$passFlag" = "y" ]; then
  echo "退出...."
  exit;
fi;

sdtmi=`date +'%s'`
for (( i = 0; i < 8; i++)); do
     $BP/nextDate_exec_980.sh >>/opt/exportData/export_All.log 2>&1
     edtmi=`date +'%s'`
     cost=`expr $edtmi - $sdtmi`
     echo "$i finish cost ${cost}(s)"
     sdtmi=`date +'%s'`
     sleep 3
done; 
