set echo off
set linesize 1000 
set term off 
set verify off 
set feedback off 
set pagesize 50000
set heading off 
set trimspool on
spool exp_xls.sql
select 'SPOOL C:EXP_EXCEL_'||LEVEL||'.XLS'||CHR(10)||
'SELECT * FROM (SELECT t.*, row_number() over(order by ID) as rn FROM exp_excel t) WHERE rn BETWEEN 1000 * ('||level||' -1) + 1 AND 1000 * '||level||';'||chr(10)||
'SPOOL OFF'
from dual
connect by level <=(select ceil(count(*)/1000) from exp_excel);
spool off
set heading on
set markup html on entmap off spool on preformat off
@exp_xls.sql
set markup html off entmap off preformat on
set term on 
set verify on 
set feedback on 
set pagesize 14 
set linesize 80
set trimspool off
set echo off
prompt spool over .
