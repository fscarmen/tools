# 自定义字体彩色和 read 函数
red(){
	echo -e "\033[31m\033[01m$1\033[0m"
    }
green(){
	echo -e "\033[32m\033[01m$1\033[0m"
    }
yellow(){
	echo -e "\033[33m\033[01m$1\033[0m"
}
reading(){
	read -p "$(green "$1")" $2
}

[[ -n $1 && $1 != [CcHhDdPpBbVv12] ]] || reading " 1.English\n 2.简体中文\n Choose language (default is 1.English): " LANGUAGE
[[ $LANGUAGE != 2 ]] && T1="1.Customize the priority of IPv4 / IPv6; 2.Customize the port of Client Socks5;"  || T1="1.自定义 IPv4 / IPv6 优先组别; 2.自定义 Client Socks5 代理端口"
[[ $LANGUAGE != 2 ]] && T2="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/fscarmen/warp/issues]" || T2="必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T3="The TUN module is not loaded. You should turn it on in the control panel. Ask the supplier for more help. Feedback: [https://github.com/fscarmen/warp/issues]" || T3="没有加载 TUN 模块，请在管理后台开启或联系供应商了解如何开启，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T4="The WARP server cannot be connected. It may be a China Mainland VPS. You can manually ping 162.159.192.1 or ping6 2606:4700:d0::a29f:c001.You can run the script again if the connect is successful. Feedback: [https://github.com/fscarmen/warp/issues]" || T4="与 WARP 的服务器不能连接,可能是大陆 VPS，可手动 ping 162.159.192.1 或 ping6 2606:4700:d0::a29f:c001，如能连通可再次运行脚本，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T5="The script supports Debian, Ubuntu or CentOS systems only. Feedback: [https://github.com/fscarmen/warp/issues]" || T5="本脚本只支持 Debian、Ubuntu 或 CentOS 系统,问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T6="warp h (help)\n warp o (Turn off WARP temporarily)\n warp u (Turn off and uninstall WARP interface and Socks5 Linux Client)\n warp b (Upgrade kernel, turn on BBR, change Linux system)\n warp d (Upgrade to WARP+ account)\n warp d N5670ljg-sS9jD334-6o6g4M9F (Upgrade to WARP+ account with the license)\n warp p (Getting WARP+ quota by scripts)\n warp v (Sync the latest version)\n warp r (Connect/Disconnect WARP Linux Client)\n warp 1 (Add WARP IPv6 interface to native IPv4 VPS or WARP IPv4 interface to native IPv6 VPS)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F Goodluck (Add IPv4 or IPV6 WARP+ interface with the license and named Goodluck)\n warp 2 (Add WARP dualstack interface IPv4 + IPv6)\n warp 2 N5670ljg-sS9jD334-6o6g4M9F Goodluck (Add WARP+ dualstack interface with the license and named Goodluck)\n warp c (Install WARP Linux Client)\n warp c N5670ljg-sS9jD334-6o6g4M9F(Install WARP+ Linux Client with the license)\n" || T6="warp h (帮助菜单）\n warp o (临时warp开关)\n warp u (卸载 WARP 网络接口和 Socks5 Client)\n warp b (升级内核、开启BBR及DD)\n warp d (免费 WARP 账户升级 WARP+)\n warp d N5670ljg-sS9jD334-6o6g4M9F (指定 License 升级 Warp+)\n warp p (刷WARP+流量)\n warp v (同步脚本至最新版本)\n warp r (WARP Linux Client 开关)\n warp 1 (Warp单栈)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F Goodluck (指定 WARP+ License Warp 单栈，设备名为 Goodluck)\n warp 2 (WARP 双栈)\n warp 2 N5670ljg-sS9jD334-6o6g4M9F Goodluck (指定 WARP+ License 双栈，设备名为 Goodluck)\n warp c (安装 WARP Linux Client，开启 Socks5 代理模式)\n warp c N5670ljg-sS9jD334-6o6g4M9F (指定 Warp+ License 安装 WARP Linux Client，开启 Socks5 代理模式)"
[[ $LANGUAGE != 2 ]] && T7="Installing curl..." || T7="安装curl中……"
[[ $LANGUAGE != 2 ]] && T8="It is necessary to upgrade the latest package library before install curl.It will take a little time,please be patiently..." || T8="先升级软件库才能继续安装 curl，时间较长，请耐心等待……"
[[ $LANGUAGE != 2 ]] && T9="Failed to install curl. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T9="安装 curl 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T10="WireGuard tools are not installed or the configuration file wgcf.conf cannot be found, please reinstall." || T10="没有安装 WireGuard tools 或者找不到配置文件 wgcf.conf，请重新安装。"
[[ $LANGUAGE != 2 ]] && T14="Got the WARP IP successfully." || T14="已成功获取 WARP 网络"
[[ $LANGUAGE != 2 ]] && T15="WARP is turned off. It could be turned on again by [warp o]" || T15="已暂停 WARP，再次开启可以用 warp o"
[[ $LANGUAGE != 2 ]] && T16="The script specifically adds WARP network interface for VPS, detailed:[https://github.com/fscarmen/warp]\n Features:\n	* Support WARP+ account. Third-party scripts are use to increase WARP+ quota or upgrade kernel.\n	* Not only menus, but commands with option.\n	* Intelligent analysis of operating system：Ubuntu 18.04、20.04，Debian 10、11，CentOS 7、8. Be sure to choose the LTS system. And architecture：AMD or ARM\n	* Automatically select four WireGuard solutions. Performance: Kernel with WireGuard integration＞Install kernel module＞BoringTUN＞wireguard-go\n	* Intelligent analysis of the latest version of the WGCF\n	* Suppert WARP Linux client.\n	* Output WARP status, IP region and asn\n" || T16="本项目专为 VPS 添加 wgcf 网络接口，详细说明：[https://github.com/fscarmen/warp]\n脚本特点:\n	* 支持 WARP+ 账户，附带第三方刷 WARP+ 流量和升级内核 BBR 脚本\n	* 普通用户友好的菜单，进阶者通过后缀选项快速搭建\n	* 智能判断操作系统：Ubuntu 18.04、Ubuntu 20.04、Debian 10、Debian 11、CentOS 7、CentOS 8，请务必选择 LTS 系统；硬件结构类型：AMD 或者 ARM\n	* 结合 Linux 版本和虚拟化方式，自动优选4个 WireGuard 方案。网络性能方面：内核集成 WireGuard＞安装内核模块＞BoringTUN＞wireguard-go\n	* 智能判断 WGCF 作者 github库的最新版本 （Latest release）\n	* 支持 WARP Linux Socks5 Client\n	* 输出执行结果，提示是否使用 WARP IP ，IP 归属地和线路提供商\n"
[[ $LANGUAGE != 2 ]] && T17="Version" || T17="脚本版本"
[[ $LANGUAGE != 2 ]] && T18="New features" || T18="功能新增"
[[ $LANGUAGE != 2 ]] && T19="System infomations" || T19="系统信息"
[[ $LANGUAGE != 2 ]] && T20="Operating System" || T20="当前操作系统"
[[ $LANGUAGE != 2 ]] && T21="Kernel" || T21="内核"
[[ $LANGUAGE != 2 ]] && T22="Architecture" || T22="处理器架构"
[[ $LANGUAGE != 2 ]] && T23="Virtualization" || T23="虚拟化"
[[ $LANGUAGE != 2 ]] && T24="Socks5 Client is on" || T24="Socks5 Client 已开启"
[[ $LANGUAGE != 2 ]] && T25="Device name" || T25="设备名"
[[ $LANGUAGE != 2 ]] && T27="" || T27=""
[[ $LANGUAGE != 2 ]] && T28="If there is a WARP+ License, please enter it, otherwise press Enter to continue:" || T28="如有 WARP+ License 请输入，没有可回车继续:"
[[ $LANGUAGE != 2 ]] && T29="Input errors up to 5 times.The script is aborted." || T29="输入错误达5次，脚本退出"
[[ $LANGUAGE != 2 ]] && T31="LXC VPS choose（default is 1. Wireguard-GO):\n 1. Wireguard-GO\n 2. BoringTun\n Choose:" || T31="LXC方案（默认值选项为 1. Wireguard-GO):\n 1. Wireguard-GO\n 2. BoringTun\n 请选择："
[[ $LANGUAGE != 2 ]] && T32="Step 1/3: Install dependencies" || T32="进度  1/3： 安装系统依赖"
[[ $LANGUAGE != 2 ]] && T33="Step 2/3: Install WGCF" || T33="进度  2/3： 安装 WGCF"
[[ $LANGUAGE != 2 ]] && T34="Register new WARP account..." || T34="WARP 注册中……"
[[ $LANGUAGE != 2 ]] && T35="Update WARP+ account..." || T35="升级 WARP+ 账户中……"
[[ $LANGUAGE != 2 ]] && T36="The upgrade failed, WARP+ account error or more than 5 devices have been activated. Free WARP account to continu." || T36="升级失败，WARP+ 账户错误或者已激活超过5台设备，自动更换免费 WARP 账户继续"
[[ $LANGUAGE != 2 ]] && T37="Checking VPS infomations..." || T37="检查环境中……"
[[ $LANGUAGE != 2 ]] && T38="Create shortcut [warp] successfully" || T38="创建快捷 warp 指令成功"
[[ $LANGUAGE != 2 ]] && T39="Step 3/3: Running WARP" || T39="进度  3/3： 运行 WARP"
[[ $LANGUAGE != 2 ]] && T43="Run again with warp [option] [lisence], such as" || T43="再次运行用 warp [option] [lisence]，如"
[[ $LANGUAGE != 2 ]] && T44="WARP installation failed. Feedback: [https://github.com/fscarmen/warp/issues]" || T44="WARP 安装失败，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T45="WARP interface and Linux Client have been completely deleted!" || T45="WARP 网络接口和 Linux Client 已彻底删除!"
[[ $LANGUAGE != 2 ]] && T46="Not cleaned up, please reboot and try again." || T46="没有清除干净，请重启(reboot)后尝试再次删除"
[[ $LANGUAGE != 2 ]] && T47="Upgrade kernel, turn on BBR, change Linux system by other authors [ylx2016],[https://github.com/ylx2016/Linux-NetSpeed]" || T47="BBR、DD脚本用的[ylx2016]的成熟作品，地址[https://github.com/ylx2016/Linux-NetSpeed]，请熟知"
[[ $LANGUAGE != 2 ]] && T48="Run script " || T48="安装脚本【推荐原版BBR+FQ】"
[[ $LANGUAGE != 2 ]] && T49="Return to main menu" || T49="回退主目录"
[[ $LANGUAGE != 2 ]] && T50="Choose:" || T50="请选择:"
[[ $LANGUAGE != 2 ]] && T51="Please enter the correct number" || T51="请输入正确数字"
[[ $LANGUAGE != 2 ]] && T52="Please input WARP+ ID:" || T52="请输入 WARP+ ID:"
[[ $LANGUAGE != 2 ]] && T54="Getting the WARP+ quota by the following 2 authors:\n	* [ALIILAPRO]，[https://github.com/ALIILAPRO/warp-plus-cloudflare]\n	* [mixool]，[https://github.com/mixool/across/tree/master/wireguard]\n * Open the 1.1.1.1 app\n * Click on the hamburger menu button on the top-right corner\n * Navigate to: Account > Key\n Important：Refresh WARP+ quota： 三 --> Advanced --> Connection options --> Reset keys\n It is best to run script with screen." || T54="刷 WARP+ 流量用可选择以下两位作者的成熟作品，请熟知:\n	* [ALIILAPRO]，地址[https://github.com/ALIILAPRO/warp-plus-cloudflare]\n	* [mixool]，地址[https://github.com/mixool/across/tree/master/wireguard]\n 下载地址：https://1.1.1.1/，访问和苹果外区 ID 自理\n 获取 WARP+ ID 填到下面。方法：App右上角菜单 三 --> 高级 --> 诊断 --> ID\n 重要：刷脚本后流量没有增加处理：右上角菜单 三 --> 高级 --> 连接选项 --> 重置加密密钥\n 最好配合 screen 在后台运行任务"
[[ $LANGUAGE != 2 ]] && T55="Run [ALIILAPRO] script" || T55="运行 [ALIILAPRO] 脚本"
[[ $LANGUAGE != 2 ]] && T56="Run [mixool] script" || T56="运行 [mixool] 脚本"
[[ $LANGUAGE != 2 ]] && T57="The target quota you want to get. The unit is GB, the default value is 10:" || T57="你希望获取的目标流量值，单位为 GB，输入数字即可，默认值为10:"
[[ $LANGUAGE != 2 ]] && T58="This is the WARP+ account, no need to upgrade." || T58="已经是 WARP+ 账户，不需要升级"
[[ $LANGUAGE != 2 ]] && T59="Cannot find the account file: /etc/wireguard/wgcf-account.toml, you can reinstall with the WARP+ License" || T59="找不到账户文件：/etc/wireguard/wgcf-account.toml，可以卸载后重装，输入 WARP+ License"
[[ $LANGUAGE != 2 ]] && T60="Cannot find the configuration file: /etc/wireguard/wgcf.conf, you can reinstall with the WARP+ License" || T60="找不到配置文件： /etc/wireguard/wgcf.conf，可以卸载后重装，输入 WARP+ License"
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
[[ $LANGUAGE != 2 ]] && T72="Turn off, uninstall WARP interface and Linux Client" || T72="永久关闭 WARP 网络接口，并删除 WARP 和 Linux Client"
[[ $LANGUAGE != 2 ]] && T73="Upgrade kernel, turn on BBR, change Linux system" || T73="升级内核、安装BBR、DD脚本"
[[ $LANGUAGE != 2 ]] && T74="Getting WARP+ quota by scripts" || T74="刷 WARP+ 流量"
[[ $LANGUAGE != 2 ]] && T75="Sync the latest version" || T75="同步最新版本"
[[ $LANGUAGE != 2 ]] && T76="Exit" || T76="退出脚本"
[[ $LANGUAGE != 2 ]] && T77="Turn off WARP" || T77="暂时关闭 WARP"
[[ $LANGUAGE != 2 ]] && T78="Upgrade to WARP+ account" || T78="升级为 WARP+ 账户"
[[ $LANGUAGE != 2 ]] && T79="This system is a native dualstack. You can only choose the WARP dualstack, please enter [y] to continue, and other keys to exit:" || T79="此系统为原生双栈，只能选择 Warp 双栈方案，继续请输入 y，其他按键退出:"
[[ $LANGUAGE != 2 ]] && T80="The WARP is working. It will be closed, please run the previous command to install or enter !!" || T80="检测 WARP 已开启，自动关闭后运行上一条命令安装或者输入 !!"
[[ $LANGUAGE != 2 ]] && T81="Searching for the best MTU value..." || T81="寻找 MTU 最优值……"
[[ $LANGUAGE != 2 ]] && T82="Install WARP Client for Linux and Proxy Mode" || T82="安装 WARP 的 Linux Client 和代理模式"
[[ $LANGUAGE != 2 ]] && T83="Step 1/2: Installing WARP Client..." || T83="进度  1/2： 安装 Client……"
[[ $LANGUAGE != 2 ]] && T84="Step 2/2: Setting to Proxy Mode" || T84="进度  2/2： 设置代理模式"
[[ $LANGUAGE != 2 ]] && T85="Client was installed. You can connect/disconnect by [warp r]" || T85="Linux Client 已安装，连接/断开 Client 可以用 warp r"
[[ $LANGUAGE != 2 ]] && T87="Fail to establish Socks5 proxy. Feedback: [https://github.com/fscarmen/warp/issues]" || T87="创建 Socks5 代理失败，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T88="Connect the client" || T88="连接 Client"
[[ $LANGUAGE != 2 ]] && T89="Disconnect the client" || T89="断开 Client"
[[ $LANGUAGE != 2 ]] && T90="Client is connected" || T90="Client 已连接"
[[ $LANGUAGE != 2 ]] && T91="Client is disconnect. It could be connect again by [warp r]" || T91="已断开 Client ，再次连接可以用 warp r"
[[ $LANGUAGE != 2 ]] && T92="Client is installed already. It could be uninstalled by [warp u]" || T92="Client 已安装，如要卸载，可以用 warp u"
[[ $LANGUAGE != 2 ]] && T93="Client is not installed. It could be installed by [warp c]" || T93="Client 未安装，如需安装，可以用 warp c"
[[ $LANGUAGE != 2 ]] && T95="Client works with non-WARP IPv4. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T95="Client 在非 WARP IPv4 下才能工作正常，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T96="Client connecting failure. It may be a CloudFlare IPv4." || T96="Client 连接失败，可能是 CloudFlare IPv4."
[[ $LANGUAGE != 2 ]] && T97="It is a WARP+ account already. Update is aborted." || T97="已经是 WARP+ 账户，不需要升级"
[[ $LANGUAGE != 2 ]] && T98="1. WGCF WARP account\n 2. WARP Linux Client account\n Choose:" || T98="1. WGCF WARP 账户\n 2. WARP Linux Client 账户\n 请选择："
[[ $LANGUAGE != 2 ]] && T101="Client doesn't support architecture ARM64. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T101="Client 不支持 ARM64，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T102="Please customize the WARP+ device name (It will automatically generate 6-digit random string if it is blank):" || T102="请自定义 WARP+ 设备名 (如果不输入，会自动生成随机的6位字符串):"
[[ $LANGUAGE != 2 ]] && T104="Please customize the Client port (It must be 4-5 digits. Default to 40000 if it is blank):" || T104="请自定义 Client 端口号 (必须为4-5位自然数，如果不输入，会默认40000):"
[[ $LANGUAGE != 2 ]] && T105="Please choose the priority of IPv4 or IPv6 (default 1.IPv4):\n 1.IPv4\n 2.IPv6\n 3.Use initial settings\n Choose:" || T105="请选择优先级别 (默认 1.IPv4):\n 1.IPv4\n 2.IPv6\n 3.使用 VPS 初始设置\n 请选择:"
[[ $LANGUAGE != 2 ]] && T106="IPv6 priority" || T106="IPv6 优先"
[[ $LANGUAGE != 2 ]] && T107="IPv4 priority" || T107="IPv4 优先"
[[ $LANGUAGE != 2 ]] && T109="Socks5 Proxy Client on IPv4 VPS is working now. You can only choose the WARP IPv6 interface, please enter [y] to continue, and other keys to exit:" || T109="IPv4 only VPS，并且 Socks5 代理正在运行中，只能选择单栈方案，继续请输入 y，其他按键退出:"
[[ $LANGUAGE != 2 ]] && T110="Socks5 Proxy Client on native dualstack VPS is working now. WARP interface could not be installed. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T110="原生双栈 VPS，并且 Socks5 代理正在运行中。WARP 网络接口不能安装，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $LANGUAGE != 2 ]] && T112="Client is not installed." || T112="Client 未安装"
[[ $LANGUAGE != 2 ]] && T113="Client is installed and disconnected" || T113="Client 已安装，状态为断开连接"
[[ $LANGUAGE != 2 ]] && T114="WARP+ Interface is on" || T114="WARP+ 网络接口已开启"
[[ $LANGUAGE != 2 ]] && T115="WARP Interface is on" || T115="WARP 网络接口已开启"
[[ $LANGUAGE != 2 ]] && T116="WARP Interface is off" || T116="WARP 网络接口未开启"
[[ $LANGUAGE != 2 ]] && T117="Uninstall WARP Interface was complete." || T117="WARP 网络接口卸载成功"
[[ $LANGUAGE != 2 ]] && T118="Uninstall WARP Interface was fail." || T118="WARP 网络接口卸载失败"
[[ $LANGUAGE != 2 ]] && T119="Uninstall Socks5 Proxy Client was complete." || T119="Socks5 Proxy Client 卸载成功"
[[ $LANGUAGE != 2 ]] && T120="Uninstall Socks5 Proxy Client was fail." || T120="Socks5 Proxy Client 卸载失败"

