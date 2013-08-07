#!/bin/bash
export LANG=zh_CN.GB18030
HOST='10.3.50.164'
USER='ftp_heli'
PASSWD='heli123'
CMD="get $1"
if [ -z "$1" ];then
  CMD="ls -rlt TMS_MAIL_POSTING_INFO_* |tail -10"
fi;
lftp <<END_SCRIPT
  open ftp://$USER:$PASSWD@$HOST
  cd input
  ${CMD}
  quit
END_SCRIPT
if [ "$1" != "" ];then
  echo "get $1 finsih"
fi

