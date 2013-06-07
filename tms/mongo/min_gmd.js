var curdate = new Date();
var cy = curdate.getFullYear()
var cm =  curdate.getMonth();
var cd =  curdate.getDate();
var ccd = new Date(cy,cm,cd);
var tmidd = Math.round((curdate.getTime()- 300000)/60000) * 60000;
var next_ccd = new Date(ccd.getTime()+86400000);
print(curdate + " -- " +curdate.getTime());
print(new Date(tmidd)+ " -- "+tmidd);
var ccdms = ccd.getTime();
print(ccdms +" to " + next_ccd.getTime());
tmidd = tmidd>next_ccd.getTime()?next_ccd.getTime():tmidd;
if(ccdms<tmidd){
	print("MST-1:=======");
	var prv_stat_ms = 0;
	var psObj = db.getMongo().getDB('core').power_day_stat.findOne({'_id':ccd},{'_id':0,'lts':1});
	if(psObj!=null&&psObj.lts!=null){
	  prv_stat_ms = psObj.lts;
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
		printjson(gdata.length);
		var hisDt = db.getMongo().getDB('core').power_day_stat.findOne({'_id':ccd});
		var hddata_arr = [];
		var sum = 0;
		if(hisDt==null||hisDt.data==null){
		  hddata_arr = gdata;
		}else{
		  hddata_arr = hisDt.data;
		  hddata_arr.push.apply(hddata_arr,gdata);
		  sum = psObj.sum;
		  printjson("hddata_arr == "+hddata_arr.length);
		}
		print("sum calc ... ");
		var csst  = new Date().getTime();
		if(sum==null||sum<=0){
			print("sum is 0....");
			sum = 0;
			for(obj in hddata_arr){
				sum += hddata_arr[obj].c;
			}
		}else{
			for(obj in gdata){
				sum += gdata[obj].c;
			}
		}
		print("sum calc cost  "+(new Date().getTime()-csst)+"(ms)");
		db.getMongo().getDB('core').power_day_stat.save({'_id':ccd,'data':hddata_arr,'lts':tmidd,'sum':sum});
	} //if(cms<tmidd){
}//if(ccdms<tmidd) END
print("finish ... cost "+(new Date().getTime()-curdate.getTime())+" (ms)");
