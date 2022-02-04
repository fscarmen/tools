#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/bin
export LANG=en_US.UTF-8

# 当前脚本版本号和新增功能
VERSION='1.05'

# 最大支持流媒体，最大支持解锁方法
SUPPORT_NUM='2'
UNLOCK_NUM='3'

# 设置关联数组 T 用于中英文
declare -A T

T[E0]="\n Language:\n  1.English (default) \n  2.简体中文\n"
T[C0]="${T[E0]}"
T[E1]="1. Suppport pass parameter. You can run like this:bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/t.sh) -E -A us -4 -N nd -M 2; 2. Support logs push to Telegram; 3. Support switch unlock modes freely; 4. Log limit is 1000 lines"
T[C1]="支持传参，你可以这样运行脚本: bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/t.sh) -E -A us -4 -N nd -M 2; 2. 把日志输出到 Telegram; 3. 自由地切换解锁模式; 4. 日志限制1000行"
T[E2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/fscarmen/warp_unlock/issues]"
T[C2]="必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/warp_unlock/issues]"
T[E3]="Choose:"
T[C3]="请选择:"
T[E4]="\n Neither the WARP network interface nor Socks5 are installed, please select the installation script:\n 1. fscarmen (Default)\n 2. yyykg\n 3. P3terx\n 0. Exit\n"
T[C4]="\n WARP 网络接口和 Socks5 都没有安装，请选择安装脚本:\n 1. fscarmen (默认)\n 2. yyykg\n 3. P3terx\n 0. 退出\n"
T[E5]="The script supports Debian, Ubuntu, CentOS or Alpine systems only. Feedback: [https://github.com/fscarmen/warp_unlock/issues]"
T[C5]="本脚本只支持 Debian、Ubuntu、CentOS 或 Alpine 系统,问题反馈:[https://github.com/fscarmen/warp_unlock/issues]"
T[E6]="Please choose to brush WARP IP:\n 1. WARP Socks5 Proxy (Default)\n 2. WARP IPv6 Interface\n"
T[C6]="\n 请选择刷 WARP IP 方式:\n 1. WARP Socks5 代理 (默认)\n 2. WARP IPv6 网络接口\n"
T[E7]="Installing \$c..."
T[C7]="安装 \$c 中……"
T[E8]="It is necessary to upgrade the latest package library before install \$c.It will take a little time,please be patiently..."
T[C8]="先升级软件库才能继续安装 \$c，时间较长，请耐心等待……"
T[E9]="Failed to install \$c. The script is aborted. Feedback: [https://github.com/fscarmen/warp_unlock/issues]"
T[C9]="安装 \$c 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp_unlock/issues]"
T[E10]="\n Media unlock daemon installed successfully. The running log of the scheduled task will be saved in /root/result.log\n"
T[C10]="\n 媒体解锁守护进程已安装成功。定时任务运行日志将保存在 /root/result.log\n"
T[E11]="\n The media unlock daemon is completely uninstalled.\n"
T[C11]="\n 媒体解锁守护进程已彻底卸载\n"
T[E12]="\n 1. Mode 1: Check it every 5 minutes.\n 2. Mode 2: Create a screen named [u] and run. The process runs in the background. When the unlock is all successful, it will be checked every 1 hour.\n 3. Mode 3: Create a jobs with nohup to run. The process runs in the background. When the unlock is all successful, it will be checked every 1 hour.\n 0. Exit\n"
T[C12]="\n 1. 模式1: 定时5分钟检查一次,遇到不解锁时更换 WARP IP，直至刷成功\n 2. 模式2: 创建一个名为 [u] 的 Screen 会话。进程一直在后台，当刷成功后，每隔1小时检查一次\n 3. 模式3: 用 nohup 创建一个 jobs。进程一直在后台，当刷成功后，每隔1小时检查一次\n 0. 退出\n"
T[E13]="\\\n The current region is \$REGION. Confirm press [y] . If you want another regions, please enter the two-digit region abbreviation. \(such as hk,sg. Default is \$REGION\):"
T[C13]="\\\n 当前地区是:\$REGION，需要解锁当前地区请按 y , 如需其他地址请输入两位地区简写 \(如 hk,sg，默认:\$REGION\):"
T[E14]="Wrong input."
T[C14]="输入错误"
T[E15]="\n Select the stream media you wanna unlock (Multiple selections are possible, such as 123. The default is select all)\n 1. Netflix\n 2. Disney+\n"
T[C15]="\n 选择你期望解锁的流媒体 (可多选，如 123，默认为全选)\n 1. Netflix\n 2. Disney+\n"
T[E16]="The script Born to make stream media unlock by WARP. Detail:[https://github.com/fscarmen/warp]\n Features:\n	* Support a variety of main stream streaming media detection.\n	* Multiple ways to unlock.\n	* Support WARP Socks5 Proxy to detect and replace IP.\n	* log output\n"
T[C16]="本项目专为 WARP 解锁流媒体而生。详细说明：[https://github.com/fscarmen/warp]\n 脚本特点:\n	* 支持多种主流串流影视检测\n	* 多种方式解锁\n	* 支持 WARP Socks5 Proxy 检测和更换 IP\n	* 日志输出\n"
T[E17]="Version"
T[C17]="脚本版本"
T[E18]="New features"
T[C18]="功能新增"
T[E19]="\\\n Stream media unlock daemon is running in \${UNLOCK_MODE_NOW[f]}.\\\n 1. Change the streame media that needs to be unlocked\\\n 2. Switch to \${UNLOCK_MODE_AFTER1[f]}\\\n 3. Switch to \${UNLOCK_MODE_AFTER2[f]}\\\n 4. Uninstall\\\n 0. Exit\\\n"
T[C19]="\\\n 流媒体解锁守护正在以 \${UNLOCK_MODE_NOW[f]} 运行中\\\n 1. 更换需要解锁的流媒体\\\n 2. 切换至\${UNLOCK_MODE_AFTER1[f]}\\\n 3. 切换至\${UNLOCK_MODE_AFTER2[f]}\\\n 4. 卸载\\\n 0. 退出\\\n"
T[E20]="Media unlock daemon installed successfully. A session window u has been created, enter [screen -Udr u] and close [screen -SX u quit]. The VPS restart will still take effect. The running log of the scheduled task will be saved in /root/result.log\n"
T[C20]="\n 媒体解锁守护进程已安装成功，已创建一个会话窗口 u ，进入 [screen -Udr u]，关闭 [screen -SX u quit]，VPS 重启仍生效。进入任务运行日志将保存在 /root/result.log\n"
T[E21]="Media unlock daemon installed successfully. A jobs has been created, check [pgrep -laf warp_unlock] and close [kill -9 \$(pgrep -f warp_unlock)]. The VPS restart will still take effect. The running log of the scheduled task will be saved in /root/result.log\n"
T[C21]="\n 媒体解锁守护进程已安装成功，已创建一个jobs，查看 [pgrep -laf warp_unlock]，关闭 [kill -9 \$(pgrep -f warp_unlock)]，VPS 重启仍生效。进入任务运行日志将保存在 /root/result.log\n"
T[E22]="The script runs on today: \$TODAY. Total:\$TOTAL\\\n"
T[C22]="脚本当天运行次数:\$TODAY，累计运行次数：\$TOTAL\\\n"
T[E23]="Please choose to brush WARP IP:\n 1. WARP IPv4 Interface (Default)\n 2. WARP IPv6 Interface\n"
T[C23]="\n 请选择刷 WARP IP 方式:\n 1. WARP IPv4 网络接口 (默认)\n 2. WARP IPv6 网络接口\n"
T[E24]="No WARP method specified."
T[C24]="没有指定的 WARP 方式"
T[E25]="No unlock method specified."
T[C25]="没有指定的解锁模式"
T[E26]="Expected region abbreviation should be two digits (eg hk,sg)."
T[C26]="期望地区简码应该为两位 (如 hk,sg)"
T[E27]="No unlock script is installed."
T[C27]="解锁脚本还没有安装"
T[E28]="Unlock script is installed."
T[C28]="解锁脚本已安装"
T[E29]="\\\n Please enter Bot Token if you need push the logs to Telegram. Leave blank to skip:"
T[C29]="\\\n 如需要把日志推送到 Telegram 机器人，请输入 Bot Token，不需要直接回车:"
T[E30]="\\\n Enter USERID:"
T[C30]="\\\n 输入 USERID:"
T[E31]="\\\n Enter custom name:"
T[C31]="\\\n 自定义名称:"
T[E40]="Mode 1: Check it every 5 minutes"
T[C40]="模式1: 定时5分钟检查一次,遇到不解锁时更换 WARP IP，直至刷成功"
T[E41]="Mode 2: Create a screen named [u] and run"
T[C41]="模式2: 创建一个名为 [u] 的 Screen 在后台刷"
T[E42]="Mode 3: Create a jobs with nohup to run in the background"
T[C42]="模式3: 用 nohup 创建一个 jobs 在后台刷"
T[E43]=""
T[C43]=""
T[E44]=""
T[C44]=""
T[E45]=""
T[C45]=""


