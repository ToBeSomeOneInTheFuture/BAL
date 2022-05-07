#!/bin/bash
result=`cut -f1 lib.txt |while read sample ;do ls -lh ./data/qiime_${sample}.e* ;done |awk -F ' ' '{if ($5 != 0 ) print $0}'`
if [ -z $result];then
	echo -e "Running analysis......\n"
	mkdir ./analysis/
	cd ./analysis/
	sh ../../tool/summary.sh ../lib.txt
else
	echo -e "Something wrong with qiime! Please check the result of qiime\n"
	exit 1
fi
