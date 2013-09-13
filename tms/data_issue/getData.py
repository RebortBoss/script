#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib
import urllib2
import json

#postUrl="http://10.3.32.142:7080/tms/mini/core.FullRoads/run?endTime=1009&postOrgCode=35000133&postDate=2013-08-22&rcvCode=&mailType=9&curtOrgCode=&rcvOrg=21000306";
postUrl="http://10.3.32.142:7080/tms/mini/core.FullRoads/run";
post_params = {
        'endTime' : '1009',
        'postOrgCode':'35000133',
        'postDate':'2013-08-22',
        'rcvCode':'',
        'mailType':'9',
        'rcvOrg':'21000306'
        };
params = urllib.urlencode(post_params);

content = urllib2.urlopen(postUrl,params).read();
data = json.loads(content);
for item in data["data"]:
    print item['abc'];

#print data;
