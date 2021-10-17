# 当前脚本版本号和新增功能
VERSION=2.05
TXT="1)WGCF升级为最新的2.2.9； 2）升级了重启后运行 Warp 的处理方法，不再依赖另外的文件。如果之前曾经运行本脚本的，可以输入以下命令删除旧的和升级：sed -i '/WARP_AutoUp/d' /etc/crontab; grep -qE '^@reboot[ ]*root[ ]*warp[ ]*n' /etc/crontab || echo '@reboot root warp n' >> /etc/crontab; rm -f /etc/wireguard/WARP_AutoUp.sh"

help(){
	yellow " warp h (帮助菜单）\n warp o (临时warp开关)\n warp u (卸载warp)\n warp b (升级内核、开启BBR及DD)\n warp d (免费 WARP 账户升级 WARP+ )\n warp d N5670ljg-sS9jD334-6o6g4M9F ( 指定 License 升级 Warp+)\n warp p (刷WARP+流量)\n warp v (同步脚本至最新版本)\n warp 1 (Warp单栈)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F ( 指定 Warp+ License Warp 单栈)\n warp 2 (Warp双栈)\n warp 2 N5670ljg-sS9jD334-6o6g4M9F ( 指定 Warp+ License Warp 双栈)\n " 
	}

# 字体彩色
red(){
	echo -e "\033[31m\033[01m$1\033[0m"
    }
green(){
	echo -e "\033[32m\033[01m$1\033[0m"
    }
yellow(){
	echo -e "\033[33m\033[01m$1\033[0m"
}

# 判断是否大陆 VPS，如连不通 CloudFlare 的 IP，则 WARP 项目不可用
ping -c1 -W1 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && CDN=-6 || IPV6=0
ping -c1 -W1 162.159.192.1 >/dev/null 2>&1 && IPV4=1 && CDN=-4 || IPV4=0
if [[ $IPV4$IPV6 = 00 ]]; then
	if [[ -n $(wg) ]]; then
		wg-quick down wgcf >/dev/null 2>&1
		kill $(pgrep -f wireguard) >/dev/null 2>&1
		kill $(pgrep -f boringtun) >/dev/null 2>&1
		ping -c1 -W1 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && CDN=-6 || IPV6=0
		ping -c1 -W1 162.159.192.1 >/dev/null 2>&1 && IPV4=1 && CDN=-4 || IPV4=0
	else
		red " 与 WARP 的服务器不能连接,可能是大陆 VPS，可手动 ping 162.159.192.1 和 2606:4700:d0::a29f:c001，如能连通可再次运行脚本 "
		exit 1
	fi
fi

# 判断操作系统，只支持 Debian、Ubuntu 或 Centos,如非上述操作系统，删除临时文件，退出脚本
SYS=$(hostnamectl | tr A-Z a-z | grep system)
[[ $SYS =~ debian ]] && SYSTEM=debian
[[ $SYS =~ ubuntu ]] && SYSTEM=ubuntu
[[ $SYS =~ centos ]] && SYSTEM=centos
[[ -z $SYSTEM ]] && red " 本脚本只支持 Debian、Ubuntu 或 CentOS 系统,问题反馈:[https://github.com/fscarmen/warp/issues] " && exit 1

# 必须以root运行脚本
[[ $(id -u) != 0 ]] && red " 必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/warp/issues]" && exit 1

green " 检查环境中…… "

# 安装 curl
[[ ! $(type -P curl) ]] && 
( yellow " 安装curl中…… " && (apt -y install curl >/dev/null 2>&1 || yum -y install curl >/dev/null 2>&1) || 
( yellow " 先升级软件库才能继续安装 curl，时间较长，请耐心等待…… " && apt -y update >/dev/null 2>&1 && apt -y install curl >/dev/null 2>&1 || 
( yum -y update >/dev/null 2>&1 && yum -y install curl >/dev/null 2>&1 || ( yellow " 安装 curl 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues] " && exit 1 ))))

# 判断处理器架构
[[ $(hostnamectl | tr A-Z a-z | grep architecture) =~ arm ]] && ARCHITECTURE=arm64 || ARCHITECTURE=amd64

