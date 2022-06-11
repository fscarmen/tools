#!/usr/bin/env bash
TEMP_FILE='ip.temp'

red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }

check_dependencies(){ for c in $@; do
type -p $c >/dev/null 2>&1 || (yellow " 安装 $c 中…… " && ${PACKAGE_INSTALL[b]} "$c") || (yellow " 先升级软件库才能继续安装 \$c，时间较长，请耐心等待…… " && ${PACKAGE_UPDATE[b]} && ${PACKAGE_INSTALL[b]} "$c")
! type -p $c >/dev/null 2>&1 && yellow " 安装 \$c 失败，脚本中止，问题反馈:[https://github.com/fscarmen/tools/issues] " && exit 1; done; }

ARCHITECTURE="$(arch)"
case $ARCHITECTURE in
x86_64 )  FILE=besttrace;;
aarch64 ) FILE=besttracearm;;
i386 )    FILE=besttracemac;;
* ) red " 只支持 AMD64、ARM64、Mac 使用，问题反馈:[https://github.com/fscarmen/tools/issues] " && exit 1;;
esac

# 多方式判断操作系统，试到有值为止。只支持 Debian 10/11、Ubuntu 18.04/20.04 或 CentOS 7/8 ,如非上述操作系统，退出脚本
if [[ $ARCHITECTURE = i386 ]]; then
  sw_vesrs 2>/dev/null | grep -qvi macos && red " 本脚本只支持 Debian、Ubuntu、CentOS、Alpine 或者 macOS 系统,问题反馈:[https://github.com/fscarmen/warp_unlock/issues] " && exit 1
  b=0
  SYSTEM='macOS'
  PACKAGE_INSTALL=("brew install")
  
else
  CMD=(	"$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
      	"$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
	"$(lsb_release -sd 2>/dev/null)"
	"$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
	"$(grep . /etc/redhat-release 2>/dev/null)"
	"$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
	)

  REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|amazon linux|alma|rocky")
  RELEASE=("Debian" "Ubuntu" "CentOS")
  PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update")
  PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install")

  for a in "${CMD[@]}"; do
	  SYS="$a" && [[ -n $SYS ]] && break
  done
  
  for ((b=0; b<${#REGEX[@]}; b++)); do
	[[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[b]} ]] && SYSTEM="${RELEASE[b]}" && break
  done
fi

[[ -z $SYSTEM ]] && red " 本脚本只支持 Debian、Ubuntu、CentOS、Alpine 或者 macOS 系统,问题反馈:[https://github.com/fscarmen/warp_unlock/issues] " && exit 1

check_dependencies curl sudo
ip=$1
green "\n 本脚说明：测 VPS ——> 对端 经过的地区及线路，填本地IP就是测回程，核心程序来由: https://www.ipip.net/ ，请知悉！"
[[ -z "$ip" || $ip = '[DESTINATION_IP]' ]] && reading "\n 请输入目的地 IP: " ip
green "\n 检测中，请稍等片刻。\n"
[[ ! -e "$FILE" ]] && curl -sO https://cdn.jsdelivr.net/gh/fscarmen/tools/besttrace/$FILE
chmod +x "$FILE" >/dev/null 2>&1
sudo ./"$FILE" "$ip" -g cn > $TEMP_FILE
green "$(cat $TEMP_FILE | sed "s/.*\*\(.*局域网\)/\1/g" | sed "s/.*AS[0-9]*//g" | sed "/\*$/d;/^$/d;1d" | uniq | awk '{printf("%d.%s\n"),NR,$0}')"
rm -f $TEMP_FILE $FILE
