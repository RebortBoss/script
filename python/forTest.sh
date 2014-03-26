#!/bin/bash
arr=123,456,222,123
for i in ${arr//,/ } ;do
	echo $i
done;
