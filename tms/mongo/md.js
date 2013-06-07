var dm = function () { 
	var core = new Mongo('10.3.50.221:27017').getDB("core");
	var q1 = new Mongo('10.3.50.221:27017').getDB("queue");
	var q3 = new Mongo('10.3.50.225:27017').getDB("queue");
	var q117 = new Mongo('10.3.50.222:27017').getDB("queue");
	var q118 = new Mongo('10.3.50.224:27017').getDB("queue");
	core.queue_task.find({mode:2},{bid:1,col:1,ip:1,hc:1,pid:1,_id:0,lat:1}).sort({ip:1,hc:1}).forEach(function(data){  
		var cnt = 0;
		var sy = 0;
		if(data.hc>=100&&data.hc<200){
			cnt = q3[data.col].count();  
			sy  = q3[data.col].count({ts:{$gt:data.bid}});  	
		}else if(data.hc>=200&&data.hc<400){
			cnt = q117[data.col].count();
                        sy  = q117[data.col].count({ts:{$gt:data.bid}});
		}else if(data.hc>=400){
			cnt = q118[data.col].count();
                        sy  = q118[data.col].count({ts:{$gt:data.bid}});		 
		}else{
			cnt = q1[data.col].count();  
			sy  =  q1[data.col].count({ts:{$gt:data.bid}});  	
		}
		var ctl = new Date().getTime();  
		var bst = (ctl-data.lat) >60000; 
		var _stus =  bst ?'Stoped':'Running'; 
		db.getMongo().getDB("core").queue_task_mon.save({_id: data.col,total:cnt,processed:cnt-sy,leavings:sy,ip:data.ip,pid:data.pid,stats:_stus,insertDate:new Date()});
	}); 
};
dm();
var ipg = db.getMongo().getDB('core').queue_task_mon.group({key : {"ip" : true},initial : {"count":0,'hdcnt':0,'zsy':0},reduce : function(doc, prev){ prev.count++; prev.zsy+=doc.leavings; if(doc.leavings>0)  prev.hdcnt++; }});
db.getMongo().getDB('stat').task_stat.save({'_id':1,'data':ipg,'ts':new Date()});

