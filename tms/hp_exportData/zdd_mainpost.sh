#!/bin/sh
BP=`dirname $0`
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=/oracle/app/oracle/product/11.2.0/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH
export CLASSPATH=$ORACLE_HOME/lib
export NLS_LANG='AMERICAN_AMERICA.ZHS16GBK'
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

#LogIn=cp_tms/tms@tmstz245
echo ""
echo -e "  - **$3导出情况**\r\n"
echo "####1.接口数据库数据�";
hsLogIn=emsquery/637412CFBB4897D8@tmsremote
sqlplus -S $hsLogIn <<HSEOF
set colsep '|'
set line 330 pagesize 10000 echo on; 
SELECT mail_num "> 详情单号",clct_bureau_org_code "收寄机构",clct_date "收寄日期",
clct_time "收寄时间",load_date "加载时间"
from vw_evt_mail_clct where mail_num ='$1';
exit;
HSEOF

LogIn=cp_tms/tms@tmsdb
echo "####2.时限监控管理处理情况:"
sqlplus -S $LogIn <<EOF
set colsep '|'
set line 330 pagesize 10000 echo on; 

SELECT mail_no "> 详情单号",posting_orgcode "收寄机构",posting_date "收寄日期",
posting_time "收寄时间",insert_time "处理时间"
from tms_mail_posting_info where mail_no ='$1';
exit;
EOF
filename="`echo $2|sed 's/\/opt\/hpExport\///g'`"
echo "####3.数据导出情况:"
echo "> 详情单 $1,导出到文件: $filename ."
