#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/bin
export LANG=en_US.UTF-8

# 自定义字体彩色，read 函数，友道翻译函数
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate(){ [[ -n "$1" ]] && curl -sm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$1" | cut -d \" -f18 2>/dev/null; }

wgcf_install(){
	# 判断处理器架构
	case $(tr '[:upper:]' '[:lower:]' <<< "$(arch)") in
	aarch64 ) ARCHITECTURE=arm64;;	x86_64 ) ARCHITECTURE=amd64;;
	esac

	# 安装 docker, 拉取镜像+创建容器

	green " \n Install docker \n " && ! systemctl is-active docker >/dev/null 2>&1 && curl -sSL get.docker.com | sh

	docker run -dit --restart=always --name wgcf --sysctl net.ipv6.conf.all.disable_ipv6=0 --device /dev/net/tun --privileged --cap-add net_admin --cap-add sys_module --log-opt max-size=1m -v /etc/wireguard:/etc/wireguard -v /lib/modules:/lib/modules fscarmen/netflix_unlock:amd64


	# 判断 wgcf 的最新版本,如因 github 接口问题未能获取，默认 v2.2.11
	latest=$(wget -qO- -4 "https://api.github.com/repos/ViRb3/wgcf/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g')
	latest=${latest:-'2.2.11'}

	# 安装 wgcf，尽量下载官方的最新版本，如官方 wgcf 下载不成功，将使用 jsDelivr 的 CDN，以更好的支持双栈。并添加执行权限
	wget -4q -O /usr/local/bin/wgcf https://github.com/ViRb3/wgcf/releases/download/v"$latest"/wgcf_"$latest"_linux_$ARCHITECTURE ||
	wget -4q -O /usr/local/bin/wgcf https://cdn.jsdelivr.net/gh/fscarmen/warp/wgcf_"$latest"_linux_$ARCHITECTURE
	chmod +x /usr/local/bin/wgcf

	# 注册 WARP 账户 ( wgcf-account.toml 使用默认值加加快速度)。如有 WARP+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
	echo -e "wg-quick up wgcf\ncrond\n/etc/wireguard/gost -L :40000" > /etc/wireguard/run.sh; chmod +x /etc/wireguard/run.sh
	until [[ -e wgcf-account.toml ]] >/dev/null 2>&1; do
		wgcf register --accept-tos >/dev/null 2>&1 && break
	done
	[[ -n $LICENSE ]] && yellow " \n${T[${L}35]}\n " && sed -i "s/license_key.*/license_key = \"$LICENSE\"/g" wgcf-account.toml &&
	( wgcf update --name "$NAME" > /etc/wireguard/info.log 2>&1 || red " \n${T[${L}36]}\n " )

	# 生成 Wire-Guard 配置文件 (wgcf-profile.conf)
	[[ -e wgcf-account.toml ]] && wgcf generate >/dev/null 2>&1

	# 反复测试最佳 MTU。 Wireguard Header：IPv4=60 bytes,IPv6=80 bytes，1280 ≤1 MTU ≤ 1420。 ping = 8(ICMP回显示请求和回显应答报文格式长度) + 20(IP首部) 。
	# 详细说明：<[WireGuard] Header / MTU sizes for Wireguard>：https://lists.zx2c4.com/pipermail/wireguard/2017-December/002201.html
	MTU=$((1500-28))
	ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	until [[ $? = 0 || $MTU -le $((1280+80-28)) ]]
	do
	MTU=$((MTU-10))
	ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	done

	if [[ $MTU -eq $((1500-28)) ]]; then MTU=$MTU
	elif [[ $MTU -le $((1280+80-28)) ]]; then MTU=$((1280+80-28))
	else
		for ((i=0; i<9; i++)); do
		(( MTU++ ))
		ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1 || break
		done
		(( MTU-- ))
	fi

	MTU=$((MTU+28-80))

	[[ -e wgcf-profile.conf ]] && sed -i "s/MTU.*/MTU = $MTU/g" wgcf-profile.conf
	sed -i "s/^.*\:\:\/0/#&/g;s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf
	mv wgcf-profile.conf /etc/wireguard/wgcf.conf

	wget -4q https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz
	gzip -df gost-linux-amd64-2.11.1.gz
	mv gost-linux-amd64-2.11.1 /etc/wireguard/gost
	chmod +x /etc/wireguard/gost
	rm -rf wgcf-profile.conf /usr/local/bin/wgcf gost-linux-amd64
	
	green " Run [ docker exec -it wgcf bash /etc/wireguard/run.sh & ]" 

}