# 当前脚本版本号和新增功能
VERSION=2.10
TXT=" $T1 "

# 参数选项 OPTION：1=为 IPv4 或者 IPv6 补全另一栈WARP; 2=安装双栈 WARP; u=卸载 WARP; b=升级内核、开启BBR及DD; o=WARP开关； p=刷 WARP+ 流量; 其他或空值=菜单界面
OPTION=$1

# 参数选项 LICENSE
LICENSE=$2

# 自定义 WARP+ 设备名
NAME=$3

help(){
	yellow " $T6 " 
	}


# 刷 WARP+ 流量
input() {
	reading " $T52 " ID
	i=5
	until [[ ${#ID} = 36 ]]
		do
		let i--
		[[ $LANGUAGE != 2 ]] && T53="WARP+ ID should be 36 characters, please re-enter ($i times remaining):" || T53="WARP+ ID 应为36位字符，请重新输入 （剩余$i次）:"
		[[ $i = 0 ]] && red " $T29 " && exit 1 || reading " $T53 " ID
	done
	}

plus() {
	red "\n=============================================================="
	yellow " $T54\n "
	green " 1.$T55 "
	green " 2.$T56 "
	[[ -n $PLAN ]] && green " 3.$T49 " || green " 3.$T76 "
	red "=============================================================="
	reading " $T50 " CHOOSEPLUS
	case "$CHOOSEPLUS" in
		1 ) input
		    [[ $(type -P git) ]] || apt -y install git 2>/dev/null || yum -y install git 2>/dev/null
		    [[ $(type -P python3) ]] || apt -y install python3 2>/dev/null || yum -y install python3 2>/dev/null
		    [[ -d ~/warp-plus-cloudflare ]] || git clone https://github.com/aliilapro/warp-plus-cloudflare.git
		    echo $ID | python3 ~/warp-plus-cloudflare/wp-plus.py;;
		2 ) input
		    reading " $T57 " MISSION
		    wget --no-check-certificate $CDN -N https://cdn.jsdelivr.net/gh/mixool/across/wireguard/warp_plus.sh
		    sed -i "s/eb86bd52-fe28-4f03-a944-60428823540e/$ID/g" warp_plus.sh
		    bash warp_plus.sh $(echo $MISSION | sed 's/[^0-9]*//g');;
		3 ) [[ -n $PLAN ]] && menu$PLAN || exit;;
		* ) red " $T51 [1-3] "; sleep 1; plus;;
	esac
	}

