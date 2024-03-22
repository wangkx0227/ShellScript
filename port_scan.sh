ips=$1
if [ -z $(echo $ips | grep -E '^([0-9]+)\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$') ];then
    echo "ip输入错误"
    exit
fi
ping -c 1 -w 1  ${ips} > /dev/null 2>&1
if [ $? -ne 0 ];then
    echo "ip ping不通"
    exit
fi

function if_num(){

    if [ -z $(echo $1 | grep -E ^[0-9]+$) ];then
        echo -e "位置参数传入错误~~~" 
        exit
    fi
}

if [ $# -ne 3 ];then
    echo "Usage: $0 start-val end-val"
    exit
fi

port_num_start=$2
if_num $port_num_start

port_num_end=$3
if_num $port_num_end

_port_num=$[ $3 - $2]

echo ${_port_num}
if [ ${_port_num} -ge  1024  ];then
        echo "范围必须小于1024"
        exit
fi



file_path=/opt/port_run.log

if [ ! -f ${file_path} ];then
    echo "创建存储文件~~~"
    touch  ${file_path}
else
    # 清空
    echo "清空文件~~~"
    > ${file_path}
fi

curl_port(){
        curl -I -s -o /dev/null -m 1 ${ips}:${1}
        if [ $? -eq 0 ];then
           echo "端口:${1}开起"
           echo "端口:${1}开起" >> $file_path
        fi
}


for i in  $(seq ${port_num_start} ${port_num_end})
do
        curl_port $i &

done
wait # 等待全部的子进程执行完毕后，在开始下面的操作
echo "当前$ips，开起了$(wc -l $file_path)数量的端口"