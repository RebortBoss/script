var curdate = new Date();
var cy = curdate.getFullYear()
var cm =  curdate.getMonth();
var cd =  curdate.getDate();
var ccd = new Date(cy,cm,cd);
var tmidd = Math.round((curdate.getTime()- 300000)/60000) * 60000;
var next_ccd = new Date(ccd.getTime()+86400000);
print(curdate + " -- " +curdate.getTime());
print(new Date(tmidd)+ " -- "+nextDate.getTime());
var ccdms = ccd.getTime();
print(ccdms +" to " + next_ccd.getTime());
tmidd = tmidd>next_ccd.getTime()?next_ccd.getTime():tmidd;
if(ccdms<tmidd){
	print("MST-1:=======");
	var prv_stat_ms = 0;
	var psObj = db.getMongo().getDB('core').power_cfg.findOne({'_id':ccd});
	if(psObj!=null&&psObj.ts!=null){
	  prv_stat_ms = psObj.ts;
	}
	var cms = ccdms<prv_stat_ms ? prv_stat_ms : ccdms;
	if(cms<tmidd){
		print("query ... <="+cms+" to <　"+tmidd);
		var gdata = db.getMongo().getDB('core').task_power_mon.group({   
		 keyf: function(doc) {
		    var date = new Date(doc.ts);
		    var mm =  date.getMonth();
		    var dd =  date.getDate();
		    var hh = date.getHours();
		    var mi =date.getMinutes();
		    var dateKey=new Date(date.getFullYear(),mm,dd,hh,mi,0);
		    return {'d':dateKey};
		 },
		 initial : {'c':0},  
		 cond :{'ts':{$gte:cms,$lt:tmidd}},
		  reduce : function(doc, prev){  
		     prev.c+=doc.cnt;
		  }  
		});
		printjson(gdata.legth);
		var hisDt = db.getMongo().getDB('core').power_day_stat.findOne({'_id':ccd});
		var hddata_arr = [];
		if(hisDt==null||hisDt.data==null){
		  hddata_arr = gdata;
		}else{
		  hddata_arr = hisDt.data;
		  hddata_arr.push.apply(hddata_arr,gdata);
		  printjson("hddata_arr == "+hddata_arr.legth);
		}
		db.getMongo().getDB('core').power_day_stat.save({'_id':ccd,'data':hddata_arr,'lts':tmidd});
		db.getMongo().getDB('core').power_cfg.save({'_id':ccd,'ts':tmidd});
	} //if(cms<tmidd){
}//if(ccdms<tmidd) END
