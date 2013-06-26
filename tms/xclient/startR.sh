#!/bin/bash

for (( i = 0; i < $1; i++)); do
	`dirname $0`/client.sh -r
	echo $i
	sleep 1
done;