# 期望解锁地区
input_region(){
	if [[ -z "$EXPECT" ]]; then
	REGION=$(curl -sm8 https://ip.gs/country-iso 2>/dev/null)
	reading " The current region is $REGION. Confirm press [y] . If you want another regions, please enter the two-digit region abbreviation. (such as hk,sg. Default is $REGION): " EXPECT
	until [[ -z $EXPECT || $EXPECT = [Yy] || $EXPECT =~ ^[A-Za-z]{2}$ ]]; do
		reading " The current region is $REGION. Confirm press [y] . If you want another regions, please enter the two-digit region abbreviation. (such as hk,sg. Default is $REGION): " EXPECT
	done
	[[ -z $EXPECT || $EXPECT = [Yy] ]] && EXPECT="$REGION"
	fi
	}
  
# Telegram Bot 日志推送
input_tg(){
	[[ -z $CUSTOM ]] && reading " Please enter Bot Token if you need push the logs to Telegram. Leave blank to skip: " TOKEN
	[[ -n $TOKEN && -z $USERID ]] && reading " Enter USERID: " USERID
	[[ -n $USERID && -z $CUSTOM ]] && reading " Enter custom name: " CUSTOM
	}

# 生成解锁文件
export_unlock_file(){

input_region

input_tg

# 生成解锁情况文件和 docker 运行文件
mkdir -p /etc/wireguard/ >/dev/null 2>&1
echo 'null' > /etc/wireguard/status.log

# 生成 warp_unlock.sh 文件，判断当前流媒体解锁状态，遇到不解锁时更换 WARP IP，直至刷成功。5分钟后还没有刷成功，将不会重复该进程而浪费系统资源
cat <<EOF >/etc/wireguard/warp_unlock.sh
EXPECT="$EXPECT"
TOKEN="$TOKEN"
USERID="$USERID"
CUSTOM="$CUSTOM"
NIC="-s4m8"
RESTART="wgcf_restart"
LOG_LIMIT="1000"
UNLOCK_STATUS='Yes 🎉'
NOT_UNLOCK_STATUS='No 😰'
timedatectl set-timezone Asia/Shanghai
if [[ \$(pgrep -laf ^[/d]*bash.*warp_unlock | awk -F, '{a[\$2]++}END{for (i in a) print i" "a[i]}') -le 2 ]]; then
log_output="\\\$(date +'%F %T'). \\\\\tIP: \\\$WAN \\\\\tCountry: \\\$COUNTRY \\\\\t\\\$CONTENT"
tg_output="💻 \\\$CUSTOM. ⏰ \\\$(date +'%F %T'). 🛰 \\\$WAN  🌏 \\\$COUNTRY. \\\$CONTENT"
log_message(){ echo -e "\$(eval echo "\$log_output")" | tee -a /etc/wireguard/result.log; [[ \$(cat /etc/wireguard/result.log | wc -l) -gt \$LOG_LIMIT ]] && sed -i "1,10d" /etc/wireguard/result.log; }
tg_message(){ curl -s -X POST "https://api.telegram.org/bot\$TOKEN/sendMessage" -d chat_id=\$USERID -d text="\$(eval echo "\$tg_output")" -d parse_mode="HTML" >/dev/null 2>&1; }

ip(){
unset IP_INFO WAN COUNTRY ASNORG
IP_INFO="\$(curl \$NIC https://ip.gs/json 2>/dev/null)"
WAN=\$(expr "\$IP_INFO" : '.*ip\":\"\([^"]*\).*')
COUNTRY=\$(expr "\$IP_INFO" : '.*country\":\"\([^"]*\).*')
ASNORG=\$(expr "\$IP_INFO" : '.*asn_org\":\"\([^"]*\).*')
}

wgcf_restart(){ wg-quick down wgcf >/dev/null 2>&1; wg-quick up wgcf >/dev/null 2>&1; sleep 5; ip; }

check0(){
RESULT[0]=""; REGION[0]=""; R[0]="";
RESULT[0]=\$(curl --user-agent "\${UA_Browser}" \$NIC -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567"  2>&1)
if [[ \${RESULT[0]} = 200 ]]; then
REGION[0]=\$(curl --user-agent "\${UA_Browser}" \$NIC -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g' | tr '[:lower:]' '[:upper:]')
REGION[0]=\${REGION[0]:-'US'}
fi
echo "\${REGION[0]}" | grep -qi "\$EXPECT" && R[0]="\$UNLOCK_STATUS" || R[0]="\$NOT_UNLOCK_STATUS"
CONTENT="Netflix: \${R[0]}."
log_message
[[ -n "\$CUSTOM" ]] && [[ \${R[0]} != \$(sed -n '1p' /etc/wireguard/status.log) ]] && tg_message
sed -i "1s/.*/\${R[0]}/" /etc/wireguard/status.log
}
check1(){
unset PreAssertion assertion disneycookie TokenContent isBanned is403 fakecontent refreshToken disneycontent tmpresult previewcheck isUnabailable region inSupportedLocation
R[1]=""
PreAssertion=\$(curl \$NIC --user-agent "\${UA_Browser}" -s --max-time 10 -X POST "https://global.edge.bamgrid.com/devices" -H "authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -H "content-type: application/json; charset=UTF-8" -d '{"deviceFamily":"browser","applicationRuntime":"chrome","deviceProfile":"windows","attributes":{}}' 2>&1)
[[ "\$PreAssertion" == "curl"* ]] && R[1]="\$NOT_UNLOCK_STATUS"
if [[ \${R[1]} != "\$NOT_UNLOCK_STATUS" ]]; then
assertion=\$(echo \$PreAssertion | python -m json.tool 2> /dev/null | grep assertion | cut -f4 -d'"')
PreDisneyCookie=\$(curl -s --max-time 10 "https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/cookies" | sed -n '1p')
disneycookie=\$(echo \$PreDisneyCookie | sed "s/DISNEYASSERTION/\${assertion}/g")
TokenContent=\$(curl \$NIC --user-agent "\${UA_Browser}" -s --max-time 10 -X POST "https://global.edge.bamgrid.com/token" -H "authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -d "\$disneycookie")
isBanned=\$(echo \$TokenContent | python -m json.tool 2> /dev/null | grep 'forbidden-location')
is403=\$(echo \$TokenContent | grep '403 ERROR')
[[ -n "\$isBanned\$is403" ]] && R[1]="\$NOT_UNLOCK_STATUS"
fi
if [[ \${R[1]} != "\$NOT_UNLOCK_STATUS" ]]; then
fakecontent=\$(curl -s --max-time 10 "https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/cookies" | sed -n '8p')
refreshToken=\$(echo \$TokenContent | python -m json.tool 2> /dev/null | grep 'refresh_token' | awk '{print \$2}' | cut -f2 -d'"')
disneycontent=\$(echo \$fakecontent | sed "s/ILOVEDISNEY/\${refreshToken}/g")
tmpresult=\$(curl \$NIC --user-agent "\${UA_Browser}" -X POST -sSL --max-time 10 "https://disney.api.edge.bamgrid.com/graph/v1/device/graphql" -H "authorization: ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -d "\$disneycontent" 2>&1)
previewcheck=\$(curl \$NIC -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://disneyplus.com" | grep preview)
isUnabailable=\$(echo \$previewcheck | grep 'unavailable')      
region=\$(echo \$tmpresult | python -m json.tool 2> /dev/null | grep 'countryCode' | cut -f4 -d'"')
inSupportedLocation=\$(echo \$tmpresult | python -m json.tool 2> /dev/null | grep 'inSupportedLocation' | awk '{print \$2}' | cut -f1 -d',')
[[ "\$region" == "JP" || ( -n "\$region" && "\$inSupportedLocation" == "true" ) ]] && R[1]="\$UNLOCK_STATUS" || R[1]="\$NOT_UNLOCK_STATUS"
fi
CONTENT="Disney+: \${R[1]}."
log_message
[[ -n "\$CUSTOM" ]] && [[ \${R[1]} != \$(sed -n '2p' /etc/wireguard/status.log) ]] && tg_message
sed -i "2s/.*/\${R[1]}/" /etc/wireguard/status.log
}

ip
CONTENT='Script runs.'
log_message
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x6*4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
[[ ! \${R[*]} =~ 'No' ]] && check0
until [[ ! \${R[*]}  =~ "\$NOT_UNLOCK_STATUS" ]]; do
unset R
\$RESTART
[[ ! \${R[*]} =~ 'No' ]] && check0
done

fi
EOF
}

export_unlock_file
wgcf_install
