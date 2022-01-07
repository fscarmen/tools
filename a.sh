#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/bin
export LANG=en_US.UTF-8

# 当前脚本版本号和新增功能
VERSION=1.0

# 自定义字体彩色，read 函数，友道翻译函数
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate(){ [[ -n "$1" ]] && curl -sm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$1" | cut -d \" -f18 2>/dev/null; }

# 传参选项 OPTION：1=为 IPv4 或者 IPv6 补全另一栈 WARP; u=卸载 WARP; o=WARP开关; 其他或空值=菜单界面
[[ $1 != '[option]' ]] && OPTION=$(tr '[:upper:]' '[:lower:]' <<< "$1")
# 参数选项 URL 或 License
if [[ $2 != '[lisence]' ]]; then
	if [[ $2 =~ 'http' ]]; then
	LICENSETYPE=2 && URL=$2
	elif [[ $2 =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; then
	LICENSETYPE=1 && LICENSE=$2
	fi
fi

# 自定义 WARP+ 设备名
NAME=$3

declare -A T

T[E0]="\n Language:\n  1.English (default) \n  2.简体中文\n"
T[C0]="${T[E0]}"
T[E1]="wgcf on docker"
T[C1]="docker 的 wgcf 为宿主机服务"
T[E2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C2]="必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E3]="The TUN module is not loaded. You should turn it on in the control panel. Ask the supplier for more help. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C3]="没有加载 TUN 模块，请在管理后台开启或联系供应商了解如何开启，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E4]="The WARP server cannot be connected. It may be a China Mainland VPS. You can manually ping 162.159.192.1 or ping6 2606:4700:d0::a29f:c001.You can run the script again if the connect is successful. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C4]="与 WARP 的服务器不能连接,可能是大陆 VPS，可手动 ping 162.159.192.1 或 ping6 2606:4700:d0::a29f:c001，如能连通可再次运行脚本，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E5]="The script supports Debian, Ubuntu, CentOS or Alpine systems only. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C5]="本脚本只支持 Debian、Ubuntu、CentOS 或 Alpine 系统,问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E6]="warp h (help)\n warp o (Turn off WARP temporarily)\n warp u (Turn off and uninstall WARP docker)\n warp d (Upgrade to WARP+ account)\n warp d N5670ljg-sS9jD334-6o6g4M9F (Upgrade to WARP+ account with the license)\n warp d http://gist.github.com/teams.xml (Upgrade to Teams account with the URL)\n warp v (Sync the latest version)\n warp 1 (Add WARP IPv6 interface to native IPv4 VPS or WARP IPv4 interface to native IPv6 VPS)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F Goodluck (Add IPv4 or IPV6 WARP+ interface with the license and named Goodluck)\n"
T[C6]="warp h (帮助菜单）\n warp o (临时warp开关)\n warp u (卸载 WARP 网络接口和 Socks5 Client)\n warp d (免费 WARP 账户升级 WARP+)\n warp d N5670ljg-sS9jD334-6o6g4M9F (指定 License 升级 WARP+)\n warp d http://gist.github.com/teams.xml (指定 URL 升级 Teams)\n warp v (同步脚本至最新版本)\n warp 1 (Warp单栈)\n warp 1 N5670ljg-sS9jD334-6o6g4M9F Goodluck (指定 WARP+ License Warp 单栈，设备名为 Goodluck)\n"
T[C7]="安装curl中……"
T[E8]="It is necessary to upgrade the latest package library before install curl.It will take a little time,please be patiently..."
T[C8]="先升级软件库才能继续安装 curl，时间较长，请耐心等待……"
T[E9]="Failed to install curl. The script is aborted. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C9]="安装 curl 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E10]="WireGuard tools are not installed or the configuration file wgcf.conf cannot be found, please reinstall."
T[C10]="没有安装 WireGuard tools 或者找不到配置文件 wgcf.conf，请重新安装。"
T[E11]=""
T[C11]=""
T[E12]=""
T[C12]=""
T[E13]=""
T[C13]=""
T[E14]="Got the WARP IP successfully."
T[C14]="已成功获取 WARP 网络"
T[E15]="WARP is turned off. It could be turned on again by [warp o]"
T[C15]="已暂停 WARP，再次开启可以用 warp o"
T[E16]=""
T[C16]=""
T[E17]="Version"
T[C17]="脚本版本"
T[E18]="New features"
T[C18]="功能新增"
T[E19]="System infomation"
T[C19]="系统信息"
T[E20]="Operating System"
T[C20]="当前操作系统"
T[E21]="Kernel"
T[C21]="内核"
T[E22]="Architecture"
T[C22]="处理器架构"
T[E23]="Virtualization"
T[C23]="虚拟化"
T[E24]=""
T[C24]=""
T[E25]="Device name"
T[C25]="设备名"
T[E26]="Curren operating system is \$SYS.\\\n The system lower than \$SYSTEM \${MAJOR[int]} is not supported. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C26]="当前操作是 \$SYS\\\n 不支持 \$SYSTEM \${MAJOR[int]} 以下系统,问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E27]=""
T[C27]=""
T[E28]="If there is a WARP+ License, please enter it, otherwise press Enter to continue:"
T[C28]="如有 WARP+ License 请输入，没有可回车继续:"
T[E29]="Input errors up to 5 times.The script is aborted."
T[C29]="输入错误达5次，脚本退出"
T[E30]="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. \(\$i times remaining\):"
T[C30]="License 应为26位字符，请重新输入 WARP+ License，没有可回车继续\(剩余\$i次\):"
T[E31]="\n 1.Update with WARP+ license\n 2.Update with Teams (You need upload the Teams file to a private storage space before. For example: gist.github.com)\n"
T[C31]="\n 1.使用 WARP+ license 升级\n 2.使用 Teams 升级 (你须事前把 Teams 文件上传到私密存储空间，比如：gist.github.com )\n"
T[E32]="Step 1/3: Install docker..."
T[C32]="进度 1/3：安装 docker……"
T[E33]="Step 2/3: WGCF is ready"
T[C33]="进度 2/3：已安装 WGCF"
T[E34]=""
T[C34]=""
T[E35]="Update WARP+ account..."
T[C35]="升级 WARP+ 账户中……"
T[E36]="The upgrade failed, WARP+ account error or more than 5 devices have been activated. Free WARP account to continu."
T[C36]="升级失败，WARP+ 账户错误或者已激活超过5台设备，自动更换免费 WARP 账户继续"
T[E37]="Checking VPS infomation..."
T[C37]="检查环境中……"
T[E38]="Create shortcut [warp] successfully"
T[C38]="创建快捷 warp 指令成功"
T[E39]="Running WARP"
T[C39]="运行 WARP"
T[E40]=""
T[C40]=""
T[E41]="Congratulations! WARP\$TYPE is turned on. Spend time:\$(( end - start )) seconds.\\\n The script runs today: \$TODAY. Total:\$TOTAL"
T[C41]="恭喜！WARP\$TYPE 已开启，总耗时:\$(( end - start ))秒， 脚本当天运行次数:\$TODAY，累计运行次数：\$TOTAL"
T[E42]="Congratulations! WARP is turned on. Spend time:\$(( end - start )) seconds.\\\n The script runs on today: \$TODAY. Total:\$TOTAL"
T[C42]="恭喜！WARP 已开启，总耗时:\$(( end - start ))秒， 脚本当天运行次数:\$TODAY，累计运行次数：\$TOTAL"
T[E43]="Turn on WGCF: [docker exec -it wgcf sh] and [wg-quick up wgcf; exit]. Turn off WGCF: [docker exec -it wgcf sh] and [wg-quick down wgcf; exit]"
T[C43]="运行 WGCF: [docker exec -it wgcf sh], 然后 [wg-quick up wgcf; exit]; 关闭 WGCF:[docker exec -it wgcf sh], 然后 [wg-quick down wgcf; exit]"
T[E44]="WARP installation failed. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C44]="WARP 安装失败，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E45]="WARP docker have been completely deleted!"
T[C45]="WARP docker 已彻底删除!"
T[E46]=""
T[C46]=""
T[E47]=""
T[C47]=""
T[E48]=""
T[C48]=""
T[E49]=""
T[C49]=""
T[E50]="Choose:"
T[C50]="请选择:"
T[E51]="Please enter the correct number"
T[C51]="请输入正确数字"
T[E52]=""
T[C52]=""
T[E53]=""
T[C53]=""
T[E54]=""
T[C54]=""
T[E55]=""
T[C55]=""
T[E56]=""
T[C56]=""
T[E57]=""
T[C57]=""
T[E58]="WARP+ or Teams account is working now. No need to upgrade."
T[C58]="已经是 WARP+ 或者 Teams 账户，不需要升级"
T[E59]="Cannot find the account file: /etc/wireguard/wgcf-account.toml, you can reinstall with the WARP+ License"
T[C59]="找不到账户文件：/etc/wireguard/wgcf-account.toml，可以卸载后重装，输入 WARP+ License"
T[E60]="Cannot find the configuration file: /etc/wireguard/wgcf.conf, you can reinstall with the WARP+ License"
T[C60]="找不到配置文件： /etc/wireguard/wgcf.conf，可以卸载后重装，输入 WARP+ License"
T[E61]="Please Input WARP+ license:"
T[C61]="请输入WARP+ License:"
T[E62]="Successfully upgraded to a WARP+ account"
T[C62]="已升级为 WARP+ 账户"
T[E63]="WARP+ quota"
T[C63]="剩余流量"
T[E64]="Successfully synchronized the latest version"
T[C64]="成功！已同步最新脚本，版本号"
T[E65]="Upgrade failed. Feedback:[https://github.com/fscarmen/warp/issues]"
T[C65]="升级失败，问题反馈:[https://github.com/fscarmen/warp/issues]"
T[E66]="Add WARP IPv4 interface to IPv6 only VPS"
T[C66]="为 IPv6 only 添加 IPv4 网络接口"
T[E67]="Add WARP IPv6 interface to IPv4 only VPS"
T[C67]="为 IPv4 only 添加 IPv6 网络接口"
T[E68]="Add WARP dualstack interface to IPv6 only VPS"
T[C68]="为 IPv6 only 添加双栈网络接口"
T[E69]="Add WARP dualstack interface to IPv4 only VPS"
T[C69]="为 IPv4 only 添加双栈网络接口"
T[E70]="Add WARP IPv6 interface to native dualstack"
T[C70]="为 原生双栈 添加 WARP IPv6 网络接口"
T[E71]="Turn on WARP"
T[C71]="打开 WARP"
T[E72]="Turn off, uninstall WARP docker"
T[C72]="永久关闭 WARP 网络接口，并删除 WARP docker"
T[E73]=""
T[C73]=""
T[E74]=""
T[C74]=""
T[E75]="Sync the latest version"
T[C75]="同步最新版本"
T[E76]="Exit"
T[C76]="退出脚本"
T[E77]="Turn off WARP"
T[C77]="暂时关闭 WARP"
T[E78]="Upgrade to WARP+ or Teams account"
T[C78]="升级为 WARP+ 或 Teams 账户"
T[E79]=""
T[C79]=""
T[E80]=""
T[C80]=""
T[E81]="Step 3/3: Searching for the best MTU value is ready."
T[C81]="进度 3/3：寻找 MTU 最优值已完成"
T[E82]=""
T[C82]=""
T[E83]=""
T[C83]=""
T[E84]=""
T[C84]=""
T[E85]=""
T[C85]=""
T[E86]=""
T[C86]=""
T[E87]=""
T[C87]=""
T[E88]=""
T[C88]=""
T[E89]=""
T[C89]=""
T[E90]=""
T[C90]=""
T[E91]=""
T[C91]=""
T[E92]=""
T[C92]=""
T[E93]=""
T[C93]=""
T[E94]=""
T[C94]=""
T[E95]=""
T[C95]=""
T[E96]=""
T[C96]=""
T[E97]="It is a WARP+ account already. Update is aborted."
T[C97]="已经是 WARP+ 账户，不需要升级"
T[E98]=""
T[C98]=""
T[E99]=""
T[C99]=""
T[E100]="License should be 26 characters, please re-enter WARP+ License. Otherwise press Enter to continue. \(\$i times remaining\): "
T[C100]="License 应为26位字符,请重新输入 WARP+ License \(剩余\$i次\): "
T[E101]=""
T[C101]=""
T[E102]="Please customize the WARP+ device name (Default is [WARP] if left blank):"
T[C102]="请自定义 WARP+ 设备名 (如果不输入，默认为 [WARP]):"
T[E103]=""
T[C103]=""
T[E104]=""
T[C104]=""
T[E105]="\n Please choose the priority:\n  1.IPv4 (default)\n  2.IPv6\n  3.Use initial settings\n"
T[C105]="\n 请选择优先级别:\n  1.IPv4 (默认)\n  2.IPv6\n  3.使用 VPS 初始设置\n"
T[E106]="IPv6 priority"
T[C106]="IPv6 优先"
T[E107]="IPv4 priority"
T[C107]="IPv4 优先"
T[E108]=""
T[C108]=""
T[E109]=""
T[C109]=""
T[E110]=""
T[C110]=""
T[E111]=""
T[C111]=""
T[E112]=""
T[C112]=""
T[E113]=""
T[C113]=""
T[E114]="WARP\$TYPE Interface is on"
T[C114]="WARP\$TYPE 网络接口已开启"
T[E115]="WARP Interface is on"
T[C115]="WARP 网络接口已开启"
T[E116]="WARP Interface is off"
T[C116]="WARP 网络接口未开启"
T[E117]="Uninstall WARP Interface was complete."
T[C117]="WARP 网络接口卸载成功"
T[E118]="Uninstall WARP Interface was fail."
T[C118]="WARP 网络接口卸载失败"
T[E119]=""
T[C119]=""
T[E120]=""
T[C120]=""
T[E121]=""
T[C121]=""
T[E122]=""
T[C122]=""
T[E123]=""
T[C123]=""
T[E124]=""
T[C124]=""
T[E125]=""
T[C125]=""
T[E126]=""
T[C126]=""
T[E127]="Please input Teams file URL (To use the one provided by the script if left blank):" 
T[C127]="请输入 Teams 文件 URL (如果留空，则使用脚本提供的):"
T[E128]="Successfully upgraded to a WARP Teams account"
T[C128]="已升级为 WARP Teams 账户"
T[E129]="The current Teams account is unavailable, automatically switch back to the free account"
T[C129]="当前 Teams 账户不可用，自动切换回免费账户"
T[E130]="\\\n Please confirm\\\n Private key : \$PRIVATEKEY\\\n Public key : \$PUBLICKEY\\\n Address IPv4 : \$ADDRESS4/32\\\n Address IPv6 : \$ADDRESS6/128\\\n"
T[C130]="\\\n 请确认Teams 信息\\\n Private key : \$PRIVATEKEY\\\n Public key : \$PUBLICKEY\\\n Address IPv4 : \$ADDRESS4/32\\\n Address IPv6 : \$ADDRESS6/128\\\n"
T[E131]="comfirm please enter [y] , and other keys to use free account:"
T[C131]="确认请按 y ，其他按键则使用免费账户:"
T[E132]="\n Is there a WARP+ or Teams account?\n 1. WARP+\n 2. Teams\n 3. use free account (default)\n"
T[C132]="\n 如有 WARP+ 或 Teams 账户请选择\n 1. WARP+\n 2. Teams\n 3. 使用免费账户 (默认)\n"
T[E133]="Device name：\$(grep -s 'Device name' /etc/wireguard/info.log | awk '{ print \$NF }')\\\n Quota：\$(grep -s Quota /etc/wireguard/info.log | awk '{ print \$(NF-1), \$NF }')"
T[C133]="设备名:\$(grep -s 'Device name' /etc/wireguard/info.log | awk '{ print \$NF }')\\\n 剩余流量:\$(grep -s Quota /etc/wireguard/info.log | awk '{ print \$(NF-1), \$NF }')"
T[E134]="Curren architecture \$(arch) is not supported. Feedback: [https://github.com/fscarmen/warp/issues]"
T[C134]="当前架构 \$(arch) 暂不支持,问题反馈:[https://github.com/fscarmen/warp/issues]"

