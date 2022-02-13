# 自定义字体彩色，read 函数，友道翻译函数
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate(){ [[ -n "$1" ]] && curl -sm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$1" | cut -d \" -f18 2>/dev/null; }

install(){
	# 判断处理器架构
	case $(tr '[:upper:]' '[:lower:]' <<< "$(arch)") in
	aarch64 ) ARCHITECTURE=arm64;;	x86_64 ) ARCHITECTURE=amd64;;
	esac

	# 安装 docker, 拉取镜像+创建容器
	{ 
	green " \n Install docker \n " && ! systemctl is-active docker >/dev/null 2>&1 && curl -sSL get.docker.com | sh

	docker run -dit --restart=always --name wgcf --sysctl net.ipv6.conf.all.disable_ipv6=0 --device /dev/net/tun --entrypoint /run.sh --privileged --cap-add net_admin --cap-add sys_module --log-opt max-size=1m -v /etc/wireguard:/etc/wireguard -v /lib/modules:/lib/modules fscarmen/Netflix_unlock:amd64
	}&

	{
	# 判断 wgcf 的最新版本,如因 github 接口问题未能获取，默认 v2.2.11
	latest=$(wget -qO- -s4m8 "https://api.github.com/repos/ViRb3/wgcf/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g')
	latest=${latest:-'2.2.11'}

	# 安装 wgcf，尽量下载官方的最新版本，如官方 wgcf 下载不成功，将使用 jsDelivr 的 CDN，以更好的支持双栈。并添加执行权限
	wget -qO- -s4m8 -O /usr/local/bin/wgcf https://github.com/ViRb3/wgcf/releases/download/v"$latest"/wgcf_"$latest"_linux_$ARCHITECTURE ||
	wget -s4m8 -O /usr/local/bin/wgcf https://cdn.jsdelivr.net/gh/fscarmen/warp/wgcf_"$latest"_linux_$ARCHITECTURE
	chmod +x /usr/local/bin/wgcf

	# 注册 WARP 账户 ( wgcf-account.toml 使用默认值加加快速度)。如有 WARP+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
	mkdir -p /etc/wireguard/ >/dev/null 2>&1
	until [[ -e wgcf-account.toml ]] >/dev/null 2>&1; do
		wgcf register --accept-tos >/dev/null 2>&1 && break
	done
	[[ -n $LICENSE ]] && yellow " \n${T[${L}35]}\n " && sed -i "s/license_key.*/license_key = \"$LICENSE\"/g" wgcf-account.toml &&
	( wgcf update --name "$NAME" > /etc/wireguard/info.log 2>&1 || red " \n${T[${L}36]}\n " )

	# 生成 Wire-Guard 配置文件 (wgcf-profile.conf)
	[[ -e wgcf-account.toml ]] && wgcf generate >/dev/null 2>&1
	green " \n wgcf complete\n "

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

	[[ -e wgcf-profile.conf ]] && sed -i "s/MTU.*/MTU = $MTU/g" wgcf-profile.conf && green " \n MTU complete\n "
	sed -i "s/^.*\:\:\/0/#&/g;s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf
	mv wgcf-profile.conf /etc/wireguard/wgcf.conf
	rm -rf wgcf-profile.conf /usr/local/bin/wgcf
	}&

install