# 设置部分后缀 1/3
case "$OPTION" in
[Hh] )	help; exit 0;;
[Pp] )	plus; exit 0;;
esac

green " $T37 "

# 必须以root运行脚本
[[ $(id -u) != 0 ]] && red " $T2 " && exit 1

# 判断虚拟化，选择 Wireguard内核模块 还是 Wireguard-Go/BoringTun
VIRT=$(systemd-detect-virt 2>/dev/null | tr A-Z a-z)
[[ -n $VIRT ]] || VIRT=$(hostnamectl 2>/dev/null | tr A-Z a-z | grep virtualization | cut -d : -f2)
[[ $VIRT =~ openvz|lxc ]] && LXC=1
[[ $LXC = 1 && -e /usr/bin/boringtun ]] && UP='WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun wg-quick up wgcf' || UP='wg-quick up wgcf'

# 安装BBR
bbrInstall() {
	red "\n=============================================================="
	yellow " $T47\n "
	green " 1.$T48 "
	[[ -n $PLAN ]] && green " 2.$T49 " || green " 2.$T76 "
	red "=============================================================="
	reading " $T50 " BBR
	case "$BBR" in
		1 ) wget --no-check-certificate -N "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh;;
		2 ) [[ -n $PLAN ]] && menu$PLAN || exit;;
		* ) red " $T51 [1-2]"; sleep 1; bbrInstall;;
	esac
	}