# 脚本当天及累计运行次数统计
COUNT=$(curl -sm1 "https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2Ffscarmen%2Fwarp%2Fdocker.sh&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=&edge_flat=true" 2>&1) &&
TODAY=$(expr "$COUNT" : '.*\s\([0-9]\{1,\}\)\s/.*') && TOTAL=$(expr "$COUNT" : '.*/\s\([0-9]\{1,\}\)\s.*')
	
# 选择语言，先判断 /etc/wireguard/language 里的语言选择，没有的话再让用户选择，默认英语
case $(cat /etc/wireguard/language-docker 2>&1) in
E ) L=E;;	C ) L=C;;
* ) L=E && [[ -z $OPTION || $OPTION = [hdv1] ]] && yellow " ${T[${L}0]} " && reading " ${T[${L}50]} " LANGUAGE 
[[ $LANGUAGE = 2 ]] && L=C;;
esac

# 多方式判断操作系统，试到有值为止。只支持 Debian 10/11、Ubuntu 18.04/20.04 或 CentOS 7/8 ,如非上述操作系统，退出脚本
# 感谢猫大的技术指导优化重复的命令。https://github.com/Oreomeow
CMD=(	"$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
	"$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
	"$(lsb_release -sd 2>/dev/null)"
	"$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
	"$(grep . /etc/redhat-release 2>/dev/null)"
	"$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
	)

