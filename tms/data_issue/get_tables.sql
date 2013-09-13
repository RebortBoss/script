select 
  (select p.prov_name from cpcm_province p where p.prov_code = dept.prov_code) "省",
  (select county_name from cpcm_county where county_code =dept.county_code) "城市",
  dept.dept_name||'['||dept.dept_code||']'　"机构",
  p.end_time as "入场结束时间",
  l.line_name as "邮路名称",
  l.line_id　"邮路编号",
   p.leave_time　"出发时间",
  p.ARRIVE_TIME　"到达时间",
  (SELECT d.dept_name
      FROM tbl_sys_departments d
      WHERE d.dept_code = p.unload_orgcode
      )||'['||
      p.unload_orgcode||']'  "下游机构",
      p.days  "适用工作日",
      (case d.kind when '6' then '经济件' when '9' then '标准件' end) "邮件类型",
      (case d.road when '1' then '省际' when '2' then '省内' when '3' then '同城' end) "发运范围",
      (select de.dept_name from tbl_sys_departments de where de.dept_code = d.deal_center)||'['||d.deal_center||']' "发运机构",
       to_char(p.start_valid_date,'yyyy-mm-dd') "开始生效日期",
      TO_CHAR(p.end_valid_date,'yyyy-mm-dd') "结束生效日期"
    FROM tms_work_plan p ,
      tbl_sys_departments dept ,
      tms_post_line l ,
      tms_dept_code t1,
      tms_dept_code t2,
      tms_work_plan_detail d
    WHERE p.org_code         = t1.unit_code
    AND p.unload_orgcode     = t2.unit_code(+)
    AND p.lineid             = l.line_id
    AND p.org_code           = dept.dept_code
    and p.jid = d.rid
    and d.type = '3'
    AND t1.UNIT_PATTERN     IN ('1','7')
    AND p.isvalid            = '1'
    AND TRUNC(sysdate,'dd') >= TRUNC(p.start_valid_date,'dd')
    AND TRUNC(sysdate,'dd') <= TRUNC(p.end_valid_date,'dd')
    AND p.end_valid_date    >= p.start_valid_date
    and dept.dept_code       =p.org_code
    and dept.county_code like '330782'
    order by dept.prov_code,dept.dept_code,p.lineid;