#!/bin/bash
#create 2013-10-30
#filename batch.sh
#--------------
#批量执行hadoop_home.vim中的vim命令
#usage batch.sh <path>

usage(){
    echo "
usage:
  ${0##*/} <path> 
    ";
    exit 1;
}
if [ $# -eq 0 ];then
    usage;
fi;

BP=$(dirname $0)
CP="";
if [ "${1:0:1}" == "/" ];then
 #echo "$1"
 CP="$1"
else
 #echo $BP/$1
 CP="$BP/$1"
fi;

replace_str(){
    #vim -S $BP/hadoop_home.vim $1
    echo $1
    if [ "${1##*.}" != "vim" ];then
        vim -S $BP/hadoop_home.vim $1
    fi;
}
loop_path(){
    for file in `ls -a $1`;do
        if [ "$file" != "." -a "$file" != ".." ];then
            if [ -d "$1/$file" ];then
                loop_path "$1/$file";
            else
                replace_str "$1/$file";
            fi;
        fi;
    done;
}

loop_path "$CP";