# 关闭 WARP 网络接口，并删除 WGCF
uninstall(){
	unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6
	# 卸载 WGCF
	uninstall_wgcf(){
	wg-quick down wgcf >/dev/null 2>&1
#	systemctl stop wg-quick@wgcf >/dev/null 2>&1
	systemctl disable --now wg-quick@wgcf >/dev/null 2>&1
#	systemctl stop boringtun@wgcf >/dev/null 2>&1
	systemctl disable --now boring@wgcf >/dev/null 2>&1
	[[ $(type -P yum ) ]] && yum -y autoremove wireguard-tools wireguard-dkms 2>/dev/null || apt -y autoremove wireguard-tools wireguard-dkms 2>/dev/null
	rm -rf /usr/local/bin/wgcf /etc/wireguard /usr/bin/boringtun /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf /usr/bin/warp /usr/lib/systemd/system/boringtun@.service
	[[ -e /etc/gai.conf ]] && sed -i '/^precedence \:\:ffff\:0\:0/d' /etc/gai.conf
	[[ -e /etc/gai.conf ]] && sed -i '/^label 2002\:\:\/16/d' /etc/gai.conf
	}
	
	# 卸载 Linux Client
	uninstall_proxy(){
	warp-cli --accept-tos disconnect >/dev/null 2>&1
	warp-cli --accept-tos disable-always-on >/dev/null 2>&1
	warp-cli --accept-tos delete >/dev/null 2>&1
	[[ $(type -P yum ) ]] && yum -y autoremove cloudflare-warp 2>/dev/null || apt -y autoremove cloudflare-warp 2>/dev/null
#	systemctl stop warp-svc >/dev/null 2>&1
	systemctl disable --now warp-svc >/dev/null 2>&1
	}
	
	# 根据已安装情况执行卸载任务并显示结果
	[[ $(type -P wg-quick) ]] && (uninstall_wgcf; green " $T117 ")
	[[ $(type -P warp-cli) ]] && (uninstall_proxy; green " $T119 ")
	
	# 显示卸载结果
	IP4=$(curl -s4m7 https://ip.gs/json)
	IP6=$(curl -s6m7 https://ip.gs/json)
	WAN4=$(echo $IP4 | cut -d \" -f4)
	WAN6=$(echo $IP6 | cut -d \" -f4)
	[[ $LANGUAGE != 2 ]] && COUNTRY4=$(echo $IP4 | cut -d \" -f10) || COUNTRY4=$(curl -sm4 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$(echo $IP4 | cut -d \" -f10)" | cut -d \" -f18)
	[[ $LANGUAGE != 2 ]] && COUNTRY6=$(echo $IP6 | cut -d \" -f10) || COUNTRY6=$(curl -sm4 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$(echo $IP6 | cut -d \" -f10)" | cut -d \" -f18)
	ASNORG4=$(echo $IP4 | awk -F "asn_org" '{print $2}' | awk -F "hostname" '{print $1}' | awk -F "user_agent" '{print $1}' | sed "s/[,\":]//g")
	ASNORG6=$(echo $IP6 | awk -F "asn_org" '{print $2}' | awk -F "hostname" '{print $1}' | awk -F "user_agent" '{print $1}' | sed "s/[,\":]//g")
	green " $T45\n IPv4：$WAN4 $COUNTRY4 $ASNORG4\n IPv6：$WAN6 $COUNTRY6 $ASNORG6 "
	}
	

# 同步脚本至最新版本
ver(){
	wget -N $CDN -P /etc/wireguard https://raw.githubusercontent.com/fscarmen/warp/main/menu.sh || wget -N $CDN -P /etc/wireguard https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh
	chmod +x /etc/wireguard/menu.sh
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp
	[[ $LANGUAGE != 2 ]] && CUT=-f2 || CUT=-f4
	green " $T64:$(grep ^VERSION /etc/wireguard/menu.sh | cut -d = -f2)  $T18：$(grep T1= /etc/wireguard/menu.sh | cut -d \" $CUT | head -1) " || red " $T65 "
	exit
	}

# 由于warp bug，有时候获取不了ip地址，加入刷网络脚本手动运行，并在定时任务加设置 VPS 重启后自动运行,i=当前尝试次数，j=要尝试的次数
net(){
	unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6
	[[ ! $(type -P wg-quick) || ! -e /etc/wireguard/wgcf.conf ]] && red " $T10 " && exit 1
	i=1;j=10
	[[ $LANGUAGE != 2 ]] && T11="Maximum $j attempts to get WARP IP..." || T11="后台获取 WARP IP 中,最大尝试$j次……"
	[[ $LANGUAGE != 2 ]] && T12="Try $i" || T12="第$i次尝试"
	[[ $LANGUAGE != 2 ]] && T13="There have been more than $j failures. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]" || T13="失败已超过$j次，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
	yellow " $T11 "
	yellow " $T12 "
	[[ $(systemctl is-active wg-quick@wgcf) != active && $(systemctl is-active boringtun@wgcf) != active ]] && wg-quick down wgcf >/dev/null 2>&1
	[[ $LXC = 1 && -e /usr/bin/boringtun ]] && systemctl start boringtun@wgcf >/dev/null 2>&1 || systemctl start wg-quick@wgcf >/dev/null 2>&1
	echo $UP | sh >/dev/null 2>&1
	IP4=$(curl -s4m7 https://ip.gs/json) &&
	IP6=$(curl -s6m7 https://ip.gs/json)
	until [[ -n $IP4 && -n $IP6 ]]
		do	let i++
			[[ $LANGUAGE != 2 ]] && T12="Try $i" || T12="第$i次尝试"
			yellow " $T12 "
			wg-quick down wgcf >/dev/null 2>&1
			echo $UP | sh >/dev/null 2>&1
			IP4=$(curl -s4m7 https://ip.gs/json) &&
			IP6=$(curl -s6m7 https://ip.gs/json)
			[[ $i = $j ]] && (wg-quick down wgcf >/dev/null 2>&1; red " $T13 ") && exit 1
        	done
	WAN4=$(echo $IP4 | cut -d \" -f4)
	WAN6=$(echo $IP6 | cut -d \" -f4)
	[[ $LANGUAGE != 2 ]] && COUNTRY4=$(echo $IP4 | cut -d \" -f10) || COUNTRY4=$(curl -sm4 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$(echo $IP4 | cut -d \" -f10)" | cut -d \" -f18)
	[[ $LANGUAGE != 2 ]] && COUNTRY6=$(echo $IP6 | cut -d \" -f10) || COUNTRY6=$(curl -sm4 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$(echo $IP6 | cut -d \" -f10)" | cut -d \" -f18)
	ASNORG4=$(echo $IP4 | awk -F "asn_org" '{print $2}' | awk -F "hostname" '{print $1}' | awk -F "user_agent" '{print $1}' | sed "s/[,\":]//g")
	ASNORG6=$(echo $IP6 | awk -F "asn_org" '{print $2}' | awk -F "hostname" '{print $1}' | awk -F "user_agent" '{print $1}' | sed "s/[,\":]//g")
	green " $T14 "
	[[ $OPTION = [OoNn] ]] && green " IPv4:$WAN4 $COUNTRY4 $ASNORG4\n IPv6:$WAN6 $COUNTRY6 $ASNORG6 "
	}

# WARP 开关
onoff(){
	[[ -n $(wg 2>/dev/null) ]] && (wg-quick down wgcf >/dev/null 2>&1; green " $T15 ") || net
	}

# PROXY 开关
proxy_onoff(){
    PROXY=$(warp-cli --accept-tos status 2>/dev/null)
    [[ -z $PROXY ]] && red " $T93 " && exit 1
    [[ $PROXY =~ Connecting ]] && red " $T96 " && exit 1
    [[ $PROXY =~ Connected ]] && warp-cli --accept-tos disconnect >/dev/null 2>&1 && warp-cli --accept-tos disable-always-on >/dev/null 2>&1 && 
    [[ ! $(ss -nltp) =~ 'warp-svc' ]] && green " $T91 "  && exit 0
    [[ $PROXY =~ Disconnected ]] && warp-cli --accept-tos connect >/dev/null 2>&1 && warp-cli --accept-tos enable-always-on >/dev/null 2>&1 && STATUS=1
    [[ $STATUS = 1 ]] && [[ $(ss -nltp) =~ 'warp-svc' ]] && green " $T90 " && exit 0
    [[ $STATUS = 1 ]] && [[ $(warp-cli --accept-tos status 2>/dev/null) =~ Connecting ]] && red " $T96 " && exit 1
    }

# 设置部分后缀 2/3
case "$OPTION" in
[Bb] )	bbrInstall; exit 0;;
[Uu] )	uninstall; exit 0;;
[Vv] )	ver; exit 0;;
[Nn] )	net; exit 0;;
[Oo] )	onoff; exit 0;;
[Rr] )	proxy_onoff; exit 0;;
esac

# 必须加载 TUN 模块
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

# 多方式判断操作系统，试到有值为止。只支持 Debian 10/11、Ubuntu 18.04/20.04 或 Centos 7/8 ,如非上述操作系统，退出脚本
[[ -f /etc/os-release ]] && SYS=$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)
[[ -z $SYS ]] && SYS=$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)
[[ -z $SYS ]] && SYS=$(lsb_release -sd 2>/dev/null)
[[ -z $SYS && -f /etc/lsb-release ]] && SYS=$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)
[[ -z $SYS && -f /etc/redhat-release ]] && SYS=$(grep . /etc/redhat-release 2>/dev/null)
[[ -z $SYS && -f /etc/issue ]] && SYS=$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')
[[ $(echo $SYS | tr A-Z a-z) =~ debian ]] && SYSTEM=debian
[[ $(echo $SYS | tr A-Z a-z) =~ ubuntu ]] && SYSTEM=ubuntu
[[ $(echo $SYS | tr A-Z a-z) =~ centos|kernel|'oracle linux' ]] && SYSTEM=centos
[[ $(echo $SYS | tr A-Z a-z) =~ 'amazon linux' ]] && SYSTEM=centos && COMPANY=amazon
[[ -z $SYSTEM ]] && red " $T5 " && exit 1
[[ $LANGUAGE != 2 ]] && T26="Curren operating system is $SYS.\n The script supports Debian 10/11; Ubuntu 18.04/20.24 or CentOS 7/8 only. Feedback: [https://github.com/fscarmen/warp/issues]" || T26="当前操作是 $SYS\n 本脚本只支持 Debian 10/11; Ubuntu 18.04/20.24 和 CentOS 7/8 系统,问题反馈:[https://github.com/fscarmen/warp/issues]"
[[ $SYSTEM = debian ]] && [[ $(echo $SYS | sed 's/[^0-9.]//g' | cut -d . -f1) -lt 10 ]] && red " $T26 " && exit 1
[[ $SYSTEM = ubuntu ]] && [[ $(echo $SYS | sed 's/[^0-9.]//g' | cut -d . -f1) -lt 18 ]] && red " $T26 " && exit 1
[[ $SYSTEM = centos ]] && [[ $(echo $SYS | sed 's/[^0-9.]//g' | cut -d . -f1) -lt 7 ]] && red " $T26 " && exit 1

# 安装 curl
[[ $SYSTEM != centos && ! $(type -P curl) ]] && yellow " $T7 " && apt -y install curl >/dev/null 2>&1
[[ $SYSTEM = centos && ! $(type -P curl) ]] && yellow " $T7 " && yum -y install curl >/dev/null 2>&1
[[ $SYSTEM != centos && ! $(type -P curl) ]] && yellow " $T8 " && apt -y update && apt -y install curl >/dev/null 2>&1
[[ $SYSTEM = centos && ! $(type -P curl) ]] && yellow " $T8 " && yum -y update && yum -y install curl >/dev/null 2>&1
[[ ! $(type -P curl) ]] && yellow " $T9 " && exit 1

# 判断处理器架构
[[ $(arch | tr A-Z a-z) =~ aarch ]] && ARCHITECTURE=arm64 || ARCHITECTURE=amd64

# 判断当前 IPv4 与 IPv6 ，IP归属 及 WARP, Linux Client 是否开启
[[ $IPV4 = 1 ]] && LAN4=$(ip route get 162.159.192.1 2>/dev/null | grep -oP 'src \K\S+') &&
		IP4=$(curl -s4m4 https://ip.gs/json) &&
		WAN4=$(echo $IP4 | cut -d \" -f4) &&
		ASNORG4=$(echo $IP4 | awk -F "asn_org" '{print $2}' | awk -F "hostname" '{print $1}' | awk -F "user_agent" '{print $1}' | sed "s/[,\":]//g") &&
		TRACE4=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)
[[ $IPV6 = 1 ]] && LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | grep -oP 'src \K\S+') &&
		IP6=$(curl -s6m4 https://ip.gs/json) &&
		WAN6=$(echo $IP6 | cut -d \" -f4) &&
		ASNORG6=$(echo $IP6 | awk -F "asn_org" '{print $2}' | awk -F "hostname" '{print $1}' | awk -F "user_agent" '{print $1}' | sed "s/[,\":]//g") &&
		TRACE6=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)
[[ $LANGUAGE != 2 && $IPV4 = 1 ]] && COUNTRY4=$(echo $IP4 | cut -d \" -f10) || COUNTRY4=$(curl -sm4 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$(echo $IP4 | cut -d \" -f10)" | cut -d \" -f18)
[[ $LANGUAGE != 2 && $IPV6 = 1 ]] && COUNTRY6=$(echo $IP6 | cut -d \" -f10) || COUNTRY6=$(curl -sm4 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$(echo $IP6 | cut -d \" -f10)" | cut -d \" -f18)

# 判断当前 WARP 状态，决定变量 PLAN，变量 PLAN 含义：1=单栈  2=双栈  3=WARP已开启
[[ $TRACE4 = plus || $TRACE4 = on || $TRACE6 = plus || $TRACE6 = on ]] && PLAN=3 || PLAN=$(($IPV4+$IPV6))
[[ $TRACE4 = plus ]] && PLUS4=+
[[ $TRACE6 = plus ]] && PLUS6=+

# 判断当前 Linux Client 状态，决定变量 CLIENT，变量 CLIENT 含义：0=未安装  1=已安装未激活  2=状态激活  3=Clinet 已开启
[[ $(type -P warp-cli 2>/dev/null) ]] && CLIENT=1 || CLIENT=0
[[ $CLIENT = 1 ]] && [[ $(systemctl is-active warp-svc 2>/dev/null) = active || $(systemctl is-enabled warp-svc 2>/dev/null) = enabled ]] && CLIENT=2
[[ $CLIENT = 2 ]] && [[ $(ss -nltp) =~ 'warp-svc' ]] && CLIENT=3
[[ $(warp-cli --accept-tos account 2>/dev/null) =~ Limited ]] && AC=+

# 在KVM的前提下，判断 Linux 版本是否小于 5.6，如是则安装 wireguard 内核模块，变量 WG=1。由于 linux 不能直接用小数作比较，所以用 （主版本号 * 100 + 次版本号 ）与 506 作比较
[[ $LXC != 1 && $(($(uname  -r | cut -d . -f1) * 100 +  $(uname  -r | cut -d . -f2))) -lt 506 ]] && WG=1

# WGCF 配置修改，其中用到的 162.159.192.1 和 2606:4700:d0::a29f:c001 均是 engage.cloudflareclient.com 的IP
MODIFYS01='sed -i "/\:\:\/0/d;s/engage.cloudflareclient.com/[2606:4700:d0::a29f:c001]/g" wgcf-profile.conf'
MODIFYD01='sed -i "7 s/^/PostDown = ip -6 rule delete from '$LAN6' lookup main\n/;7 s/^/PostUp = ip -6 rule add from '$LAN6' lookup main\n/;s/engage.cloudflareclient.com/[2606:4700:d0::a29f:c001]/g;s/1.1.1.1/1.1.1.1,9.9.9.9,8.8.8.8/g" wgcf-profile.conf'
MODIFYS10='sed -i "/0\.\0\/0/d;s/engage.cloudflareclient.com/162.159.192.1/g;s/1.1.1.1/9.9.9.9,8.8.8.8,1.1.1.1/g" wgcf-profile.conf'
MODIFYD10='sed -i "7 s/^/PostDown = ip -4 rule delete from '$LAN4' lookup main\n/;7 s/^/PostUp = ip -4 rule add from '$LAN4' lookup main\n/;s/engage.cloudflareclient.com/162.159.192.1/g;s/1.1.1.1/9.9.9.9,8.8.8.8,1.1.1.1/g" wgcf-profile.conf'
MODIFYD11='sed -i "7 s/^/PostDown = ip -6 rule delete from '$LAN6' lookup main\n/;7 s/^/PostUp = ip -6 rule add from '$LAN6' lookup main\n/;7 s/^/PostDown = ip -4 rule delete from '$LAN4' lookup main\n/;7 s/^/PostUp = ip -4 rule add from '$LAN4' lookup main\n/;s/1.1.1.1/9.9.9.9,8.8.8.8,1.1.1.1/g" wgcf-profile.conf'

# VPS 当前状态
status(){
	clear
	yellow " $T16 "
	red "======================================================================================================================\n"
	green " $T17：$VERSION  $T18：$TXT\n $T19：\n	$T20：$SYS\n	$T21：$(uname -r)\n	$T22：$ARCHITECTURE\n	$T23：$VIRT "
	[[ $TRACE4 = plus || $TRACE4 = on ]] && green "	IPv4：$WAN4 ( WARP$PLUS4 IPv4 ) $COUNTRY4  $ASNORG4 "
	[[ $TRACE4 = off ]] && green "	IPv4：$WAN4 $COUNTRY4 $ASNORG4 "
	[[ $TRACE6 = plus || $TRACE6 = on ]] && green "	IPv6：$WAN6 ( WARP$PLUS6 IPv6 ) $COUNTRY6 $ASNORG6 "
	[[ $TRACE6 = off ]] && green "	IPv6：$WAN6 $COUNTRY6 $ASNORG6 "
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green "	$T114	$T25：$(grep 'Device name' /etc/wireguard/info.log 2>/dev/null | awk '{ print $NF }') "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green "	$T115 " 	
	[[ $PLAN != 3 ]] && green "	$T116 "
	[[ $CLIENT = 0 ]] && green "	$T112 "
	[[ $CLIENT = 2 ]] && green "	$T113 "
	[[ $CLIENT = 3 ]] && green "	WARP$AC $T24	$(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+') "
 	red "\n======================================================================================================================\n"
	}

# 输入 WARP+ 账户（如有），限制位数为空或者26位以防输入错误
input_license(){
	[[ -z $LICENSE ]] && reading " $T28 " LICENSE
	i=5
	until [[ -z $LICENSE || ${#LICENSE} = 26 ]]
		do	let i--
			[[ $LANGUAGE != 2 ]] && T30="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. ($i times remaining):" || T30="License 应为26位字符，请重新输入 Warp+ License，没有可回车继续(剩余$i次):"
			[[ $i = 0 ]] && red " $T29 " && exit 1 || reading " $T30 " LICENSE
		done
	[[ $INPUT_LICENSE = 1 && -n $LICENSE && -z $NAME ]] && reading " $T102 " NAME
	[[ -n $NAME ]] && DEVICE="--name $(echo $NAME | sed s/[[:space:]]/_/g)"
}

# 升级 WARP+ 账户（如有），限制位数为空或者26位以防输入错误
update_license(){
	[[ -z $LICENSE ]] && reading " $T61 " LICENSE
	i=5
	until [[ ${#LICENSE} = 26 ]]
		do	let i--
			[[ $LANGUAGE != 2 ]] && T100="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. ($i times remaining): " || T62="License 应为26位字符,请重新输入 WARP+ License (剩余$i次): "
			[[ $i = 0 ]] && red " $T29 " && exit 1 || reading " $T100 " LICENSE
	       done
	[[ $UPDATE_LICENSE = 1 && -n $LICENSE && -z $NAME ]] && reading " $T102 " NAME
	[[ -n $NAME ]] && DEVICE="--name $(echo $NAME | sed s/[[:space:]]/_/g)"
}

# 输入 Linux Client 端口，先检查默认的40000是否被占用
input_port(){
	[[ -n $(ss -nltp | grep ':40000') ]] && reading " $T103 " PORT || reading " $T104 " PORT
	PORT=${PORT:-40000}
	i=5
	until [[ $(echo $PORT | egrep "^[1-9][0-9]{3,4}$") && ! $(ss -nltp) =~ ":$PORT" ]]
		do	let i--
			[[ $i = 0 ]] && red " $T29 " && exit 1
			[[ $LANGUAGE != 2 ]] && T103="Port is in use. Please input another Port($i times remaining):" || T103="端口占用中，请使用另一端口(剩余$i次):"
			[[ $LANGUAGE != 2 ]] && T111="Port must be 4-5 digits. Please re-input($i times remaining):" || T111="端口必须为4-5位自然数，请重新输入(剩余$i次):"
			[[ ! $(echo $PORT | egrep "^[1-9][0-9]{3,4}$") ]] && reading " $T111 " PORT
			[[ $(echo $PORT | egrep "^[1-9][0-9]{3,4}$") ]] && [[ $(ss -nltp) =~ ":$PORT" ]] && reading " $T103 " PORT
		done
}

stack_priority(){
	sed -i '/^precedence \:\:ffff\:0\:0/d' /etc/gai.conf
	sed -i '/^label 2002\:\:\/16/d' /etc/gai.conf
	case "$PRIORITY" in
		2 )	echo "label 2002::/16   2" >> /etc/gai.conf;;
		3 )	;;
		* )	echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf;;
	esac
}

# WGCF 安装
install(){
	INPUT_LICENSE=1 && input_license

	# OpenVZ / LXC 选择 Wireguard-GO 或者 BoringTun 方案，并重新定义相应的 UP 和 DOWN 指令
	[[ $LXC = 1 ]] && reading " $T31 " BORINGTUN
	[[ $BORINGTUN = 2 ]] && UP='WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun WG_SUDO=1 wg-quick up wgcf' || UP='wg-quick up wgcf'
	[[ $BORINGTUN = 2 ]] && DOWN='wg-quick down wgcf && kill $(pgrep -f boringtun)' || DOWN='wg-quick down wgcf'
	[[ $BORINGTUN = 2 ]] && WB=boringtun || WB=wireguard-go
	
	# 选择优先使用 IPv4 /IPv6 网络
	reading " $T105 " PRIORITY
	
	# 脚本开始时间
	start=$(date +%s)
	green " $T32 "
	
	# 先删除之前安装，可能导致失败的文件，添加环境变量
	rm -rf /usr/local/bin/wgcf /usr/bin/boringtun /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf
	[[ $PATH =~ /usr/local/bin ]] || export PATH=$PATH:/usr/local/bin
	
	# 对于 IPv4 only VPS 开启 IPv6 支持
    	[[ $IPV4$IPV6 = 10 ]] && [[ $(sysctl -a 2>/dev/null | grep 'disable_ipv6.*=.*1') || $(grep -s "disable_ipv6.*=.*1" /etc/sysctl.{conf,d/*} ) ]] &&
	(sed -i '/disable_ipv6/d' /etc/sysctl.{conf,d/*}
        echo 'net.ipv6.conf.all.disable_ipv6 = 0' >/etc/sysctl.d/ipv6.conf
        sysctl -w net.ipv6.conf.all.disable_ipv6=0)
	
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
		VERSION_ID=$(grep -i version_id /etc/os-release | cut -d \" -f2 | cut -d . -f1)
		[[ $WG = 1 ]] && curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-$VERSION_ID/jdoss-wireguard-epel-$VERSION_ID.repo &&
		yum -y install wireguard-dkms

		# 升级所有包同时也升级软件和系统内核
		yum -y update
		}

	$SYSTEM

	# 安装并认证 WGCF
	green " $T33 "

	# 判断 wgcf 的最新版本,如因 github 接口问题未能获取，默认 v2.2.9
	latest=$(wget --no-check-certificate -qO- -T1 -t1 $CDN "https://api.github.com/repos/ViRb3/wgcf/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g')
	[[ -z $latest ]] && latest='2.2.9'

	# 安装 wgcf，尽量下载官方的最新版本，如官方 wgcf 下载不成功，将使用 jsDelivr 的 CDN，以更好的支持双栈。并添加执行权限
	wget --no-check-certificate -T1 -t1 -N $CDN -O /usr/local/bin/wgcf https://github.com/ViRb3/wgcf/releases/download/v$latest/wgcf_${latest}_linux_$ARCHITECTURE
	[[ $? != 0 ]] && wget --no-check-certificate -N $CDN -O /usr/local/bin/wgcf https://cdn.jsdelivr.net/gh/fscarmen/warp/wgcf_${latest}_linux_$ARCHITECTURE
	chmod +x /usr/local/bin/wgcf

	# 注册 WARP 账户 (将生成 wgcf-account.toml 文件保存账户信息)
	yellow " $T34 "
	until [[ -e wgcf-account.toml ]]
	  do
	   wgcf register --accept-tos >/dev/null 2>&1
	done

	# 如有 WARP+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
	mkdir -p /etc/wireguard/ >/dev/null 2>&1
	[[ -n $LICENSE ]] && yellow " $T35 " && sed -i "s/license_key.*/license_key = \"$LICENSE\"/g" wgcf-account.toml &&
	( wgcf update $DEVICE > /etc/wireguard/info.log 2>&1 || red " $T36 " )

	# 生成 Wire-Guard 配置文件 (wgcf-profile.conf)
	wgcf generate >/dev/null 2>&1

	# 反复测试最佳 MTU。 
	# Wireguard Header：IPv4=60 bytes, BoringTUN Header：100 bytes，IPv6=80 bytes，1280 ≤1 MTU ≤ 1420。 ping = 8(ICMP回显示请求和回显应答报文格式长度) + 20(IP首部)。
	# 详细说明：<[WireGuard] Header / MTU sizes for Wireguard>：https://lists.zx2c4.com/pipermail/wireguard/2017-December/002201.html
	yellow " $T81 "
	MTU=$((1500-28))
	[[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	until [[ $? = 0 || MTU -le $((1280+80-28)) ]]
	do
	MTU=$(($MTU-10))
	[[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	done
	[[ $MTU -lt $((1500-28)) ]] && MTU=$(($MTU+9))
	[[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	until [[ $? = 0 || MTU -le $((1280+80-28)) ]]
	do
        MTU=$(($MTU-1))
        [[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1      
	done
	[[ $BORINGTUN = 2 ]] && MTU=$(($MTU+28-100)) || MTU=$(($MTU+28-80))
	[[ $MTU -lt 1280 ]] && MTU=1280

	# 修改配置文件
	sed -i "s/MTU.*/MTU = $MTU/g" wgcf-profile.conf
	echo $MODIFY | sh

	# 把 wgcf-profile.conf 复制到/etc/wireguard/ 并命名为 wgcf.conf
	cp -f wgcf-profile.conf /etc/wireguard/wgcf.conf >/dev/null 2>&1

	# 设置开机启动
	[[ $BORINGTUN = 2 ]] && cat <<EOF >/lib/systemd/system/boringtun@.service
	[Unit]
	Description=BoringTUN via wg-quick for %I
	Before=network-pre.target

	[Service]
	Type=oneshot
	RemainAfterExit=yes
	User=root
	WorkingDirectory=/root
	ExecStart=/usr/bin/wg-quick up %i
	ExecStop=/usr/bin/wg-quick down %i
	Environment=WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun
	Restart=on-failure

	[Install]
	WantedBy=multi-user.target

	EOF
	
	[[ $BORINGTUN = 2 ]] && systemctl start boringtun@wgcf >/dev/null 2>&1
	[[ $BORINGTUN = 2 ]] && systemctl enable --now boringtun@wgcf >/dev/null 2>&1
	[[ $BORINGTUN != 2 ]] && systemctl start wg-quick@wgcf >/dev/null 2>&1
	[[ $BORINGTUN != 2 ]] && systemctl enable --now wg-quick@wgcf >/dev/null 2>&1

	# 如是 LXC，安装 Wireguard-GO 或者 BoringTun。部分较低内核版本的KVM，即使安装了wireguard-dkms, 仍不能正常工作，兜底使用 wireguard-go
	[[ $LXC = 1 ]] && wget --no-check-certificate -N $CDN -P /usr/bin https://cdn.jsdelivr.net/gh/fscarmen/warp/$WB && chmod +x /usr/bin/$WB
	[[ $WG = 1 ]] && [[ $(systemctl is-active wg-quick@wgcf) != active || $(systemctl is-enabled wg-quick@wgcf) != enabled ]] &&
	wget --no-check-certificate -N $CDN -P /usr/bin https://cdn.jsdelivr.net/gh/fscarmen/warp/wireguard-go && chmod +x /usr/bin/wireguard-go

	# 优先使用 IPv4 /IPv6 网络
	stack_priority

	# 保存好配置文件
	mv -f wgcf-account.toml wgcf-profile.conf menu.sh /etc/wireguard >/dev/null 2>&1

	# 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令
	chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp && green " $T38 "
	
	# 自动刷直至成功（ warp bug，有时候获取不了ip地址），重置之前的相关变量值，记录新的 IPv4 和 IPv6 地址和归属地，IPv4 / IPv6 优先级别
	green " $T39 "
	unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6 TRACE4 TRACE6
	[[ $LANGUAGE != 2 ]] && T40="$COMPANY vps needs to restart and run [warp n] to open WARP." || T40="$COMPANY vps 需要重启后运行 warp n 才能打开 WARP,现执行重启"
	[[ $COMPANY = amazon ]] && red " $T40 " && reboot || net
	TRACE4=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)
	TRACE6=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2)
	[[ $(curl -sm8 https://ip.gs) = $WAN6 ]] && T108=$T106 || T108=$T107

	# 结果提示，脚本运行时间
	red "\n==============================================================\n"
	[[ $TRACE4 = plus ]] && green " IPv4：$WAN4 ( WARP+ IPv4 ) $COUNTRY4 $ASNORG4 "
	[[ $TRACE4 = on ]] && green " IPv4：$WAN4 ( WARP IPv4 ) $COUNTRY4 $ASNORG4 "
	[[ $TRACE4 = off || -z $TRACE4 ]] && green " IPv4：$WAN4 $COUNTRY4 $ASNORG4 "
	[[ $TRACE6 = plus ]] && green " IPv6：$WAN6 ( WARP+ IPv6 ) $COUNTRY6 $ASNORG6 "
	[[ $TRACE6 = on ]] && green " IPv6：$WAN6 ( WARP IPv6 ) $COUNTRY6 $ASNORG6 "
	[[ $TRACE6 = off || -z $TRACE6 ]] && green " IPv6：$WAN6 $COUNTRY6 $ASNORG6 "
	end=$(date +%s)
	[[ $LANGUAGE != 2 ]] && T41="Congratulations! WARP+ is turned on. Spend time:$(( $end - $start )) seconds\n Device name：$(grep -s 'Device name' /etc/wireguard/info.log | awk '{ print $NF }')\n Quota：$(grep -s Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" || T41="恭喜！WARP+ 已开启，总耗时:$(( $end - $start ))秒\n 设备名：$(grep -s 'Device name' /etc/wireguard/info.log | awk '{ print $NF }')\n 剩余流量：$(grep -s Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')"
	[[ $LANGUAGE != 2 ]] && T42="Congratulations! WARP is turned on. Spend time:$(( $end - $start )) seconds" || T42="恭喜！WARP 已开启，总耗时:$(( $end - $start ))秒"
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green " $T41 "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green " $T42 "
	green " $T108 "
	red "\n==============================================================\n"
	yellow " $T43\n " && help
	[[ $TRACE4 = off && $TRACE6 = off ]] && red " $T44 "
	}

proxy(){
	settings(){
		# 设置为代理模式，如有 WARP+ 账户，修改 license 并升级
		green " $T84 "
		warp-cli --accept-tos register >/dev/null 2>&1
		warp-cli --accept-tos set-mode proxy >/dev/null 2>&1
		warp-cli --accept-tos set-proxy-port $PORT >/dev/null 2>&1
		warp-cli --accept-tos connect >/dev/null 2>&1
		warp-cli --accept-tos enable-always-on >/dev/null 2>&1
		[[ -n $LICENSE ]] && ( yellow " $T35 " && 
		warp-cli --accept-tos set-license $LICENSE >/dev/null 2>&1 && sleep 1 &&
		ACCOUNT=$(warp-cli --accept-tos account 2>/dev/null) &&
		[[ $ACCOUNT =~ Limited ]] && green " $T62 " ||
		red " $T36 " )
		[[ $LANGUAGE != 2 ]] && T86="Client is working. Socks5 proxy listening on: $(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+')" || T86="Linux Client 正常运行中。 Socks5 代理监听:$(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+')"
		[[ ! $(ss -nltp) =~ 'warp-svc' ]] && red " $T87 " && exit 1 || green " $T86 "
		}
	
	[[ $ARCHITECTURE = arm64 ]] && red " $T101 " && exit 1
	[[ $TRACE4 != off ]] && red " $T95 " && exit 1

 	# 安装 WARP Linux Client
	input_license
	input_port
	start=$(date +%s)
	if [[ $CLIENT = 0 ]]; then
	green " $T83 "
	[[ $SYSTEM = centos ]] && (rpm -ivh http://pkg.cloudflareclient.com/cloudflare-release-el$(grep -i version_id /etc/os-release | cut -d \" -f2 | cut -d . -f1).rpm
	yum -y upgrade; yum -y install cloudflare-warp)
	[[ $SYSTEM != centos ]] && apt -y update && apt -y install lsb-release
	[[ $SYSTEM = debian && ! $(type -P gpg 2>/dev/null) ]] && apt -y install gnupg
	[[ $SYSTEM = debian && ! $(apt list 2>/dev/null | grep apt-transport-https ) =~ installed ]] && apt -y install apt-transport-https
	[[ $SYSTEM != centos ]] && (curl https://pkg.cloudflareclient.com/pubkey.gpg | apt-key add -
	echo "deb http://pkg.cloudflareclient.com/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
	apt -y update; apt -y install cloudflare-warp)
	settings

	elif [[ $CLIENT = 2 && $(warp-cli --accept-tos status 2>/dev/null) =~ 'Registration missing' ]]; then
	settings

	else
	red " $T85 " 
	fi

	# 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令
	mkdir -p /etc/wireguard/ >/dev/null 2>&1
	mv -f menu.sh /etc/wireguard >/dev/null 2>&1
	chmod +x /etc/wireguard/menu.sh >/dev/null 2>&1
	ln -sf /etc/wireguard/menu.sh /usr/bin/warp && green " $T38 "
	ACCOUNT=$(warp-cli --accept-tos account 2>/dev/null)
	[[ $ACCOUNT =~ Limited ]] && QUOTA=$(($(echo $ACCOUNT | awk '{ print $(NF-3) }')/1000000000000))
	end=$(date +%s)
	[[ $LANGUAGE != 2 ]] && T94="Congratulations! WARP Linux Client is working on Socks5 proxy:$(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+').\n Spend time:$(( $end - $start )) seconds" || T94="恭喜！WARP Linux Client 工作中, Socks5 代理监听:$(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+')\n 总耗时:$(( $end - $start ))秒"
	[[ $LANGUAGE != 2 ]] && T99="Congratulations! WARP+ Linux Client is working on Socks5 proxy:$(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+').\n Spend time:$(( $end - $start )) seconds\n $T63：$QUOTA TB " || T99="恭喜！WARP+ Linux Client 工作中, Socks5 代理监听:$(ss -nltp | grep warp | grep -oP '1024[ ]*\K\S+')\n 总耗时:$(( $end - $start ))秒\n $T63：$QUOTA TB"
	[[ $ACCOUNT =~ Free ]] && green " $T94 "
	[[ $ACCOUNT =~ Limited ]] && green " $T99 "
	red "\n==============================================================\n"
	yellow " $T43\n " && help
	}

# 免费 WARP 账户升级 WARP+ 账户
update(){
	wgcf_account(){
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && red " $T58 " && exit 1
	[[ ! -e /etc/wireguard/wgcf-account.toml ]] && red " $T59 " && exit 1
	[[ ! -e /etc/wireguard/wgcf.conf ]] && red " $T60 " && exit 1
	UPDATE_LICENSE=1 && update_license
	cd /etc/wireguard
	sed -i "s#license_key.*#license_key = \"$LICENSE\"#g" wgcf-account.toml &&
	wgcf update $DEVICE > /etc/wireguard/info.log 2>&1 &&
	(wgcf generate >/dev/null 2>&1
	sed -i "2s#.*#$(sed -ne 2p wgcf-profile.conf)#" wgcf.conf
	sed -i "3s#.*#$(sed -ne 3p wgcf-profile.conf)#" wgcf.conf
	sed -i "4s#.*#$(sed -ne 4p wgcf-profile.conf)#" wgcf.conf
	wg-quick down wgcf >/dev/null 2>&1
	net
	[[ $(wget --no-check-certificate -qO- -4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) = plus || $(wget --no-check-certificate -qO- -6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) = plus ]] &&
	green " $T62\n $T25：$(grep 'Device name' /etc/wireguard/info.log | awk '{ print $NF }')\n $T63：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" ) || red " $T36 "
	}
	
	client_account(){
	[[ $ARCHITECTURE = arm64 ]] && red " $T101 " && exit 1
	[[ $(warp-cli --accept-tos account) =~ Limited ]] && red " $T97 " && exit 1
	update_license
	warp-cli --accept-tos set-license $LICENSE >/dev/null 2>&1; sleep 1
	ACCOUNT=$(warp-cli --accept-tos account 2>/dev/null)
	[[ $ACCOUNT =~ Limited ]] && green " $T62\n $T63：$(($(echo $ACCOUNT | awk '{ print $(NF-3) }')/1000000000000)) TB " || red " $T36 "
	}
	
	[[ $(type -P wg-quick) && ! $(type -P warp-cli) ]] && wgcf_account
	[[ ! $(type -P wg-quick) && $(type -P warp-cli) ]] && client_account
	[[ $(type -P wg-quick) && $(type -P warp-cli) ]] && 
	(reading " $T98 " MODE
		case "$MODE" in
		1 ) wgcf_account;;		2 ) client_account;;		* ) red " $T51 [1-2] "; sleep 1; update;;
		esac)
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
	[[ $CLIENT = 3 ]] && green " 8. $T89 "
	[[ $CLIENT = 2 ]] && green " 8. $T88 "
	[[ $CLIENT != 2 && $CLIENT != 3 ]] && green " 8. $T82 "
	green " 0. $T76 \n "
	reading " $T50 " CHOOSE1
		case "$CHOOSE1" in
		1 )	MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6);	install;;
		2 )	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
		3 )	net;;
		4 )	uninstall;;
		5 )	bbrInstall;;
		6 )	plus;;
		7 )	ver;;
		8 )	[[ $CLIENT = 2 || $CLIENT = 3 ]] && proxy_onoff || proxy;;
		0 )	exit;;
		* )	red " $T51 [0-8] "; sleep 1; menu1;;
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
	[[ $CLIENT = 3 ]] && green " 7. $T89 "
	[[ $CLIENT = 2 ]] && green " 7. $T88 "
	[[ $CLIENT != 2 && $CLIENT != 3 ]] && green " 7. $T82 "
	green " 0. $T76 \n "
	reading " $T50 " CHOOSE2
		case "$CHOOSE2" in
		1 )	MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6);	install;;
		2 )	net;;
		3 )	uninstall;;
		4 )	bbrInstall;;
		5 )	plus;;
		6 )	ver;;
		7 )	[[ $CLIENT = 2 || $CLIENT = 3 ]] && proxy_onoff || proxy;;
		0 )	exit;;
		* )	red " $T51 [0-7] "; sleep 1; menu2;;
		esac
	}