for i in "${CMD[@]}"; do
	SYS="$i" && [[ -n $SYS ]] && break
done

# 自定义 Alpine 系统若干函数
alpine_wgcf_restart(){ wg-quick down wgcf >/dev/null 2>&1; wg-quick up wgcf >/dev/null 2>&1; }
alpine_wgcf_enable(){ echo 'nohup wg-quick up wgcf &' > /etc/local.d/wgcf.start; chmod +x /etc/local.d/wgcf.start; rc-update add local; }

REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'" "alpine")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Alpine")
PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "apk update -f")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "apk add -f")
PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "yum -y autoremove" "apk del -f")

for ((int=0; int<${#REGEX[@]}; int++)); do
	[[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && COMPANY="${COMPANY[int]}" && [[ -n $SYSTEM ]] && break
done
[[ -z $SYSTEM ]] && red " ${T[${L}5]} " && exit 1

[[ $SYSTEM = Alpine ]] && ! type -P curl >/dev/null 2>&1 && ${PACKAGE_UPDATE[int]} && ${PACKAGE_INSTALL[int]} curl wget grep

# 检测 IPv4 IPv6 信息，WARP Ineterface 开启，普通还是 Plus账户 和 IP 信息
ip4_info(){
	IP4=$(curl -s4m8 https://ip.gs/json)
	LAN4=$(ip route get 162.159.192.1 2>/dev/null | grep -oP 'src \K\S+')
	WAN4=$(expr "$IP4" : '.*ip\":\"\([^"]*\).*')
	COUNTRY4=$(expr "$IP4" : '.*country\":\"\([^"]*\).*')
	ASNORG4=$(expr "$IP4" : '.*asn_org\":\"\([^"]*\).*')
	TRACE4=$(curl -s4m8 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g")
	if [[ $TRACE4 = plus ]]; then 
	grep -sq 'Device name' /etc/wireguard/info.log && PLUS4='+' || PLUS4=' Teams'
	fi
	[[ $TRACE4 = on || $TRACE4 = plus ]] && WARPSTATUS4="( WARP$PLUS4 IPv4 )"
	}

ip6_info(){
	IP6=$(curl -s6m8 https://ip.gs/json)
	LAN6=$(ip route get 2606:4700:d0::a29f:c001 2>/dev/null | grep -oP 'src \K\S+')
	WAN6=$(expr "$IP6" : '.*ip\":\"\([^"]*\).*')
	COUNTRY6=$(expr "$IP6" : '.*country\":\"\([^"]*\).*')
	ASNORG6=$(expr "$IP6" : '.*asn_org\":\"\([^"]*\).*')
	TRACE6=$(curl -s6m8 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g")
	if [[ $TRACE6 = plus ]]; then 
	grep -sq 'Device name' /etc/wireguard/info.log && PLUS6='+' || PLUS6=' Teams'
	fi
	[[ $TRACE6 = on || $TRACE6 = plus ]] && WARPSTATUS6="( WARP$PLUS6 IPv6 )"
	}

green " ${T[${L}37]} "

# 必须以root运行脚本
[[ $(id -u) != 0 ]] && red " ${T[${L}2]} " && exit 1

# 判断虚拟化
VIRT=$(systemd-detect-virt 2>/dev/null | tr '[:upper:]' '[:lower:]')
[[ -n $VIRT ]] || VIRT=$(hostnamectl 2>/dev/null | tr '[:upper:]' '[:lower:]' | grep virtualization | sed "s/.*://g")

# 必须加载 TUN 模块
TUN=$(cat /dev/net/tun 2>&1 | tr '[:upper:]' '[:lower:]')
[[ ! $TUN =~ 'in bad state' ]] && [[ ! $TUN =~ '处于错误状态' ]] && red " ${T[${L}3]} " && exit 1

help(){	yellow " ${T[${L}6]} "; }

# WGCF docker 卸载
uninstall(){
	unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6
	docker exec -it wgcf wg-quick down wgcf
	
	# 停止及删除容器
	docker stop wgcf
	docker rm wgcf
	
	# 删除镜像
	docker rmi -f $(docker images | grep wgcf | awk '{print $3}')
	
	# 删除文件
	rm -rf /usr/local/bin/wgcf /etc/wireguard wgcf-account.toml wgcf-profile.conf /usr/bin/warp

	# 显示卸载结果
	ip4_info; [[ $L = C && -n "$COUNTRY4" ]] && COUNTRY4=$(translate "$COUNTRY4")
	ip6_info; [[ $L = C && -n "$COUNTRY6" ]] && COUNTRY6=$(translate "$COUNTRY6")
	green " ${T[${L}45]}\n IPv4：$WAN4 $COUNTRY4 $ASNORG4\n IPv6：$WAN6 $COUNTRY6 $ASNORG6 "
	}

# 同步脚本至最新版本
ver(){
	wget -N -P /etc/wireguard https://raw.githubusercontent.com/fscarmen/warp/main/docker.sh || wget -N -P /etc/wireguard https://cdn.jsdelivr.net/gh/fscarmen/warp/docker.sh
	chmod +x /etc/wireguard/docker.sh
	ln -sf /etc/wireguard/docker.sh /usr/bin/warp
	green " ${T[${L}64]}:$(grep ^VERSION /etc/wireguard/docker.sh | sed "s/.*=//g")  ${T[${L}18]}：$(grep "T\[${L}1]" /etc/wireguard/docker.sh | cut -d \" -f2) " || red " ${T[${L}65]} "
	exit
	}

# WARP 开关
onoff(){
	if [[ -n $(docker exec -it wgcf wg 2>/dev/null) ]]; then
	docker exec -it wgcf wg-quick down wgcf >/dev/null 2>&1; green " ${T[${L}15]} "
	else 
	docker exec -it wgcf wg-quick up wgcf >/dev/null 2>&1
	ip4_info; ip6_info
	green " ${T[${L}14]} "
	[[ $L = C ]] && COUNTRY4=$(translate "$COUNTRY4")
	[[ $L = C ]] && COUNTRY6=$(translate "$COUNTRY6")
	green " IPv4:$WAN4 $WARPSTATUS4 $COUNTRY4 $ASNORG4\n IPv6:$WAN6 $WARPSTATUS6 $COUNTRY6 $ASNORG6 "
	fi
	}

# 设置部分后缀 1/2
case "$OPTION" in
h ) help; exit 0;;
u ) uninstall; exit 0;;
v ) ver; exit 0;;
o ) onoff; exit 0;;
esac

# 判断是否大陆 VPS。先尝试连接 CloudFlare WARP 服务的 Endpoint IP，如遇到 WARP 断网则先关闭、杀进程后重试一次，仍然不通则 WARP 项目不可用。
ping6 -c2 -w8 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && CDN=-6 || IPV6=0
ping -c2 -W8 162.159.192.1 >/dev/null 2>&1 && IPV4=1 && CDN=-4 || IPV4=0
if [[ $IPV4$IPV6 = 00 && -n $(wg) ]]; then
	wg-quick down wgcf >/dev/null 2>&1
	kill -9 $(pgrep -f wireguard 2>/dev/null)
	ping6 -c2 -w10 2606:4700:d0::a29f:c001 >/dev/null 2>&1 && IPV6=1 && CDN=-6
	ping -c2 -W10 162.159.192.1 >/dev/null 2>&1 && IPV4=1 && CDN=-4
fi
[[ $IPV4$IPV6 = 00 ]] && red " ${T[${L}4]} " && exit 1

# 安装 curl
type -P curl >/dev/null 2>&1 || (yellow " ${T[${L}7]} " && ${PACKAGE_INSTALL[int]} curl) || (yellow " ${T[${L}8]} " && ${PACKAGE_UPDATE[int]} && ${PACKAGE_INSTALL[int]} curl)
! type -P curl >/dev/null 2>&1 && yellow " ${T[${L}9]} " && exit 1

# 判断处理器架构
case $(tr '[:upper:]' '[:lower:]' <<< "$(arch)") in
aarch64 ) ARCHITECTURE=arm64;;	x86_64 ) ARCHITECTURE=amd64;;	s390x ) ARCHITECTURE=s390x && S390X='-s390x';;	* ) red " $(eval echo "${T[${L}134]}") " && exit 1;;
esac

# 判断当前 IPv4 与 IPv6 ，IP归属 及 WARP, Linux Client 是否开启
[[ $IPV4 = 1 ]] && ip4_info
[[ $IPV6 = 1 ]] && ip6_info

# 判断当前 WARP 状态，决定变量 PLAN，变量 PLAN 含义：1=单栈  2=双栈  3=WARP已开启
[[ $TRACE4 = plus || $TRACE4 = on || $TRACE6 = plus || $TRACE6 = on ]] && PLAN=3 || PLAN=$((IPV4+IPV6))

# WGCF 配置修改，其中用到的 162.159.192.1 和 2606:4700:d0::a29f:c001 均是 engage.cloudflareclient.com 的IP
MODIFYS01='sed -i "s/1.1.1.1/2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844,1.1.1.1,8.8.8.8,8.8.4.4/g;/\:\:\/0/d;s/engage.cloudflareclient.com/[2606:4700:d0::a29f:c001]/g" wgcf-profile.conf'
MODIFYD01='sed -i "s/1.1.1.1/2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844,1.1.1.1,8.8.8.8,8.8.4.4/g;7 s/^/PostDown = ip -6 rule delete from '$LAN6' lookup main\n/;7 s/^/PostUp = ip -6 rule add from '$LAN6' lookup main\n/;s/engage.cloudflareclient.com/[2606:4700:d0::a29f:c001]/g" wgcf-profile.conf'
MODIFYS10='sed -i "s/1.1.1.1/1.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;/0\.\0\/0/d;s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf'
MODIFYD10='sed -i "s/1.1.1.1/1.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostDown = ip -4 rule delete from '$LAN4' lookup main\n/;7 s/^/PostUp = ip -4 rule add from '$LAN4' lookup main\n/;s/engage.cloudflareclient.com/162.159.192.1/g" wgcf-profile.conf'
MODIFYD11='sed -i "s/1.1.1.1/1.1.1.1,8.8.8.8,8.8.4.4,2606:4700:4700::1111,2001:4860:4860::8888,2001:4860:4860::8844/g;7 s/^/PostDown = ip -6 rule delete from '$LAN6' lookup main\n/;7 s/^/PostUp = ip -6 rule add from '$LAN6' lookup main\n/;7 s/^/PostDown = ip -4 rule delete from '$LAN4' lookup main\n/;7 s/^/PostUp = ip -4 rule add from '$LAN4' lookup main\n/" wgcf-profile.conf'

# 替换为 Teams 账户信息
teams_change(){
	sed -i "s#PrivateKey.*#PrivateKey = $PRIVATEKEY#g;s#Address.*32#Address = ${ADDRESS4}/32#g;s#Address.*128#Address = ${ADDRESS6}/128#g;s#PublicKey.*#PublicKey = $PUBLICKEY#g" /etc/wireguard/wgcf.conf
		case $IPV4$IPV6 in
			01 ) sed -i "s#Endpoint.*#Endpoint = $(expr "$TEAMS" : '.*v6&quot;:&quot;\(\[[^&]*\).*')#g" /etc/wireguard/wgcf.conf;;
			10 ) sed -i "s#Endpoint.*#Endpoint = $(expr "$TEAMS" : '.*endpoint&quot;:{&quot;v4&quot;:&quot;\([^&]*\).*')#g" /etc/wireguard/wgcf.conf;;	
		esac
	}
	
