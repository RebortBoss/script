var fmt_size=function(size){
    if(size>1024*1024*1024){
        return ((size/1024/1024/1024).toFixed(2))+"(GB)";
    }else if(size>1024*1024){
        return ((size/1024/1024).toFixed(2))+"(MB)";
    }else if(size>1024){
        return ((size/1024).toFixed(2))+"(KB)";
    }
    return size+"(B)";
}

dbs=db.adminCommand('listDatabases');
//print(dbs.databases);
for(idx in dbs.databases){
    //printjson(dbs.databases[idx]);
    _db = dbs.databases[idx];
    _name = _db.name;
    //print(_name);
    mongo_db=db.getMongo().getDB(_name);
    cols= mongo_db.getCollectionNames();
    //print(cols[0]);
    //printjson(db.getMongo().getDB(_name)[cols[0]].stats());
    for(j in cols){
        //print(_name+" -- "+cols[j]);
        _stat=mongo_db[cols[j]].stats();
        print(_stat.ns+"\t"+_stat.count+"\t"+fmt_size(_stat.size)+"\t"+fmt_size(_stat.storageSize)+"\t"+_stat.capped);
    }
}
