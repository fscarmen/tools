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

[[ -n $1 && $1 != [Hh] ]] || read -p " 1.English	2.简体中文	Choose language (default is 1.English): " LANGUAGE
[[ $LANGUAGE != 2 ]] && T1="1)check whether the Tun module is loaded; 2) Improve script adaptability; 3) Support hax, Amazon Linux 2 and Oracle Linux" || T1="1)添加自动检查是否开启 Tun 模块； 2)提高脚本适配性; 3)新增 hax、Amazon Linux 2 和 Oracle Linux 支持"
[[ $LANGUAGE != 2 ]] && T2="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/fscarmen/warp/issues]" || T2="必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T3="The Tun module is not loaded. You should turn it on in the control panel. Ask the supplier for more help. Feedback: [https://github.com/fscarmen/warp/issues]" || T3="没有加载 Tun 模块，请在管理后台开启或联系供应商了解如何开启，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T4="The WARP server cannot be connected. It may be a China Mainland VPS. You can manually ping 162.159.192.1 or ping6 2606:4700:d0::a29f:c001.You can run the script again if the connect is successful. Feedback: [https://github.com/fscarmen/warp/issues]" || T4="与 WARP 的服务器不能连接,可能是大陆 VPS，可手动 ping 162.159.192.1 或 ping6 2606:4700:d0::a29f:c001，如能连通可再次运行脚本，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T5="The script supports Debian, Ubuntu or CentOS systems only. Feedback: [https://github.com/fscarmen/warp/issues]" || T5="本脚本只支持 Debian、Ubuntu 或 CentOS 系统,问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T6="warp h (help)\n warp o (Turn off WARP temporarily)\n warp u (Turn off and uninstall WARP interface)\n warp b (Upgrade kernel, turn on BBR, change Linux system)\n warp d (Upgrade to WARP+ account)\n warp d N5670ljg-sS9jD334-6o6g4M9F (Upgrade to WARP+ account with the license)\n warp p (Getting WARP+ quota by scripts)\n warp v (Sync the latest version)\n warp 1 (Add WARP IPv6 interface to native IPv4 VPS or WARP IPv4 interface to native IPv6 VPS)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F (Add IPv4 or IPV6 WARP+ interface with the license)\n warp 2 (Add WARP dualstack interface IPv4 + IPv6)\n warp 2 N5670ljg-sS9jD334-6o6g4M9F (Add WARP dualstack interface with the license)\n" || T6="warp h (帮助菜单）\n warp o (临时warp开关)\n warp u (卸载warp)\n warp b (升级内核、开启BBR及DD)\n warp d (免费 WARP 账户升级 WARP+)\n warp d N5670ljg-sS9jD334-6o6g4M9F (指定 License 升级 Warp+)\n warp p (刷WARP+流量)\n warp v (同步脚本至最新版本)\n warp 1 (Warp单栈)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F (指定 Warp+ License Warp 单栈)\n warp 2 (Warp双栈)\n warp 2 N5670ljg-sS9jD334-6o6g4M9F (指定 Warp+ License Warp 双栈)\n"
[[ $LANGUAGE != 2 ]] && T7="Installing curl..." || T7="安装curl中……"
[[ $LANGUAGE != 2 ]] && T8="It is necessary to upgrade the latest package library before install curl.It will take a little time,please be patiently..." || T8="先升级软件库才能继续安装 curl，时间较长，请耐心等待……"
[[ $LANGUAGE != 2 ]] && T9="Failed to install curl. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T9="安装 curl 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T10="WireGuard tools are not installed or the configuration file wgcf.conf cannot be found, please reinstall." || T10="没有安装 WireGuard tools 或者找不到配置文件 wgcf.conf，请重新安装。"
#[[ $LANGUAGE != 2 ]] && T1111="Maximum $j attempts to get WARP IP..." || T11="后台获取 WARP IP 中,最大尝试$j次……"
#[[ $LANGUAGE != 2 ]] && T1112="Try $i" || T12="第$i次尝试"
[[ $LANGUAGE != 2 ]] && T13="There have been more than \$i failures. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T13="失败已超过\$i次，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T14="Get the WARP IP successfully." || T14="已成功获取 WARP 网络"
[[ $LANGUAGE != 2 ]] && T15="WARP is turned off. It could be turned on again by [warp o]" || T15="已暂停 WARP，再次开启可以用 warp o"
[[ $LANGUAGE != 2 ]] && T16="The script specifically adds WARP network interface for VPS, detailed:[https://github.com/fscarmen/warp]\n Features:\n	* Support Warp+ account. Third-party increase quota Warp+ and upgrade kernel BBR script.\n	* Not only menus, but also commands with suffixes.\n	* Intelligent analysis of vps operating system：Ubuntu 18.04、20.04，Debian 10、11，CentOS 7、8. Be sure to choose the LTS system；Intelligent analysis of architecture：AMD or ARM\n	* Automatically select three WireGuard solutions. Performance: Kernel integration WireGuard＞Install kernel module＞boringtun＞wireguard-go\n	* Intelligent analysis of the latest version of the WGCF\n	* Intelligent analysis of lan and wan IP to generate WGCF configuration file.\n	* Output the result: WARP status and the IP region\n" || T16="本项目专为 VPS 添加 wgcf 网络接口，详细说明：[https://github.com/fscarmen/warp]\n脚本特点:\n	* 支持 Warp+ 账户，附带第三方刷 Warp+ 流量和升级内核 BBR 脚本\n	* 普通用户友好的菜单，进阶者通过后缀选项快速搭建\n	* 智能判断vps操作系统：Ubuntu 18.04、Ubuntu 20.04、Debian 10、Debian 11、CentOS 7、CentOS 8，请务必选择 LTS 系统；智能判断硬件结构类型：AMD 或者 ARM\n	* 结合 Linux 版本和虚拟化方式，自动优选三个 WireGuard 方案。网络性能方面：内核集成 WireGuard＞安装内核模块＞boringtun＞wireguard-go\n	* 智能判断 WGCF 作者 github库的最新版本 （Latest release）\n	* 智能分析内网和公网IP生成 WGCF 配置文件\n	* 输出执行结果，提示是否使用 WARP IP ，IP 归属地\n"
[[ $LANGUAGE != 2 ]] && T17="Version" || T17="脚本版本"
[[ $LANGUAGE != 2 ]] && T18="new features" || T18="功能新增"
[[ $LANGUAGE != 2 ]] && T19="System infomations" || T19="系统信息"
[[ $LANGUAGE != 2 ]] && T20="Operating System" || T20="当前操作系统"
[[ $LANGUAGE != 2 ]] && T21="Kernel" || T21="内核"
[[ $LANGUAGE != 2 ]] && T22="Architecture" || T22="处理器架构"
[[ $LANGUAGE != 2 ]] && T23="Virtualization" || T23="虚拟化"
[[ $LANGUAGE != 2 ]] && T24="is on" || T24="已开启"
[[ $LANGUAGE != 2 ]] && T25="Device name" || T25="设备名"
[[ $LANGUAGE != 2 ]] && T26="is off" || T26="未开启"
[[ $LANGUAGE != 2 ]] && T27="Device name" || T27="设备名"
[[ $LANGUAGE != 2 ]] && T28="If there is a WARP+ License, please enter it, otherwise press Enter to continue" || T28="如有 WARP+ License 请输入，没有可回车继续"
[[ $LANGUAGE != 2 ]] && T29="Input errors up to 5 times.The script is aborted." || T29="输入错误达5次，脚本退出"
#[[ $LANGUAGE != 2 ]] && T1130="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. ($i times remaining)" || T30="License 应为26位字符，请重新输入 Warp+ License，没有可回车继续（剩余$i次)"
[[ $LANGUAGE != 2 ]] && T31="LXC VPS choose:1. Wireguard-GO or 2. BoringTun （default is 1. Wireguard-GO）,choose" || T31="LXC方案:1. Wireguard-GO 或者 2. BoringTun （默认值选项为 1. Wireguard-GO）,请选择"
[[ $LANGUAGE != 2 ]] && T32="Step 1/3: Install dependencies" || T32="进度  1/3： 安装系统依赖"
[[ $LANGUAGE != 2 ]] && T33="Step 2/3: Install WGCF" || T33="进度  2/3： 安装 WGCF"
[[ $LANGUAGE != 2 ]] && T34="Register new WARP account..." || T34="WARP 注册中……"
[[ $LANGUAGE != 2 ]] && T35="Update WARP+ account" || T35="升级 WARP+ 账户"
[[ $LANGUAGE != 2 ]] && T36="The upgrade failed, WARP+ account error or more than 5 devices have been activated. Free WARP account to continu." || T36="升级失败，WARP+ 账户错误或者已激活超过5台设备，自动更换免费 Warp 账户继续"
[[ $LANGUAGE != 2 ]] && T37="Checking VPS infomations..." || T37="检查环境中……"
[[ $LANGUAGE != 2 ]] && T38="Create shortcut [warp] successfully" || T38="创建快捷 warp 指令成功"
[[ $LANGUAGE != 2 ]] && T39="Step 3/3: Running WARP" || T39="进度  3/3： 运行 WARP"
[[ $LANGUAGE != 2 ]] && T40="$COMPANY vps needs to restart and run [warp n] to open WARP." || T40="$COMPANY vps 需要重启后运行 warp n 才能打开 WARP,现执行重启"
#[[ $LANGUAGE != 2 ]] && T1141="Congratulations! WARP+ is turned on。 Spend time:$(( $end - $start )) seconds\n Device name：$(grep name /etc/wireguard/info.log | awk '{ print $NF }')\n Quota：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" || T41="恭喜！WARP+ 已开启，总耗时:$(( $end - $start ))秒\n 设备名：$(grep name /etc/wireguard/info.log | awk '{ print $NF }')\n 剩余流量：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')"
#[[ $LANGUAGE != 2 ]] && T1142="Congratulations! WARP is turned on。 Spend time:$(( $end - $start )) seconds" || T42="恭喜！WARP 已开启，总耗时:$(( $end - $start ))秒"
[[ $LANGUAGE != 2 ]] && T43="Run again with warp [option] [lisence], such as" || T43="再次运行用 warp [option] [lisence]，如"
[[ $LANGUAGE != 2 ]] && T44="WARP installation failed. Feedback: [https://github.com/fscarmen/warp/issues]" || T44="WARP 安装失败，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T45="WGCF has been completely deleted!" || T45="WGCF 已彻底删除!"
[[ $LANGUAGE != 2 ]] && T46="Not cleaned up, please reboot and try again." || T46="没有清除干净，请重启(reboot)后尝试再次删除"
[[ $LANGUAGE != 2 ]] && T47="Upgrade kernel, turn on BBR, change Linux system by other authors [ylx2016],[https://github.com/ylx2016/Linux-NetSpeed]" || T47="BBR、DD脚本用的[ylx2016]的成熟作品，地址[https://github.com/ylx2016/Linux-NetSpeed]，请熟知"
[[ $LANGUAGE != 2 ]] && T48="Running scripts " || T48="安装脚本【推荐原版BBR+FQ】"
[[ $LANGUAGE != 2 ]] && T49="return to main menu" || T49="回退主目录"
[[ $LANGUAGE != 2 ]] && T50="choose" || T50="请选择"
[[ $LANGUAGE != 2 ]] && T51="Please enter the correct number" || T51="请输入正确数字"
[[ $LANGUAGE != 2 ]] && T52="Please input WARP+ ID:" || T52="请输入 WARP+ ID:"
#[[ $LANGUAGE != 2 ]] && T1153="" || T1153=""
[[ $LANGUAGE != 2 ]] && T54="Getting the WARP+ quota by the following 2 authors:\n	* [ALIILAPRO]，[https://github.com/ALIILAPRO/warp-plus-cloudflare]\n	* [mixool]，[https://github.com/mixool/across/tree/master/wireguard]\n 1.Open the 1.1.1.1 app\n 2.Click on the hamburger menu button on the top-right corner\n 3.Navigate to: Account > Key\n Important：Refresh WARP+ quota： 三 --> Advanced --> Connection options --> Reset keys\n It is best to run script with screen." || T54="刷 WARP+ 流量用可选择以下两位作者的成熟作品，请熟知:\n	* [ALIILAPRO]，地址[https://github.com/ALIILAPRO/warp-plus-cloudflare]\n	* [mixool]，地址[https://github.com/mixool/across/tree/master/wireguard]\n 下载地址：https://1.1.1.1/，访问和苹果外区 ID 自理\n 获取 Warp+ ID 填到下面。方法：App右上角菜单 三 --> 高级 --> 诊断 --> ID\n 重要：刷脚本后流量没有增加处理：右上角菜单 三 --> 高级 --> 连接选项 --> 重置加密密钥\n 最好配合 screen 在后台运行任务"
[[ $LANGUAGE != 2 ]] && T55="run [ALIILAPRO] script" || T55="运行[ALIILAPRO]脚本"
[[ $LANGUAGE != 2 ]] && T56="run[mixool] script" || T56="运行[mixool]脚本"
[[ $LANGUAGE != 2 ]] && T57="The target quota you want to get. The unit is GB, the default value is 10:" || T57="你希望获取的目标流量值，单位为 GB，输入数字即可，默认值为10 :"
[[ $LANGUAGE != 2 ]] && T58="This is the WARP+ account, no need to upgrade." || T58="已经是 WARP+ 账户，不需要升级"
[[ $LANGUAGE != 2 ]] && T59="Cannot find the account file: /etc/wireguard/wgcf-account.toml, you can reinstall with the WARP+ License" || T59="找不到账户文件：/etc/wireguard/wgcf-account.toml，可以卸载后重装，输入 WARP+ License"
[[ $LANGUAGE != 2 ]] && T60="Cannot find the configuration file: /etc/wireguard/wgcf.conf, you can reinstall with the WARP+ License" || T60="找不到配置文件： /etc/wireguard/wgcf.conf，可以卸载后重装，输入 Warp+ License"
[[ $LANGUAGE != 2 ]] && T61="Please Input WARP+ license:" || T61="请输入WARP+ License:"
[[ $LANGUAGE != 2 ]] && T62="Successfully upgraded to a WARP+ account" || T62="已升级为 WARP+ 账户"
[[ $LANGUAGE != 2 ]] && T63="WARP+ quota" || T63="剩余流量"
[[ $LANGUAGE != 2 ]] && T64="Successfully synchronized the latest version" || T64="成功！已同步最新脚本，版本号"
[[ $LANGUAGE != 2 ]] && T65="Upgrade failed. Feedback:[https://github.com/fscarmen/warp/issues]" || T65="升级失败，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T66="Add WARP IPv4 interface to IPv6 only VPS" || T66="为 IPv6 only 添加 IPv4 网络接口"
[[ $LANGUAGE != 2 ]] && T67="Add WARP IPv6 interface to IPv4 only VPS" || T67="为 IPv4 only 添加 IPv6 网络接口"
[[ $LANGUAGE != 2 ]] && T68="Add WARP dualstack interface to IPv6 only VPS" || T68="为 IPv6 only 添加双栈网络接口"
[[ $LANGUAGE != 2 ]] && T69="Add WARP dualstack interface to IPv4 only VPS" || T69="为 IPv4 only 添加双栈网络接口"
[[ $LANGUAGE != 2 ]] && T70="Add WARP dualstack interface to native dualstack" || T70="为 原生双栈 添加 WARP双栈 网络接口"
[[ $LANGUAGE != 2 ]] && T71="Turn on WARP" || T71="打开 WARP"
[[ $LANGUAGE != 2 ]] && T72="Turn off and uninstall WARP interface" || T72="永久关闭 WARP 网络接口，并删除 WARP"
[[ $LANGUAGE != 2 ]] && T73="Upgrade kernel, turn on BBR, change Linux system" || T73="升级内核、安装BBR、DD脚本"
[[ $LANGUAGE != 2 ]] && T74="Getting WARP+ quota by scripts" || T74="刷 Warp+ 流量"
[[ $LANGUAGE != 2 ]] && T75="Sync the latest version" || T75="同步最新版本"
[[ $LANGUAGE != 2 ]] && T76="exit" || T76="退出脚本"
[[ $LANGUAGE != 2 ]] && T77="Turn off WARP" || T77="暂时关闭 WARP"
[[ $LANGUAGE != 2 ]] && T78="Upgrade to WARP+ account" || T78="升级为 WARP+ 账户"
[[ $LANGUAGE != 2 ]] && T79="This system is a native dualstack. You can only choose the WARP dualstack, please enter [y] to continue, and other keys to exit" || T79="此系统为原生双栈，只能选择 Warp 双栈方案，继续请输入 y，其他按键退出"
[[ $LANGUAGE != 2 ]] && T80="The WARP is working. It will be closed, please run the previous command to install or enter !!" || T80="检测 WARP 已开启，自动关闭后运行上一条命令安装或者输入 !!"


# 当前脚本版本号和新增功能
VERSION=2.06
TXT=" $T1 "

help(){
	yellow " $T6 " 
	}

# 必须以root运行脚本
[[ $(id -u) != 0 ]] && red " $T2 " && exit 1

# 必须加载 Tun 模块
TUN=$(cat /dev/net/tun 2>&1 | tr A-Z a-z)
[[ ! $TUN =~ 'in bad state' ]] && [[ ! $TUN =~ '处于错误状态' ]] && red " $T3 " && exit 1

# 判断是否大陆 VPS。先尝试连接 CloudFlare WARP 服务的 Endpoint IP，如遇到 WARP 断网则先关闭、杀进程后重试一次，仍然不通则 WARP 项目不可用。
ping6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && CDN=-6 || IPV6=0
ping -c2 -W10 162.159.192.1 >/dev/null 2>&1 && IPV4=1 && CDN=-4 || IPV4=0
if [[ $IPV4$IPV6 = 00 && -n $(wg) ]]; then
	wg-quick down wgcf >/dev/null 2>&1
	kill $(pgrep -f wireguard) >/dev/null 2>&1
	kill $(pgrep -f boringtun) >/dev/null 2>&1
	ping6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && CDN=-6
	ping -c2 -W10 162.159.192.1 >/dev/null 2>&1 && IPV4=1 && CDN=-4
fi
[[ $IPV4$IPV6 = 00 ]] && red " $T4 " && exit 1

# 判断操作系统，只支持 Debian、Ubuntu 或 Centos,如非上述操作系统，删除临时文件，退出脚本
[[ -f /etc/os-release ]] && SYS=$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)
[[ -z $SYS ]] && SYS=$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)
[[ -z $SYS ]] && SYS=$(lsb_release -sd 2>/dev/null)
[[ -z $SYS && -f /etc/lsb-release ]] && SYS=$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)
[[ -z $SYS && -f /etc/redhat-release ]] && SYS=$(grep . /etc/redhat-release 2>/dev/null)
[[ -z $SYS && -f /etc/issue ]] && SYS=$(grep . /etc/issue 2>/dev/null | cut -d '\' -f1 | sed '/^[ ]*$/d')
[[ $(echo $SYS | tr A-Z a-z) =~ debian ]] && SYSTEM=debian
[[ $(echo $SYS | tr A-Z a-z) =~ ubuntu ]] && SYSTEM=ubuntu
[[ $(echo $SYS | tr A-Z a-z) =~ centos|kernel|'oracle linux' ]] && SYSTEM=centos
[[ $(echo $SYS | tr A-Z a-z) =~ 'amazon linux' ]] && SYSTEM=centos && COMPANY=amazon
[[ -z $SYSTEM ]] && red " $T5 " && exit 1

green " $T37 "

# 安装 curl
[[ ! $(type -P curl) ]] && 
( yellow " $T7 " && (apt -y install curl >/dev/null 2>&1 || yum -y install curl >/dev/null 2>&1) || 
( yellow " $T8 " && apt -y update >/dev/null 2>&1 && apt -y install curl >/dev/null 2>&1 || 
( yum -y update >/dev/null 2>&1 && yum -y install curl >/dev/null 2>&1 || ( yellow " $T9 " && exit 1 ))))

# 判断处理器架构
[[ $(arch | tr A-Z a-z) =~ aarch ]] && ARCHITECTURE=arm64 || ARCHITECTURE=amd64

# 判断虚拟化，选择 Wireguard内核模块 还是 Wireguard-Go/BoringTun
VIRT=$(systemd-detect-virt 2>/dev/null | tr A-Z a-z)
[[ -n $VIRT ]] || VIRT=$(hostnamectl 2>/dev/null | tr A-Z a-z | grep virtualization | cut -d : -f2)
[[ $VIRT =~ openvz|lxc ]] && LXC=1
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
	[[ ! $(type -P wg-quick) || ! -e /etc/wireguard/wgcf.conf ]] && red " $T10 " && exit 1 ||
	i=1;j=10
	[[ $LANGUAGE != 2 ]] && T11="Maximum $j attempts to get WARP IP..." || T11="后台获取 WARP IP 中,最大尝试$j次……"
	[[ $LANGUAGE != 2 ]] && T12="Try $i" || T12="第$i次尝试"
	yellow " $T11 "
	yellow " $T12 "
	echo $UP | sh >/dev/null 2>&1
	WAN4=$(curl -s4m10 https://ip.gs) &&
	WAN6=$(curl -s6m10 https://ip.gs)
	until [[ -n $WAN4 && -n $WAN6 ]]
		do	let i++
			[[ $LANGUAGE != 2 ]] && T12="Try $i" || T12="第$i次尝试"
			yellow " $T12 "
			echo $DOWN | sh >/dev/null 2>&1
			echo $UP | sh >/dev/null 2>&1
			WAN4=$(curl -s4m10 https://ip.gs) &&
			WAN6=$(curl -s6m10 https://ip.gs)
			[[ $i = $j ]] && (echo $DOWN | sh >/dev/null 2>&1; red " $T13 ") && exit 1
        	done
green " $T14\n IPv4:$WAN4\n IPv6:$WAN6 "
	}

# WARP 开关
onoff(){
	[[ -n $(wg) ]] 2>/dev/null && (echo $DOWN | sh >/dev/null 2>&1; green " $T15 ") || net
	}

# VPS 当前状态
status(){
	clear
	yellow " $T16 "
	red "======================================================================================================================\n"
	green " $T17：$VERSION  $T18：$TXT\n $T19：\n	$T20：$SYS\n	$T21：$(uname -r)\n	$T22：$ARCHITECTURE\n	$T23：$VIRT "
	[[ $TRACE4 = plus ]] && green "	IPv4：$WAN4 ( WARP+ IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = on ]] && green "	IPv4：$WAN4 ( WARP IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = off ]] && green "	IPv4：$WAN4 $COUNTRY4 "
	[[ $TRACE6 = plus ]] && green "	IPv6：$WAN6 ( WARP+ IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = on ]] && green "	IPv6：$WAN6 ( WARP IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = off ]] && green "	IPv6：$WAN6 $COUNTRY6 "
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green "	WARP+ $T24	$T25：$(grep name /etc/wireguard/info.log 2>/dev/null | awk '{ print $NF }') "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green "	WARP $T24 " 	
	[[ $PLAN != 3 ]] && green "	WARP $T26"
 	red "\n======================================================================================================================\n"
	}

# WGCF 安装
install(){
	# 脚本开始时间
	start=$(date +%s)
	
	# 输入 Warp+ 账户（如有），限制位数为空或者26位以防输入错误
	[[ -z $LICENSE ]] && read -p " $T28: " LICENSE
	i=5
	until [[ -z $LICENSE || ${#LICENSE} = 26 ]]
		do
			let i--
			[[ $LANGUAGE != 2 ]] && T30="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. ($i times remaining)" || T30="License 应为26位字符，请重新输入 Warp+ License，没有可回车继续（剩余$i次)"
			[[ $i = 0 ]] && red " $T29 " && exit 1 || read -p " $T30: " LICENSE
		done

	# OpenVZ / LXC 选择 Wireguard-GO 或者 BoringTun 方案，并重新定义相应的 UP 和 DOWN 指令
	[[ $LXC = 1 ]] && read -p " $T31:" BORINGTUN
	[[ $BORINGTUN = 2 ]] && UP='WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun WG_SUDO=1 wg-quick up wgcf' || UP='wg-quick up wgcf'
	[[ $BORINGTUN = 2 ]] && DOWN='wg-quick down wgcf && kill $(pgrep -f boringtun)' || DOWN='wg-quick down wgcf'
	[[ $BORINGTUN = 2 ]] && WB=boringtun || WB=wireguard-go
	
	green " $T32 "
	
	# 先删除之前安装，可能导致失败的文件，添加环境变量
	rm -rf /usr/local/bin/wgcf /usr/bin/boringtun /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf
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
		[[ $COMPANY = amazon ]] && yum -y upgrade && amazon-linux-extras install -y epel		
		yum -y install epel-release
		yum -y install net-tools wireguard-tools

		# 如 Linux 版本低于5.6并且是 kvm，则安装 wireguard 内核模块
		[[ $WG = 1 ]] && curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo &&
		yum -y install wireguard-dkms

		# 升级所有包同时也升级软件和系统内核
		yum -y update
		}

	$SYSTEM

	# 安装并认证 WGCF
	green " $T33 "

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
	yellow " $T34 "
	until [[ -e wgcf-account.toml ]]
	  do
	   echo | wgcf register >/dev/null 2>&1
	done
	
	# 如有 Warp+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
	mkdir -p /etc/wireguard/ >/dev/null 2>&1
	[[ -n $LICENSE ]] && yellow " $T35 " && sed -i "s/license_key.*/license_key = \"$LICENSE\"/g" wgcf-account.toml &&
	( wgcf update > /etc/wireguard/info.log 2>&1 || red " $T36 " )
	
	# 生成 Wire-Guard 配置文件 (wgcf-profile.conf)
	wgcf generate >/dev/null 2>&1

	# 修改配置文件
	echo $MODIFY | sh

	# 把 wgcf-profile.conf 复制到/etc/wireguard/ 并命名为 wgcf.conf
	cp -f wgcf-profile.conf /etc/wireguard/wgcf.conf >/dev/null 2>&1

	# 设置开机启动
	systemctl enable wg-quick@wgcf >/dev/null 2>&1
	grep -qE '^@reboot root bash /usr/bin/warp n' /etc/crontab || echo '@reboot root bash /usr/bin/warp n' >> /etc/crontab

	# 优先使用 IPv4 网络
	[[ -e /etc/gai.conf ]] && [[ $(grep '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf) ]] || echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

	# 保存好配置文件
	mv -f wgcf-account.toml wgcf-profile.conf menu.sh /etc/wireguard >/dev/null 2>&1
	
	# 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令
	chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp && green " $T38 "
	
	# 自动刷直至成功（ warp bug，有时候获取不了ip地址），重置之前的相关变量值，记录新的 IPv4 和 IPv6 地址和归属地
	green " $T39 "
	unset WAN4 WAN6 COUNTRY4 COUNTRY6 TRACE4 TRACE6
	[[ $COMPANY = amazon ]] && red " $T40 " && reboot || net
	COUNTRY4=$(curl -s4 https://ip.gs/country)
	TRACE4=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)
	COUNTRY6=$(curl -s6 https://ip.gs/country)
	TRACE6=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)

	# 结果提示，脚本运行时间
	red "\n==============================================================\n"
	[[ $TRACE4 = plus ]] && green " IPv4：$WAN4 ( WARP+ IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = on ]] && green " IPv4：$WAN4 ( WARP IPv4 ) $COUNTRY4 "
	[[ $TRACE4 = off || -z $TRACE4 ]] && green " IPv4：$WAN4 $COUNTRY4 "
	[[ $TRACE6 = plus ]] && green " IPv6：$WAN6 ( WARP+ IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = on ]] && green " IPv6：$WAN6 ( WARP IPv6 ) $COUNTRY6 "
	[[ $TRACE6 = off || -z $TRACE6 ]] && green " IPv6：$WAN6 $COUNTRY6 "
	end=$(date +%s)
	[[ $LANGUAGE != 2 ]] && T41="Congratulations! WARP+ is turned on。 Spend time:$(( $end - $start )) seconds\n Device name：$(grep -s name /etc/wireguard/info.log | awk '{ print $NF }')\n Quota：$(grep -s Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" || T41="恭喜！WARP+ 已开启，总耗时:$(( $end - $start ))秒\n 设备名：$(grep -s name /etc/wireguard/info.log | awk '{ print $NF }')\n 剩余流量：$(grep -s Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')"
	[[ $LANGUAGE != 2 ]] && T42="Congratulations! WARP is turned on。 Spend time:$(( $end - $start )) seconds" || T42="恭喜！WARP 已开启，总耗时:$(( $end - $start ))秒"
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green " $T41 "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green " $T42 "
	red "\n==============================================================\n"
	yellow " $T43\n " && help
	[[ $TRACE4 = off && $TRACE6 = off ]] && red " $T44 "
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
	[[ -z $(wg) ]] >/dev/null 2>&1 && green " $T45\n IPv4：$WAN4 $COUNTRY4\n IPv6：$WAN6 $COUNTRY6 " || red " $T46 "
	}

# 安装BBR
bbrInstall() {
	red "\n=============================================================="
	green " $T47 "
	yellow " 1.$T48 "
	yellow " 2.$T49 "
	red "=============================================================="
	read -p " $T50 " BBR
	case "$BBR" in
		1 ) wget --no-check-certificate -N "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh;;
		2 ) menu$PLAN;;
		* ) red " $T51 [1-2]"; sleep 1; bbrInstall;;
	esac
	}


# 刷 WARP+ 流量
input() {
	read -p " $T52 " ID
	i=5
	until [[ ${#ID} = 36 ]]
		do
		let i--
		[[ $LANGUAGE != 2 ]] && T53="Warp+ ID should be 36 characters, please re-enter ($i times remaining):" || T53="Warp+ ID 应为36位字符，请重新输入 Warp+ ID （剩余$i次）:"
		[[ $i = 0 ]] && red " $T29 " && exit 1 || read -p " $T53 " ID
	done
	}

plus() {
	red "\n=============================================================="
	green " $T54 "
	yellow " 1.$T55 "
	yellow " 2.$T56 "
	yellow " 3.$T29 "
	red "=============================================================="
	read -p "$T50：" CHOOSEPLUS
	case "$CHOOSEPLUS" in
		1 ) input
		    [[ $(type -P git) ]] || apt -y install git 2>/dev/null || yum -y install git 2>/dev/null
		    [[ $(type -P python3) ]] || apt -y install python3 2>/dev/null || yum -y install python3 2>/dev/null
		    [[ -d ~/warp-plus-cloudflare ]] || git clone https://github.com/aliilapro/warp-plus-cloudflare.git
		    echo $ID | python3 ~/warp-plus-cloudflare/wp-plus.py;;
		2 ) input
		    read -p " $T57" MISSION
		    wget --no-check-certificate $CDN -N https://cdn.jsdelivr.net/gh/mixool/across/wireguard/warp_plus.sh
		    sed -i "s/eb86bd52-fe28-4f03-a944-60428823540e/$ID/g" warp_plus.sh
		    bash warp_plus.sh $(echo $MISSION | sed 's/[^0-9]*//g');;
		3 ) menu$PLAN;;
		* ) red " $T51 [1-3] "; sleep 1; plus;;
	esac
	}

# 免费 Warp 账户升级 Warp+ 账户
update() {
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && red " $T58 " && exit 1
	[[ ! -e /etc/wireguard/wgcf-account.toml ]] && red " $T59 " && exit 1
	[[ ! -e /etc/wireguard/wgcf.conf ]] && red " $T60 " && exit 1
	[[ -z $LICENSE ]] && read -p " $T61 " LICENSE
	i=5
	until [[ ${#LICENSE} = 26 ]]
	do
	let i--
	[[ $LANGUAGE != 2 ]] && T62=" License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. ($i times remaining) " || T62=" License 应为26位字符,请重新输入 Warp+ License（剩余$i次）: "
	[[ $i = 0 ]] && red " $T29 " && exit 1 || read -p " $T62 " LICENSE
        done
	cd /etc/wireguard
	sed -i "s#license_key.*#license_key = \"$LICENSE\"#g" wgcf-account.toml &&
	wgcf update > /etc/wireguard/info.log 2>&1 &&
	(wgcf generate >/dev/null 2>&1
	sed -i "2s#.*#$(sed -ne 2p wgcf-profile.conf)#" wgcf.conf
	sed -i "3s#.*#$(sed -ne 3p wgcf-profile.conf)#" wgcf.conf
	sed -i "4s#.*#$(sed -ne 4p wgcf-profile.conf)#" wgcf.conf
	echo $DOWN | sh >/dev/null 2>&1
	net
	[[ $(wget --no-check-certificate -qO- -4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) = plus || $(wget --no-check-certificate -qO- -6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) = plus ]] &&
	green " $T62\n $T27：$(grep name /etc/wireguard/info.log | awk '{ print $NF }')\n $T63：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" ) || red " 升级失败，Warp+ 账户错误或者已激活超过5台设备，继续使用免费的 Warp "
	}

# 同步脚本至最新版本
ver(){
	wget -N $CDN -P /etc/wireguard https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh &&
	chmod +x /etc/wireguard/menu.sh &&
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp &&
	green " $T64:$(grep ^VERSION /etc/wireguard/menu.sh | cut -d = -f2)  $T18：$(grep ^TXT /etc/wireguard/menu.sh | cut -d \" -f2) " || red " $T65 "
	exit
	}
# 单栈
menu1(){
	status
	[[ $IPV4$IPV6 = 01 ]] && green " 1. $T66 " || green " 1. $T67 "
	[[ $IPV4$IPV6 = 01 ]] && green " 2. $T68 " || green " 2. $T69 "
  	green " 3. $T71 "
	green " 4. $T72 "
	green " 5. $T73 "
	green " 6. $T74 "
	green " 7. $T75 "
	green " 0. $T76 \n "
	read -p " $T50:" CHOOSE1
		case "$CHOOSE1" in
		1 )	MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6);	install;;
		2 )	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
		3 )	net;;
		4 )	uninstall;;
		5 )	bbrInstall;;
		6 )	plus;;
		7 )	ver;;
		0 )	exit;;
		* )	red " $T51 [0-7] "; sleep 1; menu1;;
		esac
	}