# 输入 WARP+ 账户（如有），限制位数为空或者26位以防输入错误
input_license(){
	[[ -z $LICENSE ]] && reading " ${T[${L}28]} " LICENSE
	i=5
	until [[ -z $LICENSE || $LICENSE =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]
		do	(( i-- )) || true
			[[ $i = 0 ]] && red " ${T[${L}29]} " && exit 1 || reading " $(eval echo "${T[${L}30]}") " LICENSE
		done
	if [[ $INPUT_LICENSE = 1 ]]; then
		[[ -n $LICENSE && -z $NAME ]] && reading " ${T[${L}102]} " NAME
		[[ -n $NAME ]] && NAME="${NAME//[[:space:]]/_}" || NAME=${NAME:-'WARP'}
	fi
	}

# 输入 Teams 账户 URL（如有）
input_url(){
	[[ -z $URL ]] && reading " ${T[${L}127]} " URL
	URL=${URL:-'https://gist.githubusercontent.com/fscarmen/56aaf02d743551737c9973b8be7a3496/raw/16cf34edf5fb28be00f53bb1c510e95a35491032/com.cloudflare.onedotonedotonedotone_preferences.xml'}
	TEAMS=$(curl -sSL "$URL")
	PRIVATEKEY=$(expr "$TEAMS" : '.*private_key..\([^<]*\).*')
	PUBLICKEY=$(expr "$TEAMS" : '.*public_key&quot;:&quot;\([^&]*\).*')
	ADDRESS4=$(expr "$TEAMS" : '.*v4&quot;:&quot;\(172[^&]*\).*')
	ADDRESS6=$(expr "$TEAMS" : '.*v6&quot;:&quot;\([^[&]*\).*')
	yellow " $(eval echo "${T[${L}130]}") " && reading " ${T[${L}131]} " CONFIRM
	}

# 升级 WARP+ 账户（如有），限制位数为空或者26位以防输入错误，WARP interface 可以自定义设备名(不允许字符串间有空格，如遇到将会以_代替)
update_license(){
	[[ -z $LICENSE ]] && reading " ${T[${L}61]} " LICENSE
	i=5
	until [[ $LICENSE =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]
		do	(( i-- )) || true
			[[ $i = 0 ]] && red " ${T[${L}29]} " && exit 1 || reading " $(eval echo "${T[${L}100]}") " LICENSE
	       done
	[[ $UPDATE_LICENSE = 1 && -n $LICENSE && -z $NAME ]] && reading " ${T[${L}102]} " NAME
	[[ -n $NAME ]] && NAME="${NAME//[[:space:]]/_}" || NAME=${NAME:-'WARP'}
}

# IPv4, IPv6 优先
stack_priority(){
	[[ -e /etc/gai.conf ]] && sed -i '/^precedence \:\:ffff\:0\:0/d;/^label 2002\:\:\/16/d' /etc/gai.conf
	case "$PRIORITY" in
		2 )	echo "label 2002::/16   2" >> /etc/gai.conf;;
		3 )	;;
		* )	echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf;;
	esac
}

