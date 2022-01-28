#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/bin
export LANG=en_US.UTF-8

# 当前脚本版本号和新增功能
VERSION=1.0

# 期望解锁地区传参
[[ $1 =~ ^[A-Za-z]{2}$ ]] && EXPECT="$1"

# 设置关连数组 T 用于中英文
declare -A T

T[E0]="\n Language:\n  1.English (default) \n  2.简体中文\n"
T[C0]="${T[E0]}"
T[E1]="Born to make stream media unlock by WARP. 1. Media unlock daemon. Check it every 5 minutes. If unlocked, the scheduled task exits immediately. If it is not unlocked, it will be swiped successfully in the background. Advantages: Minimized use of system resources. Disadvantage: Can't see the results as intuitively as screen"
T[C1]="为 WARP 解锁流媒体而生。 1. 流媒体解锁守护进程,定时5分钟检查一次,遇到不解锁时更换 WARP IP，直至刷成功。 优点: 占用系统资源最小化。 缺点: 不能像 screen 那么直观看到结果"
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
T[E7]="Installing curl..."
T[C7]="安装curl中……"
T[E8]="It is necessary to upgrade the latest package library before install curl.It will take a little time,please be patiently..."
T[C8]="先升级软件库才能继续安装 curl，时间较长，请耐心等待……"
T[E9]="Failed to install curl. The script is aborted. Feedback: [https://github.com/fscarmen/warp_unlock/issues]"
T[C9]="安装 curl 失败，脚本中止，问题反馈:[https://github.com/fscarmen/warp_unlock/issues]"
T[E10]="Media unlock daemon installed successfully. The running log of the scheduled task will be saved in /root/ip.log"
T[C10]="媒体解锁守护进程已安装成功。定时任务运行日志将保存在 /root/ip.log"
T[E11]="The media unlock daemon is completely uninstalled."
T[C11]="媒体解锁守护进程已彻底卸载"
T[E12]="\n 1. Install the stream media unlock daemon. Check it every 5 minutes.\n 2. Create a screen named [u] and run\n 0. Exit\n"
T[C12]="\n 1. 安装流媒体解锁守护进程,定时5分钟检查一次,遇到不解锁时更换 WARP IP，直至刷成功\n 2. 创建一个名为 [u] 的 Screen 在后台刷\n 0. 退出\n"
T[E13]="The current region is \$REGION. Confirm press [y] . If you want another regions, please enter the two-digit region abbreviation. \(such as hk,sg. Default is \$REGION\):"
T[C13]="当前地区是:\$REGION，需要解锁当前地区请按 y , 如需其他地址请输入两位地区简写 \(如 hk ,sg，默认:\$REGION\):"
T[E14]="Wrong input."
T[C14]="输入错误"
T[E15]="\n Select the stream media you wanna unlock (Multiple selections are possible, such as 123. The default is select all)\n 1. Netflix"
T[C15]="\n 选择你期望解锁的流媒体 (可多选，如 123，默认为全选)\n 1. Netflix"
T[E16]="This project is designed for brushing WARP IP in order to unlock various streaming media, detailed:[https://github.com/fscarmen/warp_unlock]\n Features:\n	* did not write\n"
T[C16]="本项目专为刷 WARP IP 以便解锁各流媒体。详细说明：[https://github.com/fscarmen/warp_unlock]\n脚本特点:\n	* 未写\n"
T[E17]="Version"
T[C17]="脚本版本"
T[E18]="New features"
T[C18]="功能新增"
T[E19]="\n Stream media unlock daemon is running.\n 1. Uninstall\n 0. Exit\n"
T[C19]="\n 流媒体解锁守护正在运行中\n 1. 卸载\n 0. 退出\n"
T[E20]=""
T[C20]=""