# 双栈
menu2(){ 
	status
	green " 1. $T70 "
	green " 2. $T71 "
	green " 3. $T72 "
	green " 4. $T73 "
	green " 5. $T74 "
	green " 6. $T75 "
	green " 0. $T76 \n "
	read -p " $T50:" CHOOSE2
		case "$CHOOSE2" in
		1 )	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
		2 )	net;;
		3 )	uninstall;;
		4 )	bbrInstall;;
		5 )	plus;;
		6 )	ver;;
		0 )	exit;;
		* )	red " $T51 [0-6] "; sleep 1; menu2;;
		esac
	}

# 已开启 warp 网络接口
menu3(){ 
	status
	green " 1. $T77 "
	green " 2. $T72 "
	green " 3. $T73 "
	green " 4. $T74 "
	green " 5. 升级为 WARP+ 账户 "
	green " 6. $T75 "
	green " 0. $T76 \n "
	read -p " $T50:" CHOOSE3
        case "$CHOOSE3" in
		1 )	echo $DOWN | sh >/dev/null 2>&1;;
		2 )	uninstall;;
		3 )	bbrInstall;;
		4 )	plus;;
		5 )	update;;
		6 )	ver;;
		0 )	exit;;
		* )	red " $T51 [0-6] "; sleep 1; menu3;;
		esac
	}

# 参数选项 LICENSE
LICENSE=$2

# 参数选项 OPTION：1=为 IPv4 或者 IPv6 补全另一栈Warp; 2=安装双栈 Warp; u=卸载 Warp; b=升级内核、开启BBR及DD; o=Warp开关； p=刷 Warp+ 流量; 其他或空值=菜单界面
OPTION=$1

# 设置后缀
case "$OPTION" in
1 )	[[ $PLAN = 2 ]] && read -p " $T79 " DUAL &&
	[[ $DUAL != [Yy] ]] && exit 1 || MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6)
	[[ $PLAN = 1 ]] && MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6)
 	[[ $PLAN = 3 ]] && yellow " $T80 " && echo $DOWN | sh >/dev/null 2>&1 && exit 1
	install;;
2 )	[[ $PLAN = 3 ]] && yellow " $T80 " && echo $DOWN | sh >/dev/null 2>&1 && exit 1
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