# 免费 WARP 账户升级 WARP+ 账户
update(){
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && red " ${T[${L}58]} " && exit 1
	[[ ! -e /etc/wireguard/wgcf-account.toml ]] && red " ${T[${L}59]} " && exit 1
	[[ ! -e /etc/wireguard/wgcf.conf ]] && red " ${T[${L}60]} " && exit 1
	
	[[ -z $LICENSETYPE ]] && yellow " ${T[${L}31]}" && reading " ${T[${L}50]} " LICENSETYPE
	case $LICENSETYPE in
	1 ) UPDATE_LICENSE=1 && update_license
	cd /etc/wireguard || exit
	sed -i "s#license_key.*#license_key = \"$LICENSE\"#g" wgcf-account.toml &&
	if wgcf update --name "$NAME" > /etc/wireguard/info.log 2>&1; then
	wgcf generate >/dev/null 2>&1
	sed -i "2s#.*#$(sed -ne 2p wgcf-profile.conf)#;3s#.*#$(sed -ne 3p wgcf-profile.conf)#;4s#.*#$(sed -ne 4p wgcf-profile.conf)#" wgcf.conf
	docker exec -it wgcf wg-quick down wgcf; docker exec -it wgcf wg-quick up wgcf
	green " ${T[${L}62]}\n ${T[${L}25]}：$(grep 'Device name' /etc/wireguard/info.log | awk '{ print $NF }')\n ${T[${L}63]}：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')"
	else red " ${T[${L}36]} "
	fi;;
	2 ) input_url
	[[ $CONFIRM = [Yy] ]] && (echo "$TEAMS" > /etc/wireguard/info.log 2>&1
	teams_change
	docker exec -it wgcf wg-quick down wgcf; docker exec -it wgcf wg-quick up wgcf
	[[ $(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g") = plus || $(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g") = plus ]] && green " ${T[${L}128]} ");;
	* ) red " ${T[${L}51]} [1-2] "; sleep 1; update;;
	esac
	}

