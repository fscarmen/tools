#!/usr/bin/env bash
TEMP_FILE='ip.temp'

red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }

ARCHITECTURE="$(uname -m)"
case $ARCHITECTURE in
x86_64 )  FILE=besttrace;;
aarch64 ) FILE=besttracearm;;
i386 )    FILE=besttracemac;;
* ) red " 只支持 AMD64、ARM64、Mac 使用，问题反馈:[https://github.com/fscarmen/tools/issues] " && exit 1;;
esac

ip=$1
green "\n 本脚说明：测 VPS ——> 对端 经过的地区及线路，填本地IP就是测回程，核心程序来由: https://www.ipip.net/ ，请知悉！"
[[ -z "$ip" || $ip = '[DESTINATION_IP]' ]] && reading "\n 请输入目的地 IP: " ip
green "\n 检测中，请稍等片刻。\n"
[[ ! -e "$FILE" ]] && wget -q https://cdn.jsdelivr.net/gh/fscarmen/tools/besttrace/$FILE > $TEMP_FILE
chmod +x "$FILE" >/dev/null 2>&1
sudo ./"$FILE" "$ip" -g cn > $TEMP_FILE
green "$(cat $TEMP_FILE | tail -n +3 | grep -vE ".*\*$" | awk '{print $(NF-4) $(NF-3) $(NF-2) $(NF-1) $NF}' 2>/dev/null | uniq | awk '{printf("%d,%s\n",NR,$0)}' | sed "s/\(AS[0-9]*\)//g")"
rm -f ip.temp
