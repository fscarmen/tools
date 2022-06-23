#!/usr/bin/env bash
ip=$1
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }

green "\n 本脚说明：测端口状态:打开/关闭，核心服务来自: https://ping.pe/ ，请知悉！"
[[ -z "$ip" || $ip = '[IP:PORT]' ]] && reading "\n 请填入 IPv4:PORT 或者 [IPv6]:PORT, 端口不填默认为80: " ip
[[ ! $ip =~ '.' ]] && STACK='6'
yellow "\n 检测中，请稍等片刻。\n"

NODE_ID=('CN_35' 'CN_40' 'CN_50' 'CN_90' 'CN_103' 'CN_104' 'CN_105' 'CN_150' 'CN_160' 'CN_210')
NODE_ZH=('深圳\t 阿里云' '北京\t 阿里云' '北京\t 腾讯云' '泉州\t 电信CN2' '江苏\t 电信' '江苏\t 移动' '江苏\t 联通' '杭州\t 阿里云' '青岛\t 阿里云' '上海\t 阿里云')
result0='√'; result1='X'

TOKEN=$(wget -t1 -T5 -qO- https://tcp$STACK.ping.pe/$ip | grep 'document.cookie' | sed "s/.*document.cookie=\"\([^;]\{1,\}\).*/\1/g")
[ -z "$TOKEN" ] && red " 不能正常访问 ping.pe，请稍后再试，脚本退出。\n" && exit 1
STREAM_ID=$(wget -t1 -T5 -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/$ip | grep 'stream_id =' | cut -d \' -f2)
sleep 3
until [[ $ALL =~ 'TW_1' ]]; do
  sleep 2
  ((j++)) || true
  [[ $j = 5 ]] && break
  ALL=$(wget -t1 -T5 -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/ajax_getPingResults_v2.php?stream_id=$STREAM_ID)
done
[ -z "$ALL" ] && red " 获取不了数据，请输入正确的格式: IPv4:port, [IPv6]:port, 域名:port\n" && exit 1

yellow " 状态\t 地方\t ISP "
for ((i=0;i<${#NODE_ID[@]};i++)); do
  RESULT[i]=$(echo $ALL | python3 -m json.tool | grep -A 2 ${NODE_ID[i]} | grep result | sed "s#[\":, ]##g")
  RESULT[i]=${RESULT[i]:-'result1'}
  [[ ${RESULT[i]} = result0 ]] && COLOR=green || COLOR=red
  $COLOR " $(eval echo "\$${RESULT[i]}")\t ${NODE_ZH[i]} " 
done
