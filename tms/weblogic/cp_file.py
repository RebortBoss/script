#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os

Domains=["10.3.50.241:/root/tms01_domain/servers/server-tms01",
"10.3.50.249:/root/base_domain/servers/server-tms02",
"10.3.50.234:/root/base_domain/servers/server-tms03",
"10.3.50.231:/root/base_domain/servers/server-tms04",
"10.3.50.215:/root/base_domain/servers/server-tms05"
];

def rcp(ip,fullFileName):
	idx = fullFileName.rindex("/");
	filePath = fullFileName[:idx]+"/";
	cmdLine="scp webapp/"+fullFileName+" "+ip+"/stage/tms/tms/"+filePath
	print cmdLine;
	os.system(cmdLine);

curtFileName = sys.argv[1]
print sys.argv
for domain in Domains:
	rcp(domain,curtFileName);
