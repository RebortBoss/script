#!/usr/bin/env python
#coding:utf-8

import urllib2;
import cookielib;
import urllib;
import datetime;
import sys;
import re;

########################################################################
class  Capture:
    """"""
    __data_url="http://house.baidu.com/sc/top/";    
    __curtDate=datetime.date.today().strftime("%Y-%m-%d"); 

    #----------------------------------------------------------------------
    def __init__(self):
        """ """
    
    def  capture(self):
        cap_request = urllib2.Request(self.__data_url);
        r = urllib2.urlopen(cap_request);
        html = r.read();
        curtDate=datetime.date.today().strftime("%Y-%m-%d");
        self.zd(html);
    
    def zd(self,content):
        ps = re.compile(r'<ul class="box2list">([\s\S]+?)</ul>');
        uls = ps.findall(content);
        for ul in uls:
            self.clUL(ul);

    def clUL(self,ul):
        p = re.compile(r'<li>([\s\S]+?)</li>');
        urls = p.findall(ul);
        for dt in urls:
            #print "-----------------------------------";
            self.sm(dt);
            #print "===================================";

    def sm(self,li):
        #print li;
        #print "++++++++++++++++++++++++++++++"
        sp = re.compile(r'<a.+href="(.*?/(\d+?)/)".+>(.+?)</a>(.|\n)*class="price.*".*>(.+?)</span>');
        arrd = sp.findall(li);
        if len(arrd)>0:
            #print arrd[0];
            print self.__curtDate +"\t"+arrd[0][0]+"\t"+arrd[0][1]+"\t"+arrd[0][2]+"\t"+arrd[0][4];

    
    
    
if __name__=='__main__':
    #print sys.getdefaultencoding();
    reload(sys)
    sys.setdefaultencoding('utf-8')
    #print sys.getdefaultencoding();
    c=Capture();
    c.capture();


