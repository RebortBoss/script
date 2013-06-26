#!/bin/bash
BP=`dirname $0`
jarFileName=tms_client_1.0.jar
Revision=`grepjar Svn-Revision $jarFileName |sed 's/META-INF\/MANIFEST.MF://g'`
last_changed_date=`grepjar Svn-Last_Changed_Date $jarFileName |sed 's/META-INF\/MANIFEST.MF://g'`
echo "$Revision -- $last_changed_date"

