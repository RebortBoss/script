#!/usr/bin/env python
# -*- coding: utf-8 -*-
import push_file
import time
import datetime

s = datetime.datetime.now();
tstr=time.strftime("%Y%m%d%H%M%S",s.timetuple());
fileName="push_all_file.txt";
f = open(fileName,'r');
fb = open(fileName+".bak_"+tstr,'w+');
fb.truncate();
for line in f.readlines():
	line = line.strip()                             #去掉每行头尾空白  
	if not len(line) or line.startswith('#'):       #判断是否是空行或注释行  
	        continue                                    #是的话，跳过不处理  
	push_file.push(line);
	fb.write(line+"\n");

open(fileName,'w+').truncate();
