#!/bin/sh
file_name="业务量数据记录-`date -d '1 days ago' +'%Y-%m-%d'`.txt"
echo "$file_name"
cat /opt/test/$file_name | /usr/local/bin/mutt -s "$file_name" xxx@xxx.com.cn,xxx@xxx.com,xxx@xxx.com
