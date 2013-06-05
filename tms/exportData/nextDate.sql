set heading off
set feedback off
set term off
set pagesize 0
set trimspool on
set linesize 5000

----DADR
spool /opt/exportData/text_next_date.text

--æ•°æ
call ZDD_EXPORTDATA_AFTER();
select TO_CHAR(CURT_DATE,'YYYYMMDDHH24MISS') CURT_DATE,TO_CHAR(NEXT_DATE,'YYYYMMDDHH24MISS') NEXT_DATE from TMS_EXPORT where id='hs';
spool off
