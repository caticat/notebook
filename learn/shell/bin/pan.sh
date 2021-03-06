#!/bin/bash

# 快捷执行各种命令的脚本

# 当前目录
binPath=$(dirname $0)

# 所有命令
declare -A commands=()
commands["1"]="ls"
commands["2"]="dir"
commands["h"]="help"
commands["help"]="help"
commands["uj"]="$binPath/job/upload_json.sh"
commands["uja"]="$binPath/job/upload_json.sh all"
commands["ujtd"]="$binPath/job/upload_json.sh td"
commands["mc"]="$binPath/job/my_cmake.sh"
commands["up"]="$binPath/job/update_proto.sh"
commands["ck"]="$binPath/job/checkout.sh"
commands["ckm"]="$binPath/job/checkout.sh master"
commands["ckw"]="$binPath/job/checkout.sh master_weekly"
commands["cktd"]="$binPath/job/checkout.sh tw_0.9.1_obt_dev"
commands["cktr"]="$binPath/job/checkout.sh tw_0.9.1_obt_rls"

# 常量配置
version="0.0.1"

# 通用函数
declare -A colors=(["none"]="\033[0m" ["black"]="\033[0;30m" ["red"]="\033[31m" ["green"]="\033[0;32m" ["yellow"]="\033[0;33m" ["blue"]="\033[0;34m" ["purple"]="\033[0;35m" ["lightblue"]="\033[0;36m" ["white"]="\033[0;37m")
showGreen()
{
	echo -e "${colors['green']}$1${colors['none']}\c"
}
showGreenN()
{
	echo -e "${colors['green']}$1${colors['none']}"
}
showYellow()
{
	echo -e "${colors['yellow']}$1${colors['none']}\c"
}
showYellowN()
{
	echo -e "${colors['yellow']}$1${colors['none']}"
}
showRed()
{
	echo -e "${colors['red']}$1${colors['none']}\c"
}
showRedN()
{
	echo -e "${colors['red']}$1${colors['none']}"
}
showVersion()
{
	showGreenN "Pan's shell script, version[$version]"
}
help()
{
	showGreenN "命令数量:${#commands[@]}"
	for c in ${!commands[@]}; do
		showGreen "\t$c\t"
		showYellowN "${commands[$c]}"
	done
}

# 参数校验
argsLen=$#
if [ $argsLen -eq 0 ]; then
	showVersion
	exit 0
fi

# 逻辑
case "$1" in
	version)
		showVersion
		;;
	*)
		command=${commands[$1]}
		if [ -z "$command" ]; then
			showRed "invalid command[$1]"
			exit 1
		else
			# echo $command
			if [ $argsLen -gt 1 ]; then
				args=$*
				args=${args#* }
				$command $args
			else
				$command
			fi
		fi
esac	
