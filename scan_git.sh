#! /bin/bash
path=/opt/source_code/
branch="当前需要监控的分支"
url="库地址"
if [ ! -d ${path} ];then
    mkdir -p ${path} && cd ${path} && git clone ${url} ${path}
    if [ $? -eq 0 ];then
        echo "ok"
    else
        echo "on"
    fi
else
    cd ${path}
    if [ $(git rev-list HEAD...${branch} --count) -gt 0 ]; then
        echo "仓库有新的更新！"
    else
        echo "仓库已是最新状态。"
    fi
fi

