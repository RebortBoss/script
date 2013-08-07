import os
import sys
str = os.popen("ls -1 "+sys.path[0]+"/logs").read()
a = str.split("\n")
del a[-1]
for b in a:
   b1 = b.split(".")
   cur = int(os.popen("date +%s").read())
   b1t = int(b1[-1])
   if cur-b1t>1200:
       print b, cur, b1[-1], cur-b1t, os.popen("rm -f "+sys.path[0]+"/logs/"+b).read()