# WGCF docker 安装
install(){
	# 先删除之前安装，可能导致失败的文件
	rm -rf /usr/local/bin/wgcf /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf
	
	# 询问是否有 WARP+ 或 Teams 账户
	[[ -z $LICENSETYPE ]] && yellow " ${T[${L}132]}" && reading " ${T[${L}50]} " LICENSETYPE
	case $LICENSETYPE in
	1 ) INPUT_LICENSE=1 && input_license;;	
	2 ) input_url;;
	esac

	# 选择优先使用 IPv4 /IPv6 网络
	yellow " ${T[${L}105]} " && reading " ${T[${L}50]} " PRIORITY
	
	# 脚本开始时间
	start=$(date +%s)
			
	# 安装 docker, 拉取镜像+创建容器
	{ green " \n${T[${L}32]}\n " && ! systemctl is-active docker >/dev/null 2>&1 && curl -sSL get.docker.com | sh

	docker run -dit --restart=always --network=host --name wgcf --device /dev/net/tun --privileged --cap-add net_admin --cap-add sys_module  -v /etc/wireguard:/etc/wireguard -v /lib/modules:/lib/modules fscarmen/wgcf:1.0
	}&
	
	# 注册 WARP 账户 (将生成 wgcf-account.toml 文件保存账户信息)
	# 判断 wgcf 的最新版本,如因 github 接口问题未能获取，默认 v2.2.11
	{	
	latest=$(wget --no-check-certificate -qO- -T1 -t1 $CDN "https://api.github.com/repos/ViRb3/wgcf/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g')
	latest=${latest:-'2.2.11'}

	# 安装 wgcf，尽量下载官方的最新版本，如官方 wgcf 下载不成功，将使用 jsDelivr 的 CDN，以更好的支持双栈。并添加执行权限
	wget --no-check-certificate -T1 -t1 $CDN -O /usr/local/bin/wgcf https://github.com/ViRb3/wgcf/releases/download/v"$latest"/wgcf_"$latest"_linux_$ARCHITECTURE ||
	wget --no-check-certificate $CDN -O /usr/local/bin/wgcf https://cdn.jsdelivr.net/gh/fscarmen/warp/wgcf_"$latest"_linux_$ARCHITECTURE
	chmod +x /usr/local/bin/wgcf
	
	# 注册 WARP 账户 (将生成 wgcf-account.toml 文件保存账户信息)
	until [[ -e wgcf-account.toml ]] >/dev/null 2>&1; do
	   wgcf register --accept-tos >/dev/null 2>&1 && break
	done

	# 如有 WARP+ 账户，修改 license 并升级，并把设备名等信息保存到 /etc/wireguard/info.log
	mkdir -p /etc/wireguard/ >/dev/null 2>&1
	[[ -n $LICENSE ]] && yellow " \n${T[${L}35]}\n " && sed -i "s/license_key.*/license_key = \"$LICENSE\"/g" wgcf-account.toml &&
	( wgcf update --name "$NAME" > /etc/wireguard/info.log 2>&1 && 
	green " ${T[${L}62]}\n ${T[${L}25]}：$(grep 'Device name' /etc/wireguard/info.log | awk '{ print $NF }')\n ${T[${L}63]}：$(grep Quota /etc/wireguard/info.log | awk '{ print $(NF-1), $NF }')" || red " ${T[${L}36]} " )

	# 生成 Wire-Guard 配置文件 (wgcf-profile.conf)
	wgcf generate >/dev/null 2>&1
	green "\n ${T[${L}33]}\n "

	# 反复测试最佳 MTU。 Wireguard Header：IPv4=60 bytes,IPv6=80 bytes，1280 ≤1 MTU ≤ 1420。 ping = 8(ICMP回显示请求和回显应答报文格式长度) + 20(IP首部) 。
	# 详细说明：<[WireGuard] Header / MTU sizes for Wireguard>：https://lists.zx2c4.com/pipermail/wireguard/2017-December/002201.html
	MTU=$((1500-28))
	[[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	until [[ $? = 0 || $MTU -le $((1280+80-28)) ]]
	do
	MTU=$((MTU-10))
	[[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1
	done

	if [[ $MTU -eq $((1500-28)) ]]; then MTU=$MTU
	elif [[ $MTU -le $((1280+80-28)) ]]; then MTU=$((1280+80-28))
	else
		for ((i=0; i<9; i++)); do
		(( MTU++ ))
		( [[ $IPV4$IPV6 = 01 ]] && ping6 -c1 -W1 -s $MTU -Mdo 2606:4700:d0::a29f:c001 >/dev/null 2>&1 || ping -c1 -W1 -s $MTU -Mdo 162.159.192.1 >/dev/null 2>&1 ) || break
		done
		(( MTU-- ))
	fi

	MTU=$((MTU+28-80))

	[[ -e wgcf-profile.conf ]] && sed -i "s/MTU.*/MTU = $MTU/g" wgcf-profile.conf && green "\n ${T[${L}81]}\n "
	}&

	# 优先使用 IPv4 /IPv6 网络
	{ stack_priority; }&

	# 对于 IPv4 only VPS 开启 IPv6 支持
	# 感谢 P3terx 大神项目这块的技术指导。项目:https://github.com/P3TERX/warp.sh/blob/main/warp.sh
    	{
	[[ $IPV4$IPV6 = 10 ]] && [[ $(sysctl -a 2>/dev/null | grep 'disable_ipv6.*=.*1') || $(grep -s "disable_ipv6.*=.*1" /etc/sysctl.{conf,d/*} ) ]] &&
	(sed -i '/disable_ipv6/d' /etc/sysctl.{conf,d/*}
        echo 'net.ipv6.conf.all.disable_ipv6 = 0' >/etc/sysctl.d/ipv6.conf
        sysctl -w net.ipv6.conf.all.disable_ipv6=0)
	}&

        # 优先使用 IPv4 /IPv6 网络
	{ stack_priority; }&
	
	wait

	echo "$MODIFY" | sh
	
	# 把 wgcf-profile.conf 复制到/etc/wireguard/ 并命名为 wgcf.conf, 如有 Teams，改为 Teams 账户信息
	cp -f wgcf-profile.conf /etc/wireguard/wgcf.conf >/dev/null 2>&1

	# 保存好配置文件
	mv -f wgcf-account.toml wgcf-profile.conf docker.sh /etc/wireguard >/dev/null 2>&1
	
	# 创建再次执行的软链接快捷方式，再次运行可以用 warp 指令,设置默认语言
	chmod +x /etc/wireguard/docker.sh >/dev/null 2>&1
	ln -sf /etc/wireguard/docker.sh /usr/bin/warp && green " ${T[${L}38]} "
	echo "$L" >/etc/wireguard/language-docker
	
	[[ $CONFIRM = [Yy] ]] && teams_change && echo "$TEAMS" > /etc/wireguard/info.log 2>&1
	
	# 运行 WGCF
	unset IP4 IP6 WAN4 WAN6 COUNTRY4 COUNTRY6 ASNORG4 ASNORG6 TRACE4 TRACE6 PLUS4 PLUS6 WARPSTATUS4 WARPSTATUS6
	docker exec -it wgcf wg-quick up wgcf

	# 结果提示，脚本运行时间，次数统计
	[[ $(curl -sm8 https://ip.gs) = "$WAN6" ]] && PRIORITY=${T[${L}106]} || PRIORITY=${T[${L}107]}
	ip4_info; [[ $L = C && -n "$COUNTRY4" ]] && COUNTRY4=$(translate "$COUNTRY4")
	ip6_info; [[ $L = C && -n "$COUNTRY6" ]] && COUNTRY6=$(translate "$COUNTRY6")
	end=$(date +%s)
	red "\n==============================================================\n"
	green " IPv4：$WAN4 $WARPSTATUS4 $COUNTRY4  $ASNORG4 "
	green " IPv6：$WAN6 $WARPSTATUS6 $COUNTRY6  $ASNORG6 "
	grep -sq 'Device name' /etc/wireguard/info.log 2>/dev/null && TYPE='+' || TYPE=' Teams'
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green " $(eval echo "${T[${L}41]}") " && grep -sq 'Device name' /etc/wireguard/info.log && green " $(eval echo "${T[${L}133]}") "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green " $(eval echo "${T[${L}42]}") "
	green " $PRIORITY "
	red "\n==============================================================\n"
	}

# 显示菜单
menu(){
	if [[ $PLAN != 3 ]]; then
		case $IPV4$IPV6 in
		01 ) OPTION1=${T[${L}66]} && OPTION2=${T[${L}71]};;
		10 ) OPTION1=${T[${L}67]} && OPTION2=${T[${L}71]};;
		11 ) OPTION1=${T[${L}70]} && OPTION2=${T[${L}71]};;
		esac
	else OPTION1=${T[${L}77]} && OPTION2=${T[${L}78]}
	fi
	grep -sq 'Device name' /etc/wireguard/info.log 2>/dev/null && TYPE='+' && PLUSINFO="${T[${L}25]}：$(grep 'Device name' /etc/wireguard/info.log 2>/dev/null | awk '{ print $NF }')" || TYPE=' Teams'
	
	clear
	yellow " ${T[${L}16]} "
	red "======================================================================================================================\n"
	green " ${T[${L}17]}：$VERSION  ${T[${L}18]}：${T[${L}1]}\n ${T[${L}19]}：\n	${T[${L}20]}：$SYS\n	${T[${L}21]}：$(uname -r)\n	${T[${L}22]}：$ARCHITECTURE\n	${T[${L}23]}：$VIRT "
	green "	IPv4：$WAN4 $WARPSTATUS4 $COUNTRY4  $ASNORG4 "
	green "	IPv6：$WAN6 $WARPSTATUS6 $COUNTRY6  $ASNORG6 "
	[[ $TRACE4 = plus || $TRACE6 = plus ]] && green "	$(eval echo "${T[${L}114]}")	$PLUSINFO "
	[[ $TRACE4 = on || $TRACE6 = on ]] && green "	${T[${L}115]} " 	
	[[ $PLAN != 3 ]] && green "	${T[${L}116]} "
 	red "\n======================================================================================================================\n"
	green " 1. $OPTION1\n 2. $OPTION2\n 3. ${T[${L}72]}\n 0. ${T[${L}76]}\n "
	reading " ${T[${L}50]} " CHOOSE1
		case "$CHOOSE1" in
		1 )	[[ $OPTION1 = ${T[${L}66]} || $OPTION1 = ${T[${L}67]} ]] && MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6) && install
			[[ $OPTION1 = ${T[${L}70]} ]] && MODIFY=$MODIFYS10 && install
			[[ $OPTION1 = ${T[${L}77]} ]] && onoff;;	
		2 )	[[ $OPTION2 = ${T[${L}71]} ]] && OPTION=o && onoff
			[[ $OPTION2 = ${T[${L}78]} ]] && update;;
		3 )	uninstall;;
		0 )	exit;;
		* )	red " ${T[${L}51]} [0-3] "; sleep 1; menu;;
		esac
	}

# 设置部分后缀 2/2
case "$OPTION" in
1 ) [[ $IPV4$IPV6 = 11 ]] && MODIFY=$MODIFYS10 || MODIFY=$(eval echo \$MODIFYS$IPV4$IPV6)
    install;;
d ) update;;
* ) menu;;
esac
