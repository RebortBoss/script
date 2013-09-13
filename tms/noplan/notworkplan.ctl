OPTIONS (skip=0,rows=128,errors=-1) 
load data
characterset ZHS16GBK
append into table TMS_NOTWORK_PLAN_NEW
FIELDS TERMINATED BY X'09' 
trailing nullcols 
(
KIND,
RVC_CODE,
rvc_org,
UP_CODE,
WD,
CURT_ORG
)


