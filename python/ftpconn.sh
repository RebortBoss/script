#!/bin/sh
HOST='10.2.3.188'
USER='tiankai'
PASSWD='swcc2012'
FILE='ys_test_2.txt'

ftp -n $HOST <<END_SCRIPT001
quote USER $USER
quote PASS $PASSWD
get $FILE
quit
END_SCRIPT001
ls -lh >> log.log
exit 0
