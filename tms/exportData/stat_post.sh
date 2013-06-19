#!/bin/sh
sdtmi=`date +'%s'`
startDT=`date +'%Y%m%d%H%M%S'`
BP=`dirname $0`
echo $BP
source $BP/oracle.profile
LogIn=cp_tms/tms@tmsdb980_1

curtDateStr=`date +'%Y%m%d'`
sqlplus -S $LogIn <<EOF
set timing on;
drop table Zdd_Mailpost_Cost_Stat purge;

Create Table Zdd_Mailpost_Cost_Stat
nologging parallel(degree 16) 
as
Select
mail_no
,Posting_Orgcode
,Posting_Date
,H_Date(Posting_Date,Posting_Time) Posting_dataTime
,Mail_Kind_Code
,Delivery_Orgcode
,To_Date(Delivery_Time,'yyyy-mm-dd hh24:mi:ss') Delivery_Time
From Tms_Mail_Posting_Info Where Posting_Date = to_date('$1','yyyymmdd')
and status = 'I'
And Delivery_Time Is Not Null;


drop table Zdd_To_Dlv_Cost_Stat purge;
Create Table Zdd_To_Dlv_Cost_Stat
nologging parallel(degree 16) 
as
select Mail_No,Delivery_Orgcode,DELIVERY_TIME,Actual_Action_Time from (
Select Row_Number() Over (Partition By M.Actual_Agency Order By M.Actual_Action_Time Asc) Rn,
A.Mail_No,A.Delivery_Orgcode,DELIVERY_TIME,
To_Date(M.Actual_Action_Time,'yyyy-mm-dd hh24:mi:ss') Actual_Action_Time
From Zdd_Mailpost_Cost_Stat A,
Tms_Mail_Monitor_Info M
Where A.Mail_No = M.Mail_No And A.Delivery_Orgcode= M.Actual_Agency
) where rn = 1;


drop table Zdd_Post_Stat_Tmp1 Purge;

Create Table Zdd_Post_Stat_Tmp1
Nologging Parallel(Degree 16) 
as
Select C.*,(Full_Cost - Todlv_Cost) Dlv_Cost From (
Select B.Posting_Orgcode,B.Mail_Kind_Code,b.Posting_Date,B.Posting_Datatime,B.Delivery_Orgcode,B.Delivery_Time,A.Actual_Action_Time,
Round((A.Actual_Action_Time-B.Posting_Datatime)*86400) Todlv_Cost,
Round((B.Delivery_Time - B.Posting_Datatime)*86400) Full_Cost
From Zdd_To_Dlv_Cost_Stat A,Zdd_Mailpost_Cost_Stat B
Where A.Mail_No = B.Mail_No And A.Delivery_Orgcode = B.Delivery_Orgcode
And A.Actual_Action_Time>B.Posting_Datatime And B.Delivery_Time<>A.Actual_Action_Time
) C;

Delete From Zdd_Post_Stat_Final Nologging  Where Posting_Date = To_Date('$1','yyyymmdd');

Insert /* +append parallel(nm 16)*/ Into Zdd_Post_Stat_Final
select * from Zdd_Post_Stat_Tmp1 nm;
commit;
exit;
EOF

edtmi=`date +'%s'`
cost=`expr $edtmi - $sdtmi`
echo "stat $1 out full finish ... cost $cost (s)"



