#!/bin/bash
export LANG=zh_CN.GB18030
if [ -z "$1" ];then
  exit
fi;
HOST='10.3.50.164'
USER='ftp_heli'
PASSWD='heli123'
lftp <<END_SCRIPT
  open ftp://$USER:$PASSWD@$HOST
  cd input
  put $1
  quit
END_SCRIPT
echo "put $1 finsih"

