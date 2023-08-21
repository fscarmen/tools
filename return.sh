#!/usr/bin/env bash

red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
reading(){ read -rp "$(green "$1")" "$2"; }
translate() { [ -n "$1" ] && curl -ksm8 "http://fanyi.youdao.com/translate?&doctype=json&type=EN2ZH_CN&i=${1//[[:space:]]/}" | cut -d \" -f18 2>/dev/null; }

check_dependencies() {
  DEPS_CHECK=("ping" "curl" "sudo")
  DEPS_INSTALL=(" iputils-ping" " curl" " sudo")
  for ((g=0; g<${#DEPS_CHECK[@]}; g++)); do [ ! $(type -p ${DEPS_CHECK[g]}) ] && DEPS+=${DEPS_INSTALL[g]}; done
  if [ -n "$DEPS" ]; then
    green "\n 安装依赖列表: $DEPS \n"
    ${PACKAGE_UPDATE[int]} >/dev/null 2>&1
    ${PACKAGE_INSTALL[int]} $DEPS >/dev/null 2>&1
  else
    green "\n 所有依赖已存在，不需要额外安装 \n"
  fi
}


ARCHITECTURE="$(arch)"
case "$ARCHITECTURE" in
  "x86_64" | "amd64" )
    FILE=nexttrace_linux_amd64
    ;;
  "armv7l" | "armv8" | "armv8l" | "aarch64")
    FILE=nexttrace_linux_arm64
    ;;
  "i386" | "i686")
    FILE=nexttrace_darwin_amd64
    ;;
  * )
    red " 本脚本只支持 AMD64、ARM64、i386 或者 i686 使用，问题反馈:[https://github.com/fscarmen/tools/issues] " && exit 1
esac

# 多方式判断操作系统，包括 macOS, Debian, Ubuntu, CentOS，如非以上系统，脚本提示并退出
if [[ $ARCHITECTURE = i386 ]]; then
  sw_vesrs 2>/dev/null | grep -qvi macos && red " 本脚本只支持 Debian、Ubuntu、CentOS、Alpine 或者 macOS 系统,问题反馈:[https://github.com/fscarmen/warp_unlock/issues] " && exit 1
  b=0
  SYSTEM='macOS'
  PACKAGE_INSTALL=("brew install")
  
