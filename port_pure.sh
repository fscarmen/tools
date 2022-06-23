#!/usr/bin/env bash
ip=$1

[[ -z "$ip" ]] && echo -e "请填入 IPv4:PORT 或者 [IPv6]:PORT" && exit 1
[[ ! $ip =~ '.' ]] && STACK='6'

NODE_ID=('CN_35' 'CN_40' 'CN_50' 'CN_90' 'CN_103' 'CN_104' 'CN_105' 'CN_150' 'CN_160' 'CN_210')
NODE_ZH=('深圳 阿里云' '北京 阿里云' '北京 腾讯云' '泉州 电信CN2' '江苏 电信' '江苏 移动' '江苏 联通' '杭州 阿里云' '青岛 阿里云' '上海 阿里云')
result0='🟢'; result1='🔴'
TOKEN=$(wget -t1 -T5 -qO- https://tcp$STACK.ping.pe/$ip | grep 'document.cookie' | sed "s/.*document.cookie=\"\([^;]\{1,\}\).*/\1/g")
[ -z "$TOKEN" ] && printf "不能正常访问 ping.pe，请稍后再试，脚本退出。\n" && exit 1
STREAM_ID=$(wget -t1 -T5 -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/$ip | grep 'stream_id =' | cut -d \' -f2)
sleep 3
until [[ $ALL =~ 'TW_1' ]]; do
  unset ALL AREA RESULT
  sleep 2
  ((j++)) || true
  [[ $j = 5 ]] && break
  ALL=$(wget -t1 -T5 -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/ajax_getPingResults_v2.php?stream_id=$STREAM_ID)
done
[ -z "$ALL" ] && printf "获取不了数据，请输入正确的格式: IPv4:port, [IPv6]:port, 域名:port\n" && exit 1

printf "%-10s %-10s %-10s\n" 状态 地方 ISP
for ((i=0;i<${#NODE_ID[@]};i++)); do
  RESULT[i]=$(echo $ALL | python3 -m json.tool | grep -A 2 ${NODE_ID[i]} | grep result | sed "s#[\":, ]##g")
  RESULT[i]=${RESULT[i]:-'result1'}
  printf "%-10s %-10s %-10s\n" $(eval echo "\$${RESULT[i]}") ${NODE_ZH[i]} 
done
