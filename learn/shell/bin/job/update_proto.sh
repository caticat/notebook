#!/bin/bash

# 更新protobuf

# 目录
binProto="/C/Users/pan/Documents/job/002.protobuf/protobuf-3.5.1-win32/bin/protoc.exe"
pathProto="/C/Users/pan/Documents/job/002.protobuf/proto"
pathOutput="/C/Users/pan/Documents/job/002.protobuf/out"
pathProject="/C/Users/pan/Documents/job/001.server/protobuf"

# 生成protobuf文件
echo "开始生成protobuf文件"
lisFile=$(ls $pathProto/*.proto)
for file in ${lisFile[@]}; do
	$binProto --proto_path=$pathProto --cpp_out=$pathOutput --csharp_out=$pathOutput $file
done

# 更新到项目目录
echo "更新protobuf文件到项目"
cd $pathOutput
cp -rf *.h $pathProject
cp -rf *.cc $pathProject
