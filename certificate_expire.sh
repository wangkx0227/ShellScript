#! /bin/bash
url=检测网址
current_stamp=$(date +%s)
expire_date=$(curl -s -v ${url} 2>&1 | grep -E  'expire.*' | grep -o 'Dec.*')
time_stamp=$(date -d "${expire_date}" "+%s")

day=$[$((${time_stamp}/86400)) - $((${current_stamp}/86400))]


case $day in 
30)
	echo "你的证书还有30天到期"
	;;
20)
	echo "你的证书还有20天到期"
	;;
10)
	echo "你的证书还有10天到期"
	;;
esac