# 判断虚拟化，选择 Wireguard内核模块 还是 Wireguard-Go/BoringTun
[[ $(hostnamectl | tr A-Z a-z | grep virtualization) =~ openvz|lxc ]] && LXC=1
[[ $LXC = 1 && -e /usr/bin/boringtun ]] && UP='WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun WG_SUDO=1 wg-quick up wgcf' || UP='wg-quick up wgcf'
[[ $LXC = 1 && -e /usr/bin/boringtun ]] && DOWN='wg-quick down wgcf && kill $(pgrep -f boringtun)' || DOWN='wg-quick down wgcf'

# 判断当前 IPv4 与 IPv6 ，归属 及 WARP 是否开启
[[ $IPV4 = 1 ]] && LAN4=$(ip route get 162.159.192.1 2>/dev/null | grep -oP 'src \K\S+') &&
		WAN4=$(curl -s4  https://ip.gs) &&
		COUNTRY4=$(curl -s4 https://ip.gs/country) &&
		TRACE4=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)				
[[ $IPV6 = 1 ]] && LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | grep -oP 'src \K\S+') &&
		WAN6=$(curl -s6  https://ip.gs) &&
		COUNTRY6=$(curl -s6 https://ip.gs/country) &&
		TRACE6=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)

# 判断当前 WARP 状态，决定变量 PLAN，变量 PLAN 含义：1=单栈,	2=双栈,	3=WARP已开启
[[ $TRACE4 = plus || $TRACE4 = on || $TRACE6 = plus || $TRACE6 = on ]] && PLAN=3 || PLAN=$(($IPV4+$IPV6))

# 在KVM的前提下，判断 Linux 版本是否小于 5.6，如是则安装 wireguard 内核模块，变量 WG=1。由于 linux 不能直接用小数作比较，所以用 （主版本号 * 100 + 次版本号 ）与 506 作比较
[[ $LXC != 1 && $(($(uname  -r | cut -d . -f1) * 100 +  $(uname  -r | cut -d . -f2))) -lt 506 ]] && WG=1

# WGCF 配置修改，其中用到的 162.159.192.1 和 2606:4700:d0::a29f:c001 均是 engage.cloudflareclient.com 的IP
MODIFYS01='sed -i "/\:\:\/0/d" wgcf-profile.conf && sed -i "s/engage.cloudflareclient.com/[2606:4700:d0::a29f:c001]/g" wgcf-profile.conf'
MODIFYD01='sed -i "7 s/^/PostUp = ip -6 rule add from '$LAN6' lookup main\n/" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from '$LAN6' lookup main\n/" wgcf-profile.conf && sed -i "s/engage.cloudflareclient.com/[2606:4700:d0::a29f:c001]/g" wgcf-profile.conf && sed -i "s/1.1.1.1/1.1.1.1,9.9.9.9,8.8.8.8/g" wgcf-profile.conf'
MODIFYS10='sed -i "/0\.\0\/0/d" wgcf-profile.conf && sed -i "s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf && sed -i "s/1.1.1.1/9.9.9.9,8.8.8.8,1.1.1.1/g" wgcf-profile.conf'
MODIFYD10='sed -i "7 s/^/PostUp = ip -4 rule add from '$LAN4' lookup main\n/" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -4 rule delete from '$LAN4' lookup main\n/" wgcf-profile.conf && sed -i "s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf && sed -i "s/1.1.1.1/9.9.9.9,8.8.8.8,1.1.1.1/g" wgcf-profile.conf'
MODIFYD11='sed -i "7 s/^/PostUp = ip -4 rule add from '$LAN4' lookup main\n/" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -4 rule delete from '$LAN4' lookup main\n/" wgcf-profile.conf && sed -i "9 s/^/PostUp = ip -6 rule add from '$LAN6' lookup main\n/" wgcf-profile.conf && sed -i "10 s/^/PostDown = ip -6 rule delete from '$LAN6' lookup main\n/" wgcf-profile.conf && sed -i "s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf && sed -i "s/1.1.1.1/9.9.9.9,8.8.8.8,1.1.1.1/g" wgcf-profile.conf'

# 由于warp bug，有时候获取不了ip地址，加入刷网络脚本手动运行，并在定时任务加设置 VPS 重启后自动运行,i=当前尝试次数，j=要尝试的次数
net(){
	[[ ! $(type -P wg-quick) || ! -e /etc/wireguard/wgcf.conf ]] && red " 没有安装 WireGuard tools 或者找不到配置文件 wgcf.conf，请重新安装 " && exit 1 ||
	i=1;j=10
	yellow " 后台获取 WARP IP 中,最大尝试$j次……  "
	yellow " 第$i次尝试 "
	echo $UP | sh >/dev/null 2>&1
	WAN4=$(curl -s4m10 https://ip.gs) &&
	WAN6=$(curl -s6m10 https://ip.gs)
	until [[ -n $WAN4 && -n $WAN6 ]]
		do	let i++
			yellow " 第$i次尝试 "
			echo $DOWN | sh >/dev/null 2>&1
			echo $UP | sh >/dev/null 2>&1
			WAN4=$(curl -s4m10 https://ip.gs) &&
			WAN6=$(curl -s6m10 https://ip.gs)
			[[ $i = $j ]] && (echo $DOWN | sh >/dev/null 2>&1; red " 失败已超过$i次，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues] ") && exit 1
        	done
green " 已成功获取 WARP 网络\n IPv4:$WAN4\n IPv6:$WAN6 "
	}

# WARP 开关
onoff(){
	[[ -n $(wg) ]] 2>/dev/null && echo $DOWN | sh >/dev/null 2>&1 && green " 已暂停 WARP，再次开启可以用 warp o " || net
	}

# VPS 当前状态
status(){
	clear
	yellow "本项目专为 VPS 添加 wgcf 网络接口，详细说明：[https://github.com/fscarmen/warp]\n脚本特点:\n	* 支持 Warp+ 账户，附带第三方刷 Warp+ 流量和升级内核 BBR 脚本\n	* 普通用户友好的菜单，进阶者通过后缀选项快速搭建\n	* 智能判断vps操作系统：Ubuntu 18.04、Ubuntu 20.04、Debian 10、Debian 11、CentOS 7、CentOS 8，请务必选择 LTS 系统；智能判断硬件结构类型：AMD 或者 ARM\n	* 结合 Linux 版本和虚拟化方式，自动优选三个 WireGuard 方案。网络性能方面：内核集成 WireGuard＞安装内核模块＞boringtun＞wireguard-go\n	* 智能判断 WGCF 作者 github库的最新版本 （Latest release）\n	* 智能分析内网和公网IP生成 WGCF 配置文件\n	* 输出执行结果，提示是否使用 WARP IP ，IP 归属地\n"
	red "======================================================================================================================\n"
	green " 脚本版本：$VERSION  功能新增：$TXT\n 系统信息：\n	当前操作系统：$(hostnamectl | grep -i operating | cut -d : -f2)\n	内核：$(uname -r)\n	处理器架构：$ARCHITECTURE\n	虚拟化：$(hostnamectl | grep -i virtualization | cut -d : -f2) "
	[[ $TRACE4 = plus ]] && green "	IPv4：$WAN4 ( WARP+ IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = on ]] && green "	IPv4：$WAN4 ( WARP IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = off ]] && green "	IPv4：$WAN4 $COUNTRY4 "
	[[ $TRACE6 = plus ]] && green "	IPv6：$WAN6 ( WARP+ IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = on ]] && green "	IPv6：$WAN6 ( WARP IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = off ]] && green "	IPv6：$WAN6 $COUNTRY6 "
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green "	WARP+ 已开启	设备名：$(grep name /etc/wireguard/info.log 2>/dev/null | awk '{ print $NF }') "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green "	WARP 已开启" 	
	[[ $TRACE4 = off && $TRACE6 = off ]] && green "	WARP 未开启"
 	red "\n======================================================================================================================\n"
	}

# WGCF 安装
install(){
	# 脚本开始时间
	start=$(date +%s)
	
	# 输入 Warp+ 账户（如有），限制位数为空或者26位以防输入错误
	[[ -z $LICENSE ]] && read -p " 如有 Warp+ License 请输入，没有可回车继续: " LICENSE
	i=5
	until [[ -z $LICENSE || ${#LICENSE} = 26 ]]
		do
			let i--
			[[ $i = 0 ]] && red " 输入错误达5次，脚本退出 " && exit 1 || read -p " License 应为26位字符，请重新输入 Warp+ License，没有可回车继续（剩余$i次）: " LICENSE
		done

	# OpenVZ / LXC 选择 Wireguard-GO 或者 BoringTun 方案，如选 BoringTun ,重新定义 UP 和 DOWN 指令
	[[ $LXC = 1 ]] && read -p " LXC方案:1. Wireguard-GO 或者 2. BoringTun （默认值选项为 1）,请选择:" BORINGTUN
	[[ $BORINGTUN = 2 ]] && UP='WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun WG_SUDO=1 wg-quick up wgcf'
	[[ $BORINGTUN = 2 ]] && DOWN='wg-quick down wgcf && kill $(pgrep -f boringtun)'
	[[ $BORINGTUN = 2 ]] && WB=boringtun || WB=wireguard-go
	
	green " 进度  1/3： 安装系统依赖 "
	
	# 先删除之前安装，可能导致失败的文件，添加环境变量
	rm -rf /usr/local/bin/wgcf /etc/wireguard /usr/bin/boringtun /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf /usr/bin/warp
	[[ $PATH =~ /usr/local/bin ]] || export PATH=$PATH:/usr/local/bin
	
        # 根据系统选择需要安装的依赖
	debian(){
		# 更新源
		apt -y update

		# 添加 backports 源,之后才能安装 wireguard-tools 
		apt -y install lsb-release
		echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" > /etc/apt/sources.list.d/backports.list

		# 再次更新源
		apt -y update

		# 安装一些必要的网络工具包和wireguard-tools (Wire-Guard 配置工具：wg、wg-quick)
		apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools

		# 如 Linux 版本低于5.6并且是 kvm，则安装 wireguard 内核模块
		[[ $WG = 1 ]] && apt -y --no-install-recommends install linux-headers-$(uname -r) && apt -y --no-install-recommends install wireguard-dkms
		}
		
	ubuntu(){
		# 更新源
		apt -y update

		# 安装一些必要的网络工具包和 wireguard-tools (Wire-Guard 配置工具：wg、wg-quick)
		apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools
		}
		
	centos(){
		# 安装一些必要的网络工具包和wireguard-tools (Wire-Guard 配置工具：wg、wg-quick)
		yum -y install epel-release
		yum -y install net-tools wireguard-tools

		# 如 Linux 版本低于5.6并且是 kvm，则安装 wireguard 内核模块
		[[ $WG = 1 ]] && curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo &&
		yum -y install epel-release wireguard-dkms

		# 升级所有包同时也升级软件和系统内核
		yum -y update
		}

	$SYSTEM

	# 安装并认证 WGCF
	green " 进度  2/3： 安装 WGCF "

	# 判断 wgcf 的最新版本,如因 github 接口问题未能获取，默认 v2.2.9
	latest=$(wget --no-check-certificate -qO- -T1 -t1 $CDN "https://api.github.com/repos/ViRb3/wgcf/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/\"//g;s/v//g;s/,//g;s/ //g')
	[[ -z $latest ]] && latest='2.2.9'

	# 安装 wgcf，尽量下载官方的最新版本，如官方 wgcf 下载不成功，将使用 jsDelivr 的 CDN，以更好的支持双栈。并添加执行权限
	wget --no-check-certificate -T1 -t1 -N $CDN -O /usr/local/bin/wgcf https://github.com/ViRb3/wgcf/releases/download/v$latest/wgcf_${latest}_linux_$ARCHITECTURE
	[[ $? != 0 ]] && wget --no-check-certificate -N $CDN -O /usr/local/bin/wgcf https://cdn.jsdelivr.net/gh/fscarmen/warp/wgcf_${latest}_linux_$ARCHITECTURE
	chmod +x /usr/local/bin/wgcf

	# 如是 LXC，安装 Wireguard-GO 或者 BoringTun 
	[[ $LXC = 1 ]] && wget --no-check-certificate -N $CDN -P /usr/bin https://cdn.jsdelivr.net/gh/fscarmen/warp/$WB && chmod +x /usr/bin/$WB

	# 注册 WARP 账户 (将生成 wgcf-account.toml 文件保存账户信息)
	yellow " WGCF 注册中…… "
	until [[ -e wgcf-account.toml ]]
	  do
	   echo | wgcf register >/dev/null 2>&1
	done
	
	# 如有 Warp+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
	mkdir -p /etc/wireguard/ >/dev/null 2>&1
	[[ -n $LICENSE ]] && yellow " 升级 Warp+ 账户 " && sed -i "s/license_key.*/license_key = \"$LICENSE\"/g" wgcf-account.toml &&
	( wgcf update > /etc/wireguard/info.log 2>&1 || red " 升级失败，Warp+ 账户错误或者已激活超过5台设备，自动更换免费 Warp 账户继续 " )
	
	# 生成 Wire-Guard 配置文件 (wgcf-profile.conf)
	wgcf generate >/dev/null 2>&1

	# 修改配置文件
	echo $MODIFY | sh

	# 把 wgcf-profile.conf 复制到/etc/wireguard/ 并命名为 wgcf.conf
	cp -f wgcf-profile.conf /etc/wireguard/wgcf.conf >/dev/null 2>&1

	# 自动刷直至成功（ warp bug，有时候获取不了ip地址），重置之前的相关变量值，记录新的 IPv4 和 IPv6 地址和归属地
	green " 进度  3/3： 运行 WGCF "
	unset WAN4 WAN6 COUNTRY4 COUNTRY6 TRACE4 TRACE6
	net
	COUNTRY4=$(curl -s4 https://ip.gs/country)
	TRACE4=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)
	COUNTRY6=$(curl -s6 https://ip.gs/country)
	TRACE6=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)

	# 设置开机启动
	systemctl enable wg-quick@wgcf >/dev/null 2>&1
	grep -qE '^@reboot[ ]*root[ ]*warp[ ]*n' /etc/crontab || echo '@reboot root warp n' >> /etc/crontab

	# 优先使用 IPv4 网络
	[[ -e /etc/gai.conf ]] && [[ $(grep '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf) ]] || echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

	# 保存好配置文件
	mv -f wgcf-account.toml wgcf-profile.conf menu.sh /etc/wireguard
	
	# 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令
	chmod +x /etc/wireguard/menu.sh
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp && green " 创建快捷 warp 指令成功 "

	# 结果提示，脚本运行时间
	red "\n==============================================================\n"
	[[ $TRACE4 = plus ]] && green " IPv4：$WAN4 ( WARP+ IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = on ]] && green " IPv4：$WAN4 ( WARP IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = off || -z $TRACE4 ]] && green " IPv4：$WAN4 $COUNTRY4 "
	[[ $TRACE6 = plus ]] && green " IPv6：$WAN6 ( WARP+ IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = on ]] && green " IPv6：$WAN6 ( WARP IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = off || -z $TRACE6 ]] && green " IPv6：$WAN6 $COUNTRY6 "
	end=$(date +%s)
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green " 恭喜！WARP+ 已开启，总耗时:$(( $end - $start ))秒\n 设备名：$(grep name /etc/wireguard/info.log | awk '{ print $NF }')\n 剩余流量：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }') "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green " 恭喜！WARP 已开启，总耗时:$(( $end - $start ))秒 "
	red "\n==============================================================\n"
	yellow " 再次运行用 warp [option] [lisence]，如\n " && help
	[[ $TRACE4 = off && $TRACE6 = off ]] && red " WARP 安装失败，问题反馈:[https://github.com/fscarmen/warp/issues] "
	}

# 关闭 WARP 网络接口，并删除 WGCF
uninstall(){
	unset WAN4 WAN6 COUNTRY4 COUNTRY6
	systemctl disable wg-quick@wgcf >/dev/null 2>&1
	echo $DOWN | sh >/dev/null 2>&1
	[[ $SYSTEM = centos ]] && yum -y autoremove wireguard-tools wireguard-dkms 2>/dev/null || apt -y autoremove wireguard-tools wireguard-dkms 2>/dev/null
	rm -rf /usr/local/bin/wgcf /etc/wireguard /usr/bin/boringtun /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf /usr/bin/warp
	[[ -e /etc/gai.conf ]] && sed -i '/^precedence[ ]*::ffff:0:0\/96[ ]*100/d' /etc/gai.conf
	sed -i '/warp[ ]n/d' /etc/crontab
	WAN4=$(curl -s4m10 https://ip.gs)
	WAN6=$(curl -s6m10 https://ip.gs)
	COUNTRY4=$(curl -s4m10 https://ip.gs/country)
	COUNTRY6=$(curl -s6m10 https://ip.gs/country)
	[[ -z $(wg) ]] >/dev/null 2>&1 && green " WGCF 已彻底删除!\n IPv4：$WAN4 $COUNTRY4\n IPv6：$WAN6 $COUNTRY6 " || red " 没有清除干净，请重启(reboot)后尝试再次删除 "
	}

# 安装BBR
bbrInstall() {
	red "\n=============================================================="
	green "BBR、DD脚本用的[ylx2016]的成熟作品，地址[https://github.com/ylx2016/Linux-NetSpeed]，请熟知"
	yellow "1.安装脚本【推荐原版BBR+FQ】"
	yellow "2.回退主目录"
	red "=============================================================="
	read -p "请选择：" BBR
	case "$BBR" in
		1 ) wget --no-check-certificate -N "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh;;
		2 ) menu$PLAN;;
		* ) red " 请输入正确数字 [1-2] "; sleep 1; bbrInstall;;
	esac
	}


# 刷 Warp+ 流量
input() {
	read -p " 请输入 Warp+ ID: " ID
	i=5
	until [[ ${#ID} = 36 ]]
		do
		let i--
		[[ $i = 0 ]] && red " 输入错误达5次，脚本退出 " && exit 1 || read -p " Warp+ ID 应为36位字符，请重新输入 Warp+ ID （剩余$i次）: " ID
	done
	}

plus() {
	red "\n=============================================================="
	green " 刷 Warp+ 流量用可选择以下两位作者的成熟作品，请熟知:\n	* [ALIILAPRO]，地址[https://github.com/ALIILAPRO/warp-plus-cloudflare]\n	* [mixool]，地址[https://github.com/mixool/across/tree/master/wireguard]\n 下载地址：https://1.1.1.1/，访问和苹果外区 ID 自理\n 获取 Warp+ ID 填到下面。方法：App右上角菜单 三 --> 高级 --> 诊断 --> ID\n 重要：刷脚本后流量没有增加处理：右上角菜单 三 --> 高级 --> 连接选项 --> 重置加密密钥\n 最好配合 screen 在后台运行任务 "
	yellow "1.运行[ALIILAPRO]脚本 "
	yellow "2.运行[mixool]脚本 "
	yellow "3.回退主目录"
	red "=============================================================="
	read -p "请选择：" CHOOSEPLUS
	case "$CHOOSEPLUS" in
		1 ) input
		    [[ $(type -P git) ]] || apt -y install git 2>/dev/null || yum -y install git 2>/dev/null
		    [[ $(type -P python3) ]] || apt -y install python3 2>/dev/null || yum -y install python3 2>/dev/null
		    [[ -d ~/warp-plus-cloudflare ]] || git clone https://github.com/aliilapro/warp-plus-cloudflare.git
		    echo $ID | python3 ~/warp-plus-cloudflare/wp-plus.py;;
		2 ) input
		    read -p " 你希望获取的目标流量值，单位为 GB，输入数字即可，默认值为10 :" MISSION
		    wget --no-check-certificate $CDN -N https://cdn.jsdelivr.net/gh/mixool/across/wireguard/warp_plus.sh
		    sed -i "s/eb86bd52-fe28-4f03-a944-60428823540e/$ID/g" warp_plus.sh
		    bash warp_plus.sh $(echo $MISSION | sed 's/[^0-9]*//g');;
		3 ) menu$PLAN;;
		* ) red " 请输入正确数字 [1-3] "; sleep 1; plus;;
	esac
	}

# 免费 Warp 账户升级 Warp+ 账户
update() {
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && red " 已经是 WARP+ 账户，不需要升级 " && exit 1
	[[ ! -e /etc/wireguard/wgcf-account.toml ]] && red " 找不到账户文件：/etc/wireguard/wgcf-account.toml，可以卸载后重装，输入 Warp+ License " && exit 1
	[[ ! -e /etc/wireguard/wgcf.conf ]] && red " 找不到配置文件： /etc/wireguard/wgcf.conf，可以卸载后重装，输入 Warp+ License " && exit 1
	[[ -z $LICENSE ]] && read -p " 请输入Warp+ License:" LICENSE
	i=5
	until [[ ${#LICENSE} = 26 ]]
	do
	let i--
	[[ $i = 0 ]] && red " 输入错误达5次，脚本退出 " && exit 1 || read -p " License 应为26位字符,请重新输入 Warp+ License（剩余$i次）: " LICENSE
        done
	cd /etc/wireguard
	sed -i "s#license_key.*#license_key = \"$LICENSE\"#g" wgcf-account.toml &&
	wgcf update > /etc/wireguard/info.log 2>&1 &&
	(sed -i "s#PrivateKey =.*#PrivateKey = $(grep private_key wgcf-account.toml  | cut -d\" -f2 | sed 's#\/#\^#g')#g" wgcf.conf
	sed -i 's#\^#\/#g' wgcf.conf
	echo $DOWN | sh >/dev/null 2>&1
	net
	[[ $(wget --no-check-certificate -qO- -4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) = plus || $(wget --no-check-certificate -qO- -6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) = plus ]] &&
	green " 已升级为Warp+ 账户\n IPv4：$WAN4\n IPv6：$WAN6\n 设备名：$(grep name /etc/wireguard/info.log | awk '{ print $NF }')\n 剩余流量：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" ) || red " 升级失败，Warp+ 账户错误或者已激活超过5台设备，继续使用免费的 Warp "
	}

# 同步脚本至最新版本
ver(){
	wget -N $CDN -P /etc/wireguard https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh &&
	chmod +x /etc/wireguard/menu.sh &&
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp &&
	green " 成功！已同步最新脚本，版本号：$(grep ^VERSION /etc/wireguard/menu.sh | cut -d = -f2)  功能新增：$(grep ^TXT /etc/wireguard/menu.sh | cut -d \" -f2) " || red " 升级失败，问题反馈:[https://github.com/fscarmen/warp/issues] "
	exit
	}
# 单栈
menu1(){
	status
	[[ $IPV4$IPV6 = 01 ]] && green " 1. 为 IPv6 only 添加 IPv4 网络接口 " || green " 1. 为 IPv4 only 添加 IPv6 网络接口 "
	[[ $IPV4$IPV6 = 01 ]] && green " 2. 为 IPv6 only 添加双栈网络接口 " || green " 2. 为 IPv4 only 添加双栈网络接口 "
	[[ $PLAN = 3 ]] && green  " 3. 暂时关闭 WARP " || green " 3. 打开 WARP "
	green " 4. 永久关闭 WARP 网络接口，并删除 WGCF "
	green " 5. 升级内核、安装BBR、DD脚本 "
	green " 6. 刷 Warp+ 流量 "
	green " 7. 同步最新版本 "
	green " 0. 退出脚本 \n "
	read -p " 请输入数字:" CHOOSE1
		case "$CHOOSE1" in
		1 )	MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6);	install;;
		2 )	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
		3 )	onoff;  [[ $OFF =  1 ]] && green " 已暂停 WARP，再次开启可以用 warp o " || green " 已开启 WARP\n IPv4:$WAN4\n IPv6:$WAN6 " ;;
		4 )	uninstall;;
		5 )	bbrInstall;;
		6 )	plus;;
		7 )	ver;;
		0 )	exit;;
		* )	red " 请输入正确数字 [0-7] "; sleep 1; menu1;;
		esac
	}

# 双栈
menu2(){ 
	status
	green " 1. 为 原生双栈 添加 WARP双栈 网络接口 "
	[[ $PLAN = 3 ]] && green  " 2. 暂时关闭 WARP " || green " 2. 打开 WARP "
	green " 3. 永久关闭 WARP 网络接口，并删除 WGCF "
	green " 4. 升级内核、安装BBR、DD脚本 "
	green " 5. 刷 Warp+ 流量 "
	green " 6. 同步最新版本 "
	green " 0. 退出脚本 \n "
	read -p " 请输入数字:" CHOOSE2
		case "$CHOOSE2" in
		1 )	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
		2 )	onoff; [[ -n $(wg) ]] 2>/dev/null && green " 已开启 WARP\n IPv4:$WAN4\n IPv6:$WAN6 " || green " 已暂停 WARP，再次开启可以用 bash menu.sh o " ;;
		3 )	uninstall;;
		4 )	bbrInstall;;
		5 )	plus;;
		6 )	ver;;
		0 )	exit;;
		* )	red " 请输入正确数字 [0-6] "; sleep 1; menu2;;
		esac
	}

