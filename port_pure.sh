#!/usr/bin/env bash
ip=$1

[[ -z "$ip" ]] && echo -e "请填入 IPv4:PORT 或者 [IPv6]:PORT" && exit 1
[[ ! $ip =~ '.' ]] && STACK='6'

CN_35='深圳\t阿里云'; CN_40='北京\t阿里云'; CN_50='北京\t腾讯云'; CN_90='泉州\t电信CN2'; CN_103='江苏\t电信'; CN_104='江苏\t移动'; CN_105='江苏\t联通'; CN_150='杭州\t阿里云'; CN_160='青岛\t阿里云'; CN_210='上海\t阿里云'
result0='打开'; result1='关闭'

TOKEN=$(wget -qO- https://tcp$STACK.ping.pe/$ip | grep 'document.cookie' | sed "s/.*document.cookie=\"\([^;]\{1,\}\).*/\1/g")
STREAM_ID=$(wget -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/$ip | grep 'stream_id =' | cut -d \' -f2)
sleep 10
ALL=$(wget -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/ajax_getPingResults_v2.php?stream_id=$STREAM_ID)
AREA=($(echo $ALL | python3 -m json.tool | grep CN_ | cut -d \" -f4))
RESULT=($(echo $ALL | python3 -m json.tool | grep -A 2 CN_ | grep result | sed "s#[\":, ]##g"))

[[ -z ${AREA[@]} ]] && echo -e "ping.pe 暂时未提供中国地区测该 IP 端口状态的服务" && exit 1

echo -e "地方\tISP\t\t状态"
for ((i=0;i<${#AREA[@]};i++)); do echo -e "$(eval echo "\$${AREA[i]}")\t\t$(eval echo "\$${RESULT[i]}")"; done
