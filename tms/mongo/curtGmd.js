//过时了..
var curdate = new Date();
var cy = curdate.getFullYear()
var cm =  curdate.getMonth();
var cd =  curdate.getDate();
var ccd = new Date(cy,cm,cd);
print(ccd);
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
cond :{'ts':{$gte:ccd.getTime()}},
  reduce : function(doc, prev){  
     prev.c+=doc.cnt;
  }  
});
printjson(gdata);
print(gdata.length)
db.getMongo().getDB('core').task_power_stat.save({'_id':ccd,'data':gdata});
