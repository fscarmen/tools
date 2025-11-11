#!/usr/bin/env bash

# 把 sing-box 的 xtls-reality 入站流控更改为 xtls-rprx-vision
[ ! -f /etc/sing-box/conf/11_xtls-reality_inbounds.json ] && echo '找不到 /etc/sing-box/conf/11_xtls-reality_inbounds.json 文件，无法更改流控！' && exit 1
grep -q 'xtls-rprx-vision' /etc/sing-box/conf/11_xtls-reality_inbounds.json && echo '已经是 xtls-rprx-vision 流控，不需要更改！' && exit 1
JSON=$(sed '1d' /etc/sing-box/conf/11_xtls-reality_inbounds.json)
JSON=$(/etc/sing-box/jq '.inbounds[0].users[0].flow = "xtls-rprx-vision" | .inbounds[0].multiplex.enabled = false | .inbounds[0].multiplex.padding = false | .inbounds[0].multiplex.brutal.enabled = false' <<< "$JSON" | sed 's/: /:/g')
JSON="$(head -1 /etc/sing-box/conf/11_xtls-reality_inbounds.json)"$'\n'"${JSON}"
sb -s
echo "$JSON" > /etc/sing-box/conf/11_xtls-reality_inbounds.json
sb -s
sb -n
echo '已成功将流控更改为 xtls-rprx-vision ！'
exit 0
