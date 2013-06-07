db.getMongo().getDB('core').task_power_stat.find().forEach(function(data){ 
	var cdat = data.data;
	var sum = 0;
	for(inx in cdat){
		sum += cdat[inx]['c'];
	}
	printjson(data['_id']+"  -- sum:"+sum);
	var newData = data;
	newData['sum'] = sum;
	db.getMongo().getDB("core").task_power_stat.update({'_id':data['_id']},newData);
});