# 自定义字体彩色，read 函数，友道翻译函数，安装依赖函数
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate(){ [[ -n "$1" ]] && curl -sm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$1" | cut -d \" -f18 2>/dev/null; }
check_dependencies(){ for c in $@; do
type -P $c >/dev/null 2>&1 || (yellow " $(eval echo "${T[${L}7]}") " && ${PACKAGE_INSTALL[b]} "$c") || (yellow " $(eval echo "${T[${L}8]}") " && ${PACKAGE_UPDATE[b]} && ${PACKAGE_INSTALL[b]} "$c")
! type -P $c >/dev/null 2>&1 && yellow " $(eval echo "${T[${L}9]}") " && exit 1; done;	 }

# 脚本当天及累计运行次数统计
statistics_of_run-times(){
COUNT=$(curl -sm1 "https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fraw.githubusercontent.com%2Ffscarmen%2Fwarp_unlock%2Fmain%2Funlock.sh&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false" 2>&1) &&
TODAY=$(expr "$COUNT" : '.*\s\([0-9]\{1,\}\)\s/.*') && TOTAL=$(expr "$COUNT" : '.*/\s\([0-9]\{1,\}\)\s.*')
	}

# 选择语言，先判断 /etc/wireguard/language 里的语言选择，没有的话再让用户选择，默认英语
select_laguage(){
[[ -z "$L" ]] && case $(cat /etc/wireguard/language 2>&1) in
E ) L=E;;	C ) L=C;;
* ) L=E && yellow " ${T[${L}0]} " && reading " ${T[${L}3]} " LANGUAGE 
[[ $LANGUAGE = 2 ]] && L=C;;
esac
}