# 已开启 warp 网络接口
menu3(){ 
	status
	green " 1. $T77 "
	green " 2. $T72 "
	green " 3. $T73 "
	green " 4. $T74 "
	green " 5. $T78 "
	green " 6. $T75 "
	[[ $CLIENT = 3 ]] && green " 7. $T89 "
	[[ $CLIENT = 2 ]] && green " 7. $T88 "
	[[ $CLIENT != 2 && $CLIENT != 3 ]] && green " 7. $T82 "
	green " 0. $T76 \n "
	reading " $T50 " CHOOSE3
        case "$CHOOSE3" in
		1 )	onoff;;
		2 )	uninstall;;
		3 )	bbrInstall;;
		4 )	plus;;
		5 )	update;;
		6 )	ver;;
		7 )	[[ $CLIENT = 2 || $CLIENT = 3 ]] && proxy_onoff || proxy;;
		0 )	exit;;
		* )	red " $T51 [0-7] "; sleep 1; menu3;;
		esac
	}

# 设置部分后缀 3/3
case "$OPTION" in
1 )	# 先判断是否运行 WARP,再按 Client 运行情况分别处理。在已运行 Linux Client 前提下，对于 IPv4 only 只能添加 IPv6 单栈，对于原生双栈不能安装，IPv6 因不能安装 Linux Client 而不用作限制
	if [[ $PLAN = 3 ]]; then
		yellow " $T80 " && wg-quick down wgcf >/dev/null 2>&1 && exit 1
	elif [[ $CLIENT = 3 ]]; then
		[[ $IPV4$IPV6 = 10 ]] && MODIFY=$MODIFYS10
		[[ $IPV4$IPV6 = 11 ]] && red " $T110 " && exit 1
	else [[ $PLAN = 2 ]] && reading " $T79 " DUAL && [[ $DUAL != [Yy] ]] && exit 1 || MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6)
		[[ $PLAN = 1 ]] && MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6)
	fi
	install;;
2 )	# 先判断是否运行 WARP,再按 Client 运行情况分别处理。在已运行 Linux Client 前提下，对于 IPv4 only 只能添加 IPv6 单栈，对于原生双栈不能安装，IPv6 因不能安装 Linux Client 而不用作限制
	if [[ $PLAN = 3 ]]; then
		yellow " $T80 " && wg-quick down wgcf >/dev/null 2>&1 && exit 1
	elif [[ $CLIENT = 3 ]]; then
		[[ $IPV4$IPV6 = 10 ]] && reading " $T109 " SINGLE && [[ $SINGLE != [Yy] ]] && exit 1 || MODIFY=$MODIFYS10
		[[ $IPV4$IPV6 = 11 ]] && red " $T110 " && exit 1
	else MODIFY=$(eval echo \$MODIFYD$IPV4$IPV6)
	fi
	install;;

[Cc] )	[[ $CLIENT = 3 ]] && red " $T92 " && exit 1 || proxy;;
[Dd] )	update;;
* )	menu$PLAN;;
esac
