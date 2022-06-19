#!/usr/bin/env bash
ip=$1

[[ -z "$ip" ]] && echo -e "请填入 IPv4:PORT 或者 [IPv6]:PORT" && exit 1
[[ ! $ip =~ '.' ]] && STACK='6'

NODE_ID=('CN_35' 'CN_40' 'CN_50' 'CN_90' 'CN_103' 'CN_104' 'CN_105' 'CN_150' 'CN_160' 'CN_210')
NODE_ZH=('深圳\t阿里云 ' '北京\t阿里云 ' '北京\t腾讯云 ' '泉州\t电信CN2' '江苏\t电信 ' '江苏\t移动 ' '江苏\t联通 ' '杭州\t阿里云 ' '青岛\t阿里云 ' '上海\t阿里云 ')
result0='打开'; result1='关闭'

TOKEN=$(wget -qO- https://tcp$STACK.ping.pe/$ip | grep 'document.cookie' | sed "s/.*document.cookie=\"\([^;]\{1,\}\).*/\1/g")
STREAM_ID=$(wget -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/$ip | grep 'stream_id =' | cut -d \' -f2)
sleep 3
until [[ $ALL =~ 'TW_1' ]]; do
  unset ALL AREA RESULT
  sleep 2
  ((j++)) || true
  [[ $j = 5 ]] && break
  ALL=$(wget -qO- --header="cookie: $TOKEN" https://tcp$STACK.ping.pe/ajax_getPingResults_v2.php?stream_id=$STREAM_ID)
done

echo -e "地方\tISP\t\t状态"
for ((i=0;i<${#NODE_ID[@]};i++)); do
  RESULT[i]=$(echo $ALL | python3 -m json.tool | grep -A 2 ${NODE_ID[i]} | grep result | sed "s#[\":, ]##g")
  RESULT[i]=${RESULT[i]:-'result1'}
  echo -e "${NODE_ZH[i]}\t\t$(eval echo "\$${RESULT[i]}")"
done
