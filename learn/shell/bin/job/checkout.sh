#!/bin/bash

# 切分支直接调用mc命令覆盖cmake

# 切分支
git checkout $*

# 使用自己的cmake
pan.sh mc
