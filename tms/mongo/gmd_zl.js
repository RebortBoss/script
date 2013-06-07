var curdate = new Date();
var cy = curdate.getFullYear()
var cm =  curdate.getMonth();
var cd =  curdate.getDate();
var ccd = new Date(cy,cm,cd);
var prd = new Date(ccd.getTime()-86400000);
print(prd);
var psObj = db.getMongo().getDB('core').power_day_stat.findOne({'_id':prd});
var beginTime = prd.getTime();
if(psObj!=null&&psObj.lts!=null){
	beginTime = psObj.lts;
}
var gdata = db.getMongo().getDB('core').task_power_mon.group({   
 keyf: function(doc) {
    var date = new Date(doc.ts);
    var mm =  date.getMonth();
    var dd =  date.getDate();
    var hh = date.getHours();
    var mi =date.getMinutes();
    var tmi = Math.round(mi/10);
    //var dateKey = date.getFullYear()+""+(mm>9?mm:"0"+mm)+""+(dd>9?dd:"0"+dd)+""+(hh>9?hh:"0"+hh)+""+(mi>9?mi:"0"+mi)+"00";
    var dateKey=new Date(date.getFullYear(),mm,dd,hh,tmi*10,0);
    return {'d':dateKey};
 },
  initial : {'c':0},  
  cond :{'ts':{$gte:beginTime,$lt:ccd.getTime()}},
  reduce : function(doc, prev){  
     prev.c+=doc.cnt;
  }  
});
print(gdata.length);
hddata_arr = [];
var sum = 0;
if(psObj==null||psObj.data==null){
	  hddata_arr = gdata;
}else{
	  hddata_arr = psObj.data;
	  hddata_arr.push.apply(hddata_arr,gdata);
	  sum = psObj.sum;
	  printjson("hddata_arr == "+hddata_arr.length);
}
print("sum calc ... ");
for(obj:gdata){
	sum += obj.c;
}
db.getMongo().getDB('core').task_power_stat.save({'_id':prd,'data':hddata_arr,'sum':sum});