# 自定义字体彩色，read 函数，友道翻译函数
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate(){ [[ -n "$1" ]] && curl -sm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=$1" | cut -d \" -f18 2>/dev/null; }

# 选择语言，先判断 /etc/wireguard/language 里的语言选择，没有的话再让用户选择，默认英语
choose_laguage(){
case $(cat /etc/wireguard/language 2>&1) in
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

# 检查依赖，安装 curl
check_dependencies(){
type -P curl >/dev/null 2>&1 || (yellow " ${T[${L}7]} " && ${PACKAGE_INSTALL[b]} curl) || (yellow " ${T[${L}8]} " && ${PACKAGE_UPDATE[b]} && ${PACKAGE_INSTALL[b]} curl)
! type -P curl >/dev/null 2>&1 && yellow " ${T[${L}9]} " && exit 1
}

# 检查解锁方式是否已运行
check_unlock_running(){
	unlock_method=("$(grep -qE "\*/5.*warp_unlock.*" /etc/crontab && echo 1)")
	for ((c=0; c<${#unlock_method[@]}; c++)); do [[ ${unlock_method[c]} = '1' ]] && break; done
}

# 判断是否已经安装 WARP 网络接口或者 Socks5 代理,如已经安装组件尝试启动。再分情况作相应处理
check_warp(){
#type -P wg-quick >/dev/null 2>&1 && [[ -z $(wg 2>/dev/null) ]] && wg-quick up wgcf >/dev/null 2>&1
[[ -n $(wg 2>/dev/null) ]] && STATUS[0]=1 || STATUS[0]=0

#type -P warp-cli >/dev/null 2>&1 && [[ ! $(ss -nltp) =~ 'warp-svc' ]] && warp-cli --accept-tos connect >/dev/null 2>&1
[[ $(ss -nltp) =~ 'warp-svc' ]] && STATUS[1]=1 || STATUS[1]=0

case "${STATUS[*]}" in
'0 0') yellow " ${T[${L}4]} " && reading " ${T[${L}3]} " CHOOSE2
     case "$CHOOSE2" in
      2 ) wget -N https://cdn.jsdelivr.net/gh/kkkyg/CFwarp/CFwarp.sh && bash CFwarp.sh; exit;;
      3 ) bash <(curl -fsSL git.io/warp.sh) menu; exit;;
      0 ) exit;;
      * ) wget -N https://cdn.jsdelivr.net/gh/fscarmen/warp/menu.sh && bash menu.sh; exit;;
     esac;;
'0 1' ) PROXYSOCKS5=$(ss -nltp | grep warp | grep -oP '127.0*\S+')
     NF="-s4m7 --socks5 $PROXYSOCKS5"
     RESTART="socks5_restart";;
'1 0' ) NF='-4'
     RESTART="wgcf_restart";;
'1 1' ) yellow " ${T[${L}6]} " && reading " ${T[${L}3]} " CHOOSE3
      case "$CHOOSE3" in
      2 ) NF='-6'; RESTART="wgcf_restart";;
      * ) PROXYSOCKS5=$(ss -nltp | grep warp | grep -oP '127.0*\S+')
          NF="-s4m7 --socks5 $PROXYSOCKS5"
	  RESTART="socks5_restart";;
      esac;;
 esac
}

# 期望解锁流媒体, 变量 SUPPORT_NUM 限制选项枚举的试数，不填默认全选
input_streammedia_unlock(){
SUPPORT_NUM='1'
yellow " ${T[${L}15]} " && reading " ${T[${L}3]} " CHOOSE4
for ((d=0; d<"$SUPPORT_NUM"; d++)); do
       ( [[ -z "$CHOOSE4" ]] || echo "$CHOOSE4" | grep -q "$((d+1))" ) && STREAM_UNLOCK[d]='1' || STREAM_UNLOCK[d]='0'
done
UNLOCK_SELECT=$(for ((e=0; e<"$((SUPPORT_NUM+1))"; e++)); do
                [[ "${STREAM_UNLOCK[e]}" = 1 ]] && echo -e "[[ ! \${R[*]} =~ 0 ]] && check$e;"
		done)
}

