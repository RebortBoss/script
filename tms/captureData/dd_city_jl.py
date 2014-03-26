#!/usr/bin/env python
#coding:utf-8

import urllib2;
import cookielib;
import urllib;
import re;
import sys;

regex=r'<div align="center"><h3>(\d*)公里</h3></div>&nbsp;</td>';
p = re.compile(regex)  

def extractData(p, content, index=1):  
    r = '0'  
    m = p.search(content)  
    if m:  
        r = m.group(index)  
    return r

def getHtml(from_city,to_city):

    '''
    http://juli.liecheshike.edu-hb.com/juli/?
    txtChufa=%E5%91%BC%E5%92%8C%E6%B5%A9%E7%89%B9
    &txtDaoda=%E5%BB%8A%E5%9D%8A
    &shikechaxun=%E8%B7%9D%E7%A6%BB%E6%9F%A5%E8%AF%A2
    '''
    #="http://search.huochepiao.com/juli/"
    url="http://www.56zhongguo.com/Tools/lc.asp"
    headers={"Content-Type":"text/html;charset=gb2312"}
    cap_postdata=urllib.urlencode({"fromareacode":from_city,"toareacode":to_city});
    #print cap_postdata;
    cap_request = urllib2.Request(url,cap_postdata,headers=headers);
    r = urllib2.urlopen(cap_request);
    #print r.read().decode('gbk');
    html=r.read();
    print html.decode('gb2312').encode('utf8');
    #lc=extractData(p, html, 1);
    print from_city+"\t"+to_city+"\t"+lc;

from_city=u"太原".encode("gb2312");
to_city=u"南京".encode("gb2312")
getHtml(from_city,to_city);

city_Arr=['乌鲁木齐','兰州','西宁','西安','银川','郑州','济南','太原','合肥','武汉','南京','成都','贵阳','昆明','南宁','拉萨','杭州','南昌','广州','福州','海口','长沙','大连','深圳','无锡','廊坊','厦门','青岛'];
city_to_Arr=['北京','上海','天津','重庆','哈尔滨','长春','沈阳','呼和浩特','石家庄','乌鲁木齐','兰州','西宁','西安','银川','郑州','济南','太原','合肥','武汉','南京','成都','贵阳','昆明','南宁','拉萨','杭州','南昌','广州','福州','海口','长沙','大连','深圳','无锡','廊坊','厦门','青岛'];

"""
for from_city in city_Arr:
    for to_city in city_to_Arr:
        #if cmp(from_city,to_city)==True:
            #print from_city+"\t"+to_city+"\r";
        getHtml(from_city,to_city);


"""
#cap_postdata=urllib.urlencode({"fromareacode":u"太原".encode("gb2312"),"toareacode":u"南京".encode("gb2312")});
#print cap_postdata;