# 已开启 warp 网络接口
menu3(){ 
	status
	[[ $PLAN = 3 ]] && green  " 1. 暂时关闭 WARP " || green " 1. 打开 WARP "
	green " 2. 永久关闭 WARP 网络接口，并删除 WGCF "
	green " 3. 升级内核、安装BBR、DD脚本 "
	green " 4. 刷 Warp+ 流量 "
	green " 5. 升级为 WARP+ 账户 "
	green " 6. 同步最新版本 "
	green " 0. 退出脚本 \n "
	read -p " 请输入数字:" CHOOSE3
        case "$CHOOSE3" in
		1 )	onoff; [[ -n $(wg) ]] 2>/dev/null && green " 已开启 WARP\n IPv4:$WAN4\n IPv6:$WAN6 " || green " 已暂停 WARP，再次开启可以用 bash menu.sh o " ;;
		2 )	uninstall;;
		3 )	bbrInstall;;
		4 )	plus;;
		5 )	update;;
		6 )	ver;;
		0 )	exit;;
		* )	red " 请输入正确数字 [0-6] "; sleep 1; menu3;;
		esac
	}

# 参数选项 LICENSE
LICENSE=$2

# 参数选项 OPTION：1=为 IPv4 或者 IPv6 补全另一栈Warp; 2=安装双栈 Warp; u=卸载 Warp; b=升级内核、开启BBR及DD; o=Warp开关； p=刷 Warp+ 流量; 其他或空值=菜单界面
OPTION=$1

# 设置后缀
case "$OPTION" in
1 )	[[ $PLAN = 2 ]] && read -p " 此系统为原生双栈，只能选择 Warp 双栈方案，继续请输入 y，其他退出 ：" DUAL &&
	[[ $DUAL != [Yy] ]] && exit 1 || MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6)
	[[ $PLAN = 1 ]] && MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6)
 	[[ $PLAN = 3 ]] && yellow " 检测 WARP 已开启，自动关闭后运行上一条命令安装或者输入 !! " && echo $DOWN | sh >/dev/null 2>&1 && exit 1
	install;;
2 )	[[ $PLAN = 3 ]] && yellow " 检测 WARP 已开启，自动关闭后运行上一条命令安装或者输入 !! " && echo $DOWN | sh >/dev/null 2>&1 && exit 1
	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
[Bb] )	bbrInstall;;
[Pp] )	plus;;
[Dd] )	update;;
[Uu] )	uninstall;;
[Vv] )	ver;;
[Oo] )	onoff;;
[Nn] )	net;;
[Hh] )	help;;
* )	menu$PLAN;;
esac
