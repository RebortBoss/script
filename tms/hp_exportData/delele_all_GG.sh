#!/bin/bash
export LANG=zh_CN.GB18030
GG_PATH=/oracle/rmanbackup/ggs/dirdat/ogg_hp
ls -l $GG_PATH/*_data.dsv |grep '_I_.*_data.dsv$'|awk '{print $8}'|xargs rm -rf
ls -l $GG_PATH/*_data.dsv |grep '_U_.*_data.dsv$'|awk '{print $8}'|xargs rm -rf
