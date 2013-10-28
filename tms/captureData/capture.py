#!/usr/bin/env python
#coding:utf-8

import urllib2;
import cookielib;
import urllib;
import datetime;
import json;
import sys;

########################################################################
class  Capture:
    """"""
    __login_url="http://10.3.50.152:7011/tms/login.do?method=login";
    __data_url="http://10.3.50.152:7011/tms/mini/operationplan.OperationPlan/getMonitorTop";    
    
    #----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        self.__logIn();

    def __logIn(self):
        cookie = cookielib.CookieJar();
        opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie));
        postdata=urllib.urlencode({"name":"sys","password":"hollycrm"});
        user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0";
        headers = {'User-Agent':user_agent};
        urllib2.install_opener(opener);
        request = urllib2.Request(self.__login_url,postdata,headers = headers);
        urllib2.urlopen(request);
        
       
    def  capture(self,qdate=None):
        if qdate == None:
            qdate =     curtDate = datetime.date.today().strftime("%Y-%m-%d");
        #print "query_time=",qdate;
        cap_postdata=urllib.urlencode({"addr_code":"allProv","query_time":qdate,"dimension":"1"});
        cap_request = urllib2.Request(self.__data_url,cap_postdata);
        r = urllib2.urlopen(cap_request);
        data= json.loads(r.read());
        curtDate=datetime.date.today().strftime("%Y-%m-%d");
        file_name="业务量数据记录-"+curtDate+".txt";
        capFile=open(file_name,'a+b');
 
        cksj_sum =0;
        jkdd_sum =0;
        #print type(data["data"]);
        print >>capFile, "数据查询时间：",datetime.datetime.today().strftime("%Y-%m-%d %H:%M:%S");
        print >>capFile, "日期\t省\t出口-> 当日收件\t进口-> 到达";
        for row in data['data']:
            #row = data['data'][0];
            #日期,省,出口-> 当日收件,进口-> 到达
            if row["prov"]=="44" or row["prov"]=="32" :
                print >>capFile, row['fcdate'],"\t",row["prov_name"],"\t",row['cksj'],"\t",row['jkdd'];
            cksj_sum +=row['cksj'];
            jkdd_sum+=row['jkdd'];
            
        print >>capFile, "\t","当日累计","\t",cksj_sum,"\t",jkdd_sum;
        print >>capFile, "";

    
   

if __name__=='__main__':
    #print sys.getdefaultencoding();
    reload(sys)
    sys.setdefaultencoding('utf-8')
    #print sys.getdefaultencoding();
    c=Capture();
    c.capture();


