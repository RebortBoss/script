#!/usr/bin/env python
#coding:utf-8
# Author:   --<zhoudd>
# Purpose: 
# Created: 2013年10月28日

import sys
import datetime;

def outPutFile():
    curtDate=datetime.date.today().strftime("%Y-%m-%d");
    file_name="业务量数据记录("+curtDate+").txt";
    capFile=open(file_name,'a+b');
    try:
        capFile.write("ddddd\n");
        capFile.write("fff\n");
        capFile.flush();
    finally:
        capFile.close();
   
   


if __name__=='__main__':
    outPutFile();