else
  if [ -s /etc/os-release ]; then
    SYS="$(grep -i pretty_name /etc/os-release | cut -d \" -f2)"
  elif [ $(type -p hostnamectl) ]; then
    SYS="$(hostnamectl | grep -i system | cut -d : -f2)"
  elif [ $(type -p lsb_release) ]; then
    SYS="$(lsb_release -sd)"
  elif [ -s /etc/lsb-release ]; then
    SYS="$(grep -i description /etc/lsb-release | cut -d \" -f2)"
  elif [ -s /etc/redhat-release ]; then
    SYS="$(grep . /etc/redhat-release)"
  elif [ -s /etc/issue ]; then
    SYS="$(grep . /etc/issue | cut -d '\' -f1 | sed '/^[ ]*$/d')"
  fi

  REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|amazon linux|alma|rocky")
  RELEASE=("Debian" "Ubuntu" "CentOS")
  PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update")
  PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install")

  for ((b=0; b<${#REGEX[@]}; b++)); do
	  [[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[b]} ]] && SYSTEM="${RELEASE[b]}" && break
  done
fi

[ -z "$SYSTEM" ] && red " 本脚本只支持 Debian、Ubuntu、CentOS 或者 macOS 系统,问题反馈:[https://github.com/fscarmen/tools/issues] " && exit 1

check_dependencies
ip=$1
green "\n 本脚说明：测 VPS ——> 对端 经过的地区及线路，填本地IP就是测回程，核心程序来自: NextTrace， 请知悉！"
[[ -z "$ip" || $ip = '[DESTINATION_IP]' ]] && reading "\n 请输入目的地 IP: " ip
yellow "\n 检测中，请稍等片刻。\n"

# 可以使用的 IP API 服务商
IP_API=("http://ip-api.com/json/" "https://api.ip.sb/geoip")
ISP=("isp" "isp")
IP=("query" "ip")

# 查 IPv4 信息
IP_4=$(curl -s4m5 -A Mozilla ${IP_API[0]}) &&
WAN_4=$(expr "$IP_4" : '.*'${IP[0]}'\":[ ]*\"\([^"]*\).*')
if [ -n "$WAN_4" ]; then
  COUNTRY_4E=$(expr "$IP_4" : '.*country\":[ ]*\"\([^"]*\).*')
  COUNTRY_4=$(translate "$COUNTRY_4E")
  ASNORG_4=$(expr "$IP_4" : '.*'${ISP[0]}'\":[ ]*\"\([^"]*\).*')
  FRAUD_SCORE_4=$(curl -m10 -sL -H "Referer: https://scamalytics.com" \
  "https://scamalytics.com/ip/$WAN_4" | awk -F : '/Fraud Score/ {gsub(/[^0-9]/,"",$2); print $2}')
  TYPE_4=$(curl -sG https://api.abuseipdb.com/api/v2/check \
  --data-urlencode "ipAddress=$WAN_4" \
  -d maxAgeInDays=90 \
  -d verbose \
  -H "Key: 59f18f3d7bfe41ba6eb6c6ba8bd8801c2add9ec039fedcb7b863c8dbfbcbe7f96d3648c3a456c8fb" \
  -H "Accept: application/json" | sed 's@.*usageType":"\([^"]\+\).*@\1@g' | sed "s@.*Data Center.*@数据中心@;s@Fixed Line ISP@家庭宽带@;s@.*Commercial.*@商业宽带@;s@.*Mobile ISP.*@移动流量@;s@.*Content Delivery Network.*@内容分发网络(CDN)@;s@.*Search Engine Spider.*@搜索引擎蜘蛛@;s@.*University.*@教育网@;s@.*Unknown.*@家庭宽带@")
  green " IPv4: $WAN_4\t\t 地区: $COUNTRY_4\t 宽带类型: $TYPE_4\t 欺诈分数(越低越好): $FRAUD_SCORE_4\t ISP: $ASNORG_4\n"
fi

# 查 IPv6 信息
IP_6=$(curl -s6m5 -A Mozilla ${IP_API[1]}) &&
WAN_6=$(expr "$IP_6" : '.*'${IP[1]}'\":[ ]*\"\([^"]*\).*') &&
if [ -n "$WAN_6" ]; then
  COUNTRY_6E=$(expr "$IP_6" : '.*country\":[ ]*\"\([^"]*\).*')
  COUNTRY_6=$(translate "$COUNTRY_6E")
  ASNORG_6=$(expr "$IP_6" : '.*'${ISP[1]}'\":[ ]*\"\([^"]*\).*')
  FRAUD_SCORE_6=$(curl -m10 -sL -H "Referer: https://scamalytics.com" \
  "https://scamalytics.com/ip/$WAN_6" | awk -F : '/Fraud Score/ {gsub(/[^0-9]/,"",$2); print $2}')
  TYPE_6=$(curl -sG https://api.abuseipdb.com/api/v2/check \
  --data-urlencode "ipAddress=$WAN_6" \
  -d maxAgeInDays=90 \
  -d verbose \
  -H "Key: 59f18f3d7bfe41ba6eb6c6ba8bd8801c2add9ec039fedcb7b863c8dbfbcbe7f96d3648c3a456c8fb" \
  -H "Accept: application/json" | sed 's@.*usageType":"\([^"]\+\).*@\1@g' | sed "s@.*Data Center.*@数据中心@;s@Fixed Line ISP@家庭宽带@;s@.*Commercial.*@商业宽带@;s@.*Mobile ISP.*@移动流量@;s@.*Content Delivery Network.*@内容分发网络(CDN)@;s@.*Search Engine Spider.*@搜索引擎蜘蛛@;s@.*University.*@教育网@;s@.*Unknown.*@家庭宽带@")
  green " IPv6: $WAN_6\t 地区: $COUNTRY_6\t 宽带类型: $TYPE_6\t 欺诈分数(越低越好): $FRAUD_SCORE_6\t ISP: $ASNORG_6\n"
fi

[[ $ip =~ '.' && -z "$IP_4" ]] && red " VPS 没有 IPv4 网络，不能查 $ip\n" && exit 1
[[ $ip =~ ':' && -z "$IP_6" ]] && red " VPS 没有 IPv6 网络，不能查 $ip\n" && exit 1

# 下载 nexttrace 主程序
if [ ! -e $FILE ]; then
  VERSION=$(curl -sSL "https://api.github.com/repos/nxtrace/Ntrace-core/releases/latest" | awk -F \" '/tag_name/{print $4}')
  curl -sLO https://github.com/nxtrace/Ntrace-core/releases/download/$VERSION/$FILE
  chmod +x "$FILE" >/dev/null 2>&1
fi

# 查路由
RESULT=$(sudo ./"$FILE" "$ip" -g cn 2>/dev/null)
PART_1=$(echo "$RESULT" | grep '^[0-9]\{1,2\}[ ]\+[0-9a-f]' | awk '{$1="";$2="";print}' | sed "s@^[ ]\+@@g")
PART_2=$(echo "$RESULT" | grep '\(.*ms\)\{3\}' | sed 's/.* \([0-9*].*ms\).*ms.*ms/\1/g')
SPACE=' '
for ((i=1; i<=$(echo "$PART_1" | wc -l); i++)); do
  [ "$i" -eq 10 ] && unset SPACE
  green " ${i} ${SPACE}$(echo "$PART_2" | sed -n "${i}p")\t$(echo "$PART_1" | sed -n "${i}p") "
done

# 执行完成，删除 nexttrace 主程序
rm -f $FILE