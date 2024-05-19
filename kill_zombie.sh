#! /bin/bash
# 获取僵尸进程
all_zombie_ppid=$(ps -ef | grep defunct | grep -v grep | awk '{print $2}') 
# 存在僵尸进程，直接退出脚本
if [ -z "${all_zombie_ppid}" ];then
    exit 0
fi
# 存在进行循环，然后杀死
for i in $all_zombie_ppid
do
    kill -9 $i
done
exit 0