check_system_info(){
# 多方式判断操作系统，试到有值为止。只支持 Debian 10/11、Ubuntu 18.04/20.04 或 CentOS 7/8 ,如非上述操作系统，退出脚本
CMD=(	"$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
	"$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
	"$(lsb_release -sd 2>/dev/null)"
	"$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
	"$(grep . /etc/redhat-release 2>/dev/null)"
	"$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
	)

for a in "${CMD[@]}"; do
	SYS="$a" && [[ -n $SYS ]] && break
done

REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS")
PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install")

for ((b=0; b<${#REGEX[@]}; b++)); do
	[[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[b]} ]] && SYSTEM="${RELEASE[b]}" && [[ -n $SYSTEM ]] && break
done
[[ -z $SYSTEM ]] && red " ${T[${L}5]} " && exit 1
}

# 检查解锁是否已运行，如果是则判断模式，以前给更换模式赋值
check_unlock_running(){
	switch_1_1(){	true; }	
	switch_1_2(){	TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root screen -USdm u bash /etc/wireguard/warp_unlock.sh\" >> /etc/crontab"
			MODE2=("while true; do" "sleep 1h; done")
			check_dependencies screen
			}
	switch_1_3(){	TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root nohup bash /etc/wireguard/warp_unlock.sh &\" >> /etc/crontab"
			MODE2=("while true; do" "sleep 1h; done")
			}
	switch_2_1(){	TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"*/5 * * * * root bash /etc/wireguard/warp_unlock.sh\" >> /etc/crontab";	}
	switch_2_2(){	MODE2=("while true; do" "sleep 1h; done"); }	
	switch_2_3(){	TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root nohup bash /etc/wireguard/warp_unlock.sh &\" >> /etc/crontab"
			MODE2=("while true; do" "sleep 1h; done")
			}	
	switch_3_1(){	TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"*/5 * * * * root bash /etc/wireguard/warp_unlock.sh\" >> /etc/crontab";	}
	switch_3_2(){	TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root screen -USdm u bash /etc/wireguard/warp_unlock.sh\" >> /etc/crontab"
			MODE2=("while true; do" "sleep 1h; done")
			check_dependencies screen
			}
	switch_3_3(){	MODE2=("while true; do" "sleep 1h; done"); }
	run_1_1(){	kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1; }
	run_1_2(){	kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
			screen -USdm u bash /etc/wireguard/warp_unlock.sh
			}
	run_1_3(){	kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
			nohup bash /etc/wireguard/warp_unlock.sh >/dev/null 2>&1 &
			}
	run_2_1(){	screen -QX u quit >/dev/null 2>&1 && screen -wipe >/dev/null 2>&1; }
	run_2_2(){	screen -QX u quit >/dev/null 2>&1 && screen -wipe >/dev/null 2>&1
			screen -USdm u bash /etc/wireguard/warp_unlock.sh
			}
	run_2_3(){	screen -QX u quit >/dev/null 2>&1 && screen -wipe >/dev/null 2>&1
			nohup bash /etc/wireguard/warp_unlock.sh >/dev/null 2>&1 &
			}
	run_3_1(){	kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1; }
	run_3_2(){	kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
			screen -USdm u bash /etc/wireguard/warp_unlock.sh
			}
	run_3_3(){	kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
			nohup bash /etc/wireguard/warp_unlock.sh >/dev/null 2>&1 &
			}
	EXPECT=$(grep -s "EXPECT=" /etc/wireguard/warp_unlock.sh | cut -d \" -f2)	
	TOKEN=$(grep -s "TOKEN=" /etc/wireguard/warp_unlock.sh | cut -d \" -f2)
	USERID=$(grep -s "USERID=" /etc/wireguard/warp_unlock.sh | cut -d \" -f2)
	CUSTOM=$(grep -s "CUSTOM=" /etc/wireguard/warp_unlock.sh | cut -d \" -f2)
	NIC=$(grep -s "NIC=" /etc/wireguard/warp_unlock.sh | cut -d \" -f2)

	check_crontab=("^\*.*warp_unlock" "screen.*warp_unlock" "nohup.*warp_unlock")
	for ((f=0; f<"$UNLOCK_NUM"; f++)); do
	grep -qE "${check_crontab[f]}" /etc/crontab && break; done
	UNLOCK_MODE_NOW=("${T[${L}40]}" "${T[${L}41]}" "${T[${L}42]}")
	UNLOCK_MODE_AFTER1=("${T[${L}41]}" "${T[${L}40]}" "${T[${L}40]}")
	UNLOCK_MODE_AFTER2=("${T[${L}42]}" "${T[${L}42]}" "${T[${L}41]}")
	SWITCH_MODE1=( "switch_1_1" "switch_2_2" "switch_3_3" )
	SWITCH_MODE2=( "switch_1_2" "switch_2_1" "switch_3_1" )
	SWITCH_MODE3=( "switch_1_3" "switch_2_3" "switch_3_2" )
	RUN_AFTER_SWITCH1=( "run_1_1" "run_2_2" "run_3_3" )
	RUN_AFTER_SWITCH2=( "run_1_2" "run_2_1" "run_3_1" )
	RUN_AFTER_SWITCH3=( "run_1_3" "run_2_3" "run_3_2" )
}

# 判断是否已经安装 WARP 网络接口或者 Socks5 代理,如已经安装组件尝试启动。再分情况作相应处理
check_warp(){
if [[ -z "${STATUS[@]}" ]]; then
	if type -P wg-quick >/dev/null 2>&1; then
		[[ -z $(wg 2>/dev/null) ]] && wg-quick up wgcf >/dev/null 2>&1
		TRACE4=$(curl -s4m8 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g")
		TRACE6=$(curl -s6m8 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g")
		[[ $TRACE4 =~ on|plus ]] && STATUS[0]=1 || STATUS[0]=0
		[[ $TRACE6 =~ on|plus ]] && STATUS[1]=1 || STATUS[1]=0
	else STATUS=(0 0)
	fi

	type -P warp-cli >/dev/null 2>&1 && [[ ! $(ss -nltp) =~ 'warp-svc' ]] && warp-cli --accept-tos connect >/dev/null 2>&1
	[[ $(ss -nltp) =~ 'warp-svc' ]] && STATUS[2]=1 || STATUS[2]=0
fi

case "${STATUS[@]}" in
'0 0 0') yellow " ${T[${L}4]} " && reading " ${T[${L}3]} " CHOOSE2
     case "$CHOOSE2" in
      2 ) wget -N https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/CFwarp.sh && bash CFwarp.sh; exit;;
      3 ) bash <(curl -fsSL git.io/warp.sh) menu; exit;;
      0 ) exit;;
      * ) wget -N https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh && bash menu.sh; exit;;
     esac;;
'0 0 1' ) PROXYSOCKS5=$(ss -nltp | grep warp | grep -oP '127.0*\S+')
     NIC="-s4m8 --socks5 $PROXYSOCKS5"
     RESTART="socks5_restart";;
'0 1 0' ) NIC='-s6m8'; RESTART="wgcf_restart";;
'1 0 0' ) NIC='-s4m8'; RESTART="wgcf_restart";;
'1 1 0' ) yellow " ${T[${L}23]} " && reading " ${T[${L}3]} " CHOOSE3
      case "$CHOOSE3" in
      2 ) NIC='-s6m8'; RESTART="wgcf_restart";;
      * ) NIC='-s4m8'; RESTART="wgcf_restart";;
      esac;;
'0 1 1' ) yellow " ${T[${L}6]} " && reading " ${T[${L}3]} " CHOOSE3
      case "$CHOOSE3" in
      2 ) NIC='-s6m8'; RESTART="wgcf_restart";;
      * ) PROXYSOCKS5=$(ss -nltp | grep warp | grep -oP '127.0*\S+')
          NIC="-s4m8 --socks5 $PROXYSOCKS5"
	  RESTART="socks5_restart";;
      esac;;
 esac
}

# 期望解锁流媒体, 变量 SUPPORT_NUM 限制选项枚举的次数，不填默认全选, 解锁状态保存在 /etc/wireguard/status.log
input_streammedia_unlock(){
if [[ -z "${STREAM_UNLOCK[@]}" ]]; then
	yellow " ${T[${L}15]} " && reading " ${T[${L}3]} " CHOOSE4
	for ((d=0; d<"$SUPPORT_NUM"; d++)); do
	       ( [[ -z "$CHOOSE4" ]] || echo "$CHOOSE4" | grep -q "$((d+1))" ) && STREAM_UNLOCK[d]='1' || STREAM_UNLOCK[d]='0'
	       [[ $d = 0 ]] && echo 'null' > /etc/wireguard/status.log || echo 'null' >> /etc/wireguard/status.log
	done
fi
UNLOCK_SELECT=$(for ((e=0; e<"$SUPPORT_NUM"; e++)); do
                [[ "${STREAM_UNLOCK[e]}" = 1 ]] && echo -e "[[ ! \${R[*]} =~ 'No' ]] && check$e;" || echo -e "#[[ ! \${R[*]} =~ 'No' ]] && check$e;"
		done)
}

# 期望解锁地区
input_region(){
	if [[ -z "$EXPECT" ]]; then
	REGION=$(curl -sm8 https://ip.gs/country-iso 2>/dev/null)
	reading " $(eval echo "${T[${L}13]}") " EXPECT
	until [[ -z $EXPECT || $EXPECT = [Yy] || $EXPECT =~ ^[A-Za-z]{2}$ ]]; do
		reading " $(eval echo "${T[${L}13]}") " EXPECT
	done
	[[ -z $EXPECT || $EXPECT = [Yy] ]] && EXPECT="$REGION"
	fi
	}

# Telegram Bot 日志推送
input_tg(){
	[[ -z $CUSTOM ]] && reading " $(eval echo "${T[${L}29]}") " TOKEN
	[[ -n $TOKEN && -z $USERID ]] && reading " $(eval echo "${T[${L}30]}") " USERID
	[[ -n $USERID && -z $CUSTOM ]] && reading " $(eval echo "${T[${L}31]}") " CUSTOM
	}

# 根据用户选择在线生成解锁程序，放在 /etc/wireguard/unlock.sh
export_unlock_file(){
input_streammedia_unlock

input_region

input_tg

# 根据解锁模式写入定时任务
sh -c "$TASK"

# 生成 warp_unlock.sh 文件，判断当前流媒体解锁状态，遇到不解锁时更换 WARP IP，直至刷成功。5分钟后还没有刷成功，将不会重复该进程而浪费系统资源
# 感谢以下两位作者: lmc999 [https://github.com/lmc999/RegionRestrictionCheck] 和 luoxue-bot [https://github.com/luoxue-bot/warp_auto_change_ip]
cat <<EOF >/etc/wireguard/warp_unlock.sh
EXPECT="$EXPECT"
TOKEN="$TOKEN"
USERID="$USERID"
CUSTOM="$CUSTOM"
NIC="$NIC"
RESTART="$RESTART"
LOG_LIMIT="1000"
UNLOCK_STATUS='Yes 🎉'
NOT_UNLOCK_STATUS='No 😰'
timedatectl set-timezone Asia/Shanghai

if [[ \$(pgrep -laf ^[/d]*bash.*warp_unlock | awk -F, '{a[\$2]++}END{for (i in a) print i" "a[i]}') -le 2 ]]; then

log_output="\\\$(date +'%F %T'). \\\\\tIP: \\\$WAN \\\\\tCountry: \\\$COUNTRY \\\\\t\\\$CONTENT"
tg_output="Server:\\\$CUSTOM. \\\$(date +'%F %T'). IP: \\\$WAN  Country: \\\$COUNTRY. \\\$CONTENT"

log_message(){ echo -e "\$(eval echo "\$log_output")" | tee -a /root/result.log; [[ \$(cat /root/result.log | wc -l) -gt \$LOG_LIMIT ]] && sed -i "1,10d" /root/result.log; }
tg_message(){ curl -s -X POST "https://api.telegram.org/bot\$TOKEN/sendMessage" -d chat_id=\$USERID -d text="\$(eval echo "\$tg_output")" -d parse_mode="HTML" >/dev/null 2>&1; }

ip(){
unset IP_INFO WAN COUNTRY ASNORG
IP_INFO="\$(curl \$NIC https://ip.gs/json 2>/dev/null)"
WAN=\$(expr "\$IP_INFO" : '.*ip\":\"\([^"]*\).*')
COUNTRY=\$(expr "\$IP_INFO" : '.*country\":\"\([^"]*\).*')
ASNORG=\$(expr "\$IP_INFO" : '.*asn_org\":\"\([^"]*\).*')
}

wgcf_restart(){ systemctl restart wg-quick@wgcf; sleep 5; ip; }

socks5_restart(){
warp-cli --accept-tos delete >/dev/null 2>&1 && warp-cli --accept-tos register >/dev/null 2>&1 && sleep 15
ip
[[ -e /etc/wireguard/license ]] && warp-cli --accept-tos set-license \$(cat /etc/wireguard/license) >/dev/null 2>&1 && sleep 2; }

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
cb
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

${MODE2[0]}
ip
CONTENT='Script runs.'
log_message
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x6*4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
$UNLOCK_SELECT
until [[ ! \${R[*]}  =~ "\$NOT_UNLOCK_STATUS" ]]; do
unset R
\$RESTART
$UNLOCK_SELECT
done
${MODE2[1]}
fi
EOF

# 输出执行结果
green " $RESULT_OUTPUT "
green " $(eval echo "${T[${L}22]}") "
}

uninstall(){
screen -QX u quit >/dev/null 2>&1 && screen -wipe >/dev/null 2>&1
type -P wg-quick >/dev/null 2>&1 && wg-quick down wgcf >/dev/null 2>&1
type -P warp-cli >/dev/null 2>&1 && warp-cli --accept-tos delete >/dev/null 2>&1 && sleep 1
sed -i '/warp_unlock.sh/d' /etc/crontab
kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
rm -f /etc/wireguard/warp_unlock.sh /root/result.log /etc/wireguard/status.log
type -P wg-quick >/dev/null 2>&1 && wg-quick up wgcf >/dev/null 2>&1
type -P warp-cli >/dev/null 2>&1 && warp-cli --accept-tos register >/dev/null 2>&1

# 输出执行结果
green " ${T[${L}11]} "
}

# 传参 1/2
[[ "$@" =~ -[Ee] ]] && L=E
[[ "$@" =~ -[Cc] ]] && L=C

# 主程序运行 1/2
statistics_of_run-times
select_laguage

# 传参 2/2
while getopts ":CcEeUu46SsM:m:A:a:N:n:T:t:" OPTNAME; do
	case "$OPTNAME" in
		'C'|'c' ) L='C';;
		'E'|'e' ) L='E';;
		'U'|'u' ) [[ -z "$f" ]] && check_unlock_running; [[ "$f" -ge "$UNLOCK_NUM" ]] && red " ${T[${L}27]} " && exit 1 || CHOOSE1=4;;
		'4' ) TRACE4=$(curl -s4m8 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g")
		      [[ ! $TRACE4 =~ on|plus ]] && red " ${T[${L}24]} " && exit 1 || STATUS=(1 0 0);;
		'6' ) TRACE6=$(curl -s6m8 https://www.cloudflare.com/cdn-cgi/trace | grep warp | sed "s/warp=//g")
		      [[ ! $TRACE6 =~ on|plus ]] && red " ${T[${L}24]} " && exit 1 || STATUS=(0 1 0);;
		'S'|'s' ) [[ ! $(ss -nltp) =~ 'warp-svc' ]] && red " ${T[${L}24]} " && exit 1 || STATUS=(0 0 1);;
		'M'|'m' ) [[ -z "$RUNNING" ]] && check_unlock_running
			  if [[ "$RUNNING" = 1 ]]; then
			  red " ${T[${L}28]} " && exit 1
			  else [[ $OPTARG != [1-3] ]] && red " ${T[${L}25]} " && exit 1 || CHOOSE1=$OPTARG
			  fi;;
		'A'|'a' ) [[ ! "$OPTARG" =~ ^[A-Za-z]{2}$ ]] && red " ${T[${L}26]} " && exit 1 || EXPECT="$OPTARG";;
		'N'|'n' ) for ((d=0; d<"$SUPPORT_NUM"; d++)); do
	       		  [[ $d = 0 ]] && echo 'null' > /etc/wireguard/status.log || echo 'null' >> /etc/wireguard/status.log; done
			  echo "$OPTARG" | grep -qi 'n' && STREAM_UNLOCK[0]='1' || STREAM_UNLOCK[0]='0'
			  echo "$OPTARG" | grep -qi 'd' && STREAM_UNLOCK[1]='1' || STREAM_UNLOCK[1]='0';;
		'T'|'t' ) TOKEN="$(echo $OPTARG | cut -d'@' -f1)"
			  USERID="$(echo $OPTARG | cut -d'@' -f2)"
			  CUSTOM="$(echo $OPTARG | cut -d'@' -f3)"
			  CUSTOM="${CUSTOM:-'Stream Media Unlock'}";;
    	esac
done

# 主程序运行 2/2
check_system_info
check_unlock_running
if [[ "$f" -lt "$UNLOCK_NUM" ]]; then
MENU_SHOW="$(eval echo "${T[${L}19]}")"
action1(){
"${SWITCH_MODE1[f]}"
export_unlock_file
"${RUN_AFTER_SWITCH1[f]}"
}
action2(){
"${SWITCH_MODE2[f]}"
export_unlock_file
"${RUN_AFTER_SWITCH2[f]}"
}
action3(){
"${SWITCH_MODE3[f]}"
export_unlock_file
"${RUN_AFTER_SWITCH3[f]}"
}
action4(){ uninstall; }
action0(){ exit 0; }
else
MENU_SHOW="${T[${L}12]}"
check_dependencies curl
check_warp
action1(){
TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"*/5 * * * * root bash /etc/wireguard/warp_unlock.sh\" >> /etc/crontab"
RESULT_OUTPUT="${T[${L}10]}"
export_unlock_file
	}
action2(){
MODE2=("while true; do" "sleep 1h; done")
TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root screen -USdm u bash /etc/wireguard/warp_unlock.sh\" >> /etc/crontab"
RESULT_OUTPUT="${T[${L}20]}"
check_dependencies screen
export_unlock_file
screen -USdm u bash /etc/wireguard/warp_unlock.sh
	}
action3(){
MODE2[0]="while true; do"
MODE2[1]="sleep 1h; done"
TASK="sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root nohup bash /etc/wireguard/warp_unlock.sh &\" >> /etc/crontab"
RESULT_OUTPUT="${T[${L}21]}"
export_unlock_file
nohup bash /etc/wireguard/warp_unlock.sh >/dev/null 2>&1 &
	}

action0(){ exit 0; }
fi

# 菜单显示
menu(){
clear
yellow " ${T[${L}16]} "
red "======================================================================================================================\n"
green " ${T[${L}17]}：$VERSION  ${T[${L}18]}：${T[${L}1]}\n "
red "======================================================================================================================\n"
[[ -z "$CHOOSE1" ]] && yellow " $MENU_SHOW " && reading " ${T[${L}3]} " CHOOSE1
case "$CHOOSE1" in
[0-4] ) action$CHOOSE1;;
* ) red " ${T[${L}14]} "; sleep 1; menu;;
esac
}

menu
