#!/bin/bash

# 使用自己的cmake

# 目录
pathProject="/C/Users/pan/Documents/job/001.server"
pathMyCMake="/C/Users/pan/bin/job/my_cmake"

cd $pathProject
cp -rf $pathMyCMake/* .
git update-index --assume-unchanged CMakeLists.txt GateServer/CMakeLists.txt gamename/CMakeLists.txt WorldServer/CMakeLists.txt