# 期望解锁地区
input_region(){
	REGION=$(curl -sm8 https://ip.gs/country-iso)
	reading " $(eval echo "${T[${L}13]}") " EXPECT
	until [[ -z $EXPECT || $EXPECT = [Yy] || $EXPECT =~ ^[A-Za-z]{2}$ ]]; do
		reading " $(eval echo "${T[${L}13]}") " EXPECT
	done
	[[ -z $EXPECT || $EXPECT = [Yy] ]] && EXPECT="$REGION"
	}


# 根据用户选择在线生成解锁程序，放在 /etc/wireguard/unlock.sh
export_unlock_file(){
input_streammedia_unlock

[[ -z "$EXPECT" ]] && input_region

select_mode

# 把不同解锁方式做到计划任务里
sh -c "$TASKS"

# 生成 warp_unlock.sh 文件，判断当前流媒体解锁状态，遇到不解锁时更换 WARP IP，直至刷成功。5分钟后还没有刷成功，将不会重复该进程而浪费系统资源
cat <<EOF >/etc/wireguard/warp_unlock.sh
timedatectl set-timezone Asia/Shanghai

if [[ \$(pgrep -laf ^[/d]*bash.*warp_unlock | awk -F, '{a[\$2]++}END{for (i in a) print i" "a[i]}') -le 2 ]]; then

wgcf_restart(){ systemctl restart wg-quick@wgcf && sleep 5; }
		
socks5_restart(){
warp-cli --accept-tos delete >/dev/null 2>&1 && warp-cli --accept-tos register >/dev/null 2>&1 && sleep 15 &&
[[ -e /etc/wireguard/license ]] && warp-cli --accept-tos set-license \$(cat /etc/wireguard/license) >/dev/null 2>&1 && sleep 2; }

check0(){
RESULT[0]=""; REGION[0]=""; R[0]="";
RESULT[0]=\$(curl --user-agent "\${UA_Browser}" $NF -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567"  2>&1)
if [[ \${RESULT[0]} = 200 ]]; then
REGION[0]=\$(curl --user-agent "${UA_Browser}" $NF -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | sed 's/.*com\/\([^-/]\{1,\}\).*/\1/g' | tr '[:lower:]' '[:upper:]')
REGION[0]=\${REGION[0]:-'US'}
fi
echo "\${REGION[0]}" | grep -qi "$EXPECT" && R[0]='Yes' || R[0]='No'
echo -e "\$(date +'%F %T'). Netflix: \${R[0]}" | tee -a /root/ip.log
}

${MODE2[0]}
echo -e "\$(date +'%F %T'). IP:\$(curl $NF https://ip.gs)" | tee -a /root/ip.log
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
$UNLOCK_SELECT
until [[ ! \${R[*]}  =~ 'No' ]]; do
unset R
$RESTART
$UNLOCK_SELECT
done

else echo -e "\$(date +'%F %T'). Brushing IP is working now." | tee -a /root/ip.log
fi
${MODE2[1]}
EOF

# 输出执行结果
green " ${T[${L}10]} "
}

uninstall(){
type -P wg-quick >/dev/null 2>&1 && wg-quick down wgcf >/dev/null 2>&1
type -P warp-cli >/dev/null 2>&1 && warp-cli --accept-tos delete >/dev/null 2>&1 && sleep 1
sed -i '/warp_unlock.sh/d' /etc/crontab
kill -9 $(pgrep -f warp_unlock.sh) >/dev/null 2>&1
rm -f /etc/wireguard/warp_unlock.sh
type -P wg-quick >/dev/null 2>&1 && wg-quick up wgcf >/dev/null 2>&1
type -P warp-cli >/dev/null 2>&1 && warp-cli --accept-tos register >/dev/null 2>&1

# 输出执行结果
green " ${T[${L}11]} "
}

# 主程序运行
choose_laguage
check_unlock_running
if echo ${unlock_method[*]} | grep -q '1'; then
MENU_SHOW="${T[${L}19]}"
action1(){ uninstall; }
action2(){ exit 0; }
action3(){ exit 0; }
else
MENU_SHOW="${T[${L}12]}"
check_system_info
check_dependencies
check_warp
action1(){
sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"*/5 * * * * root bash /etc/wireguard/warp_unlock.sh $AREA 2>&1 | tee -a /root/ip.log\" >> /etc/crontab
export_unlock_file
	}
action2(){ 
MODE2[0]="while true; do"
MODE2[1]="done"
sed -i '/warp_unlock.sh/d' /etc/crontab && echo \"@reboot root screen -USdm u bash /etc/wireguard/warp_unlock.sh $AREA 2>&1 | tee -a /root/ip.log\" >> /etc/crontab
export_unlock_file
screen -USdm u bash /etc/wireguard/warp_unlock.sh $AREA 2>&1 | tee -a /root/ip.log
	}
action3(){ exit 0; }
fi

# 菜单显示
menu(){
clear
yellow " ${T[${L}16]} "
red "======================================================================================================================\n"
green " ${T[${L}17]}：$VERSION  ${T[${L}18]}：${T[${L}1]}\n "
red "======================================================================================================================\n"
yellow " $MENU_SHOW " && reading " ${T[${L}3]} " CHOOSE1
case "$CHOOSE1" in
1 ) action1;;
2 ) action2;;
3 ) action3;;
* ) red " ${T[${L}14]} "; sleep 1; menu;;
esac
}

menu
