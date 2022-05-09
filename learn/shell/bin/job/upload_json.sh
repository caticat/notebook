#!/bin/bash

# 上传json文件到指定远程服务器

# 获取远程地址
binPath=$(dirname $0)
source $binPath"/remote.sh"
echo $remoteHost

# 参数
# 本地目录
param=$1
if [ "$param" = "all" ]; then
    localPath="/C/Users/pan/Documents/job/004.配置/master/code/gamename"
elif [ "$param" = "week" ]; then
    localPath="/C/Users/pan/Documents/job/004.配置/master_weekly/code/gamename"
elif [ "$param" = "td" ]; then
    localPath="/C/Users/pan/Documents/job/004.配置/tw_0.9.1_obt_dev/code/gamename"
else
    localPath="/C/Users/pan/Documents/job/005.后端导表/serverJson"
fi
echo "上传目录[$localPath]"
# 远程目录
remotePath="/home/pan/workspace/runtime/bin/game"
echo "目标目录[$remotePath]"
# 临时文件
now=$(date +%s)
tmpFile="tmp$now.tar.bz2"
cd $localPath
tar -cjf $tmpFile *
# 传输
scp -P $remotePort $tmpFile $remoteHost:$remotePath
# 清理
rm $tmpFile
# 解压
ssh $remoteHost -p $remotePort "cd $remotePath && tar -xjf $tmpFile -C . && rm $tmpFile"
# 耗时计算
last=$(date +%s)
echo "耗时$((last - now))秒"

echo done
