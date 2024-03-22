#!/bin/bash
free_num=$(free -m | awk 'NR==2{print $4}')  # 内存还剩多少M
free_num1=$(free -m | awk 'NR==2{print $2}')
disk_num=$(df -h | grep '\/$' | awk '{print $2}' |grep -oE '^[0-9]{1,}') # 取出根分区还有多少G
if [ $free_num -lt 512 -o $disk_num -lt 1 ];then
	echo "当前内存少于512G,根分区少于1G,发邮件"
	echo -e "
	内存使用率：$(echo "scale=2;(${free_num} / ${free_num1})*100" | bc | grep -oE '^[0-9]{1,3}')%
	磁盘使用率：$(df -h | grep '\/$' | awk '{print $5}')
	cpu使用率：$[ 100 - $(sar 1 1 | awk '/Average/{print $NF}' |grep -oE '^[0-9]{1,3}') ]%
	"
	exit 1
else
	echo "系统正常~~~"
    echo -e "
    内存使用率：$(echo "scale=2;(${free_num} / ${free_num1})*100" | bc | grep -oE '^[0-9]{1,3}')%
    磁盘使用率：$(df -h | grep '\/$' | awk '{print $5}')
    cpu使用率：$[ 100 - $(sar 1 1 | awk '/Average/{print $NF}' |grep -oE '^[0-9]{1,3}') ]%
    "
    exit 0
fi