#!/usr/bin/env bash

# shellcheck disable=SC2015,2034,2089,2090

# 当前脚本版本号和新增功能
VERSION=1.0.1

E[0]="Language:\n 1. English (default) \n 2. 简体中文"
C[0]="${E[0]}"
E[1]="Speed test and unlocking test is for reference only and does not represent the actual usage, due to network changes, Netflix blocking and ip replacement. Speed test is time-sensitive."
C[1]="测速及解锁测试仅供参考, 不代表实际使用情况, 由于网络情况变化, Netflix 封锁及 ip 更换, 测速具有时效性"
E[2]="New Features: 1. Add automatic and custom items when testing nodes; 2. synchronize the latest GeoIP library of P3terx."
C[2]="新特性: 1. 增加测节点时自动和自定义项; 2. 同步最新的 P3terx 的 GeoIP 库"
E[3]="Choose:"
C[3]="请选择:"
E[4]="! This cannot be empty !"
C[4]="! 此处不能为空 !"
E[5]="More than 5 errors have been entered, and the script exits."
C[5]="输入错误超过 5 次, 脚本退出"
E[6]="Please input a subscription url or a single node supported by v2ray (VLESS is not supported):"
C[6]="请输入订阅链接或者 v2ray 支持的单节点 (不支持 VLESS):"
E[7]="If there are more than 2 filters below, you can separate the keywords by spaces."
C[7]="以下筛选条件如超过 2 个, 可以通过空格分隔关键词."
E[8]="Filter nodes by remarks using keyword:"
C[8]="使用关键字通过注释筛选节点:"
E[9]="Exclude nodes by remarks using keyword:"
C[9]="通过使用关键字的注释排除节点:"
E[10]="Manually set group:"
C[10]="请输入测速组名:"
E[11]="Set the colors when exporting images:\n 1. origin (default)\n 2. poor"
C[11]="导出图像时设置颜色:\n 1. origin (默认)\n 2. poor"
E[12]="Select sort method:\n 1. Sort by [speed] from fast to slow\n 2. Sort by [speed] from slow to fast\n 3. Sort by [ping] from low to high\n 4. Sort by [ping] from high to low\n 5. Not sorted (default)"
C[12]="请选择排序方法:\n 1. 按 [速度] 从快到慢排序\n 2. 按 [速度] 从慢到快排序\n 3. 按 [ping] 从低到高排序\n 4. 按 [ping] 从高到低排序\n 5. 不排序 (默认)"
E[13]="The script supports MacOS, Debian, Ubuntu, CentOS, Arch or Alpine systems only."
C[13]="本脚本只支持 MacOS, Debian, Ubuntu, CentOS, Arch 或 Alpine 系统"
E[14]="Step 1/3: Install dependence-list:"
C[14]="进度 1/3: 安装依赖列表:"
E[15]="Step 2/3: Update SSRSpeedN and dependencies."
C[15]="进度 2/3: 更新 SSRSpeedN 和依赖"
E[16]="Step 3/3: SSRSpeedN speed test."
C[16]="进度 3/3: SSRSpeedN 测速"
E[17]="Step 1/3: All dependencies already exist and do not need to be installed additionally."
C[17]="进度 1/3: 所有依赖已存在，不需要额外安装"
E[18]="Failed to download the client zip package."
C[18]="下载客户端压缩包失败"
E[19]="Client decompression failed."
C[19]="客户端解压失败"
E[20]="Whether to uninstall the following python3 dependencies:"
C[20]="是否卸载以下 python3 依赖:"
E[21]="The script supports AMD64 only."
C[21]="本脚本只支持 AMD64 架构"
E[22]="Step 1/3: Detect and install brew, python3 and git."
C[22]="进度 1/3: 检测并安装 brew, python3 和 git"
E[23]="To uninstall the above dependencies, please press [y]. The default is not to uninstall:"
C[23]="卸载以上依赖请按 [y], 默认为不卸载:"
E[24]="Uninstallation of SSRSpeedN is complete."
C[24]="卸载 SSRSpeedN 已完成"
E[25]="The SSRSpeedN installation folder cannot be found in the current path. Please check if it is already installed or the installation path."
C[25]="当前路径下找不到 SSRSpeedN 安装文件夹, 请确认是否已安装或安装路径"
E[26]="Installing brew"
C[26]="安装 brew"
E[27]="Whether to uninstall the following environment dependencies:\n git and python3."
C[27]="是否卸载以下环境依赖:\n git 和 python3"
E[28]="Whether to uninstall brew, a package management tool for Mac?"
C[28]="是否卸载 Mac 下的一个包管理工具 brew"
E[29]="Mode:\n 1.Ping and Streaming Media for all nodes. (default)\n 2.Customization"
C[29]="模式:\n 1.所有节点的 Ping + 流媒体 (默认)\n 2.自定义"
E[30]="Test items:\n 1.Ping only\n 2.Streaming Media only\n 3.Above all (default)"
C[30]="测试项目:\n 1.只测 Ping\n 2.只测流媒体\n 3.以上全部 (默认)"
E[31]="Multiplex:\n 1.On (default)\n 2.Off"
C[31]="多路复用:\n 1.开启 (默认)\n 2.关闭"
E[32]="Maximum number of concurrent connections. Input 1 if the airport does not support concurrency. ( Range: 1-999, default: 50):"
C[32]="最大并发连接数, 如机场不支持并发, 请输入 1 (数字范围: 1-999, 默认: 50):"

# 彩色 log 函数, read 函数, text 函数
error() { echo -e "\033[31m\033[01m$1\033[0m" && exit 1; }
info() { echo -e "\033[32m\033[01m$1\033[0m"; }
warning() { echo -e "\033[33m\033[01m$1\033[0m"; }
reading() { read -rp "$(info "$1")" "$2"; }
text() { eval echo "\${${L}[$*]}"; }

# 选择语言, 先判断 SSRSpeedN/data/setting 里的语言选择, 没有的话再让用户选择, 默认英语
select_language() {
  if [[ "$L" != [CE] ]]; then
    if [ -e SSRSpeedN/data/setting ]; then
      L=$(grep 'language' SSRSpeedN/data/setting | cut -d= -f2)
    else
      L=E && warning "\n $(text 0) \n" && reading " $(text 3) " LNG_CHOICE
      [ "$LNG_CHOICE" = 2 ] && L=C
    fi
  fi
}

help() {
  if [ $L = C ] || ([ $L != E ] && grep -q 'language=C' SSRSpeedN/data/setting); then
    echo "
用法: ssrspeed.sh [Option]

选项:

 -h        显示此帮助消息并退出
 -c        中文
 -e        英文
 -r URL    从订阅 URL 加载 ssr 配置
 -a        自动测试模式
 -c        自定义测试模式
 -u        卸载
"
  else
    echo "
usage: ssrspeed.sh [Option]

Options:

 -h        Show this help message and exit.
 -c        Chinese.
 -e        English.
 -r URL    Load ssr config from subscription url.
 -a        Automatic testing mode.
 -c        Custom testing mode.
 -u        Uninstall.
"
  fi
  exit 0
}

check_operating_system() {
  UNAME=$(uname 2>/dev/null)
  case "$UNAME" in
  Darwin)
    FILE=clients_darwin_64.zip
    SED_MAC="''"
    ;;
  Linux)
    FILE=clients_linux_amd64.zip
    [ "$(uname -m)" != "x86_64" ] && error " $(text 21) "
    [ "$L" = C ] && timedatectl set-timezone Asia/Shanghai || timedatectl set-timezone UTC
    CMD=("$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
    "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
    "$(lsb_release -sd 2>/dev/null)"
    "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
    "$(grep . /etc/redhat-release 2>/dev/null)"
    "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
    )

    for i in "${CMD[@]}"; do SYS="$i" && [ -n "$SYS" ] && break; done

    REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'" "alpine" "arch linux")
    RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Alpine" "Arch")
    EXCLUDE=("bookworm")
    PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "apk update -f" "pacman -Sy")
    PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "apk add -f" "pacman -S --noconfirm")
    PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "yum -y autoremove" "apk del -f" "pacman -Rcnsu --noconfirm")

    for ((int = 0; int < ${#REGEX[@]}; int++)); do
      echo "$SYS" | grep -iq "${REGEX[int]}" && SYSTEM="${RELEASE[int]}" && [ -n "$SYSTEM" ] && break
    done
    [ -z "$SYSTEM" ] && error " $(text 13) "
    ;;
  *) error " $(text 13) " ;;
  esac
}

input_url() {
  local i=0
  while [ -z "$URL" ]; do
    ((i++)) || true
    [ "$i" -gt 1 ] && NOT_BLANK="$(text 4) " && [ "$i" = 6 ] && error "\n $(text 5) "
    reading "\n ${NOT_BLANK}$(text 6) " URL
  done
  [ -n "$URL" ] && URL="-u $URL"
}

mode() {
  MAXCONNECTIONS=50
  PING=true
  GPING=true
  PORT=true
  SPEED=true
  STSPEED=true
  STREAM=true
  MULTIPLEX=true
  [[ "$MODE_CHOICE" != [12] ]] && warning "\n $(text 29) \n" && reading " $(text 3) " MODE_CHOICE
  if [ "$MODE_CHOICE" = 2 ]; then
    warning "\n $(text 30) \n" && reading " $(text 3) " ITEM_CHOICE
    case "$ITEM_CHOICE" in
    1)
      NETFLIX=false
      STREAM=false
      HBO=false
      DISNEY=false
      YOUTUBE=false
      ABEMA=false
      BAHAMUT=false
      DAZN=false
      TVB=false
      BILIBILI=false
      ;;
    2)
      PING=false
      GPING=false
      SPEED=false
      STSPEED=false
      PORT=false
      ;;
    esac
    reading "\n $(text 32) " MAXCONNECTIONS
    local i=0
    until [[ $MAXCONNECTIONS =~ ^[0-9]{1,3}$ || -z $MAXCONNECTIONS ]]; do
      ((i++)) || true
      [ "$i" = 6 ] && error "\n $(text 5) "
      reading "\n $(text 32) " MAXCONNECTIONS
    done
    MAXCONNECTIONS=${MAXCONNECTIONS:-50}
    if [ "$ITEM_CHOICE" != 2 ]; then
      warning "\n $(text 12) \n" && reading " $(text 3) " METHOD_CHOICE
      case "$METHOD_CHOICE" in 1) SORT_METHOD="--sort=speed" ;; 2) SORT_METHOD="--sort=rspeed" ;; 3) SORT_METHOD="--sort=ping" ;; 4) SORT_METHOD="--sort=rping" ;; esac
      warning "\n $(text 31) \n" && reading " $(text 3) " MULTIPLEX_CHOICE
      [ "$MULTIPLEX_CHOICE" = 2 ] && MULTIPLEX=false
    fi
    warning "\n $(text 7) "
    reading "\n $(text 8) " INCLUDE_REMARK
    [ -n "$INCLUDE_REMARK" ] && INCLUDE_REMARK="--include-remark $INCLUDE_REMARK"
    reading "\n $(text 9) " EXCLUDE_REMARK
    [ -n "$EXCLUDE_REMARK" ] && EXCLUDE_REMARK="--exclude-remark $EXCLUDE_REMARK"
    reading "\n $(text 10) " GROUP
    [ -n "$GROUP" ] && GROUP="-g $GROUP"
    RESULT_COLOR="--color=origin"
    #  RESULT_COLOR="--color=origin" && warning "\n $(text 11) " && reading " $(text 3) " CHOOSE_COLOR && [ "$CHOOSE_COLOR" = 2 ] && RESULT_COLOR="--color=poor"
  fi
}

# shellcheck disable=SC2086
check_dependencies_Darwin() {
  info "\n $(text 22) \n"
  ! type -p brew >/dev/null 2>&1 && warning " $(text 26) " && sudo /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
  for j in {" sudo"," wget"," git"," python3"," unzip"}; do ! type -p $j >/dev/null 2>&1 && DEPS+=$j; done
  if [ -n "$DEPS" ]; then
    info "\n $(text 14) $DEPS \n"
    brew install $DEPS
  else
    info "\n $(text 17) \n"
  fi
}

# shellcheck disable=SC2086
check_dependencies_Linux() {
  for j in {" sudo"," wget"," git"," python3"," unzip"}; do ! type -p $j >/dev/null 2>&1 && DEPS+=$j; done
  if [ -n "$DEPS" ]; then
    info "\n $(text 14) $DEPS \n"
    ${PACKAGE_UPDATE[int]}
    ${PACKAGE_INSTALL[int]} $DEPS
  else
    info "\n $(text 17) \n"
  fi
}

check_ssrspeedn() {
  info "\n $(text 15) \n"
  [ ! -e SSRSpeedN ] && sudo git clone https://github.com/Oreomeow/SSRSpeedN
  if [ ! -e SSRSpeedN/resources/clients ]; then
    LATEST=$(sudo wget --no-check-certificate -qO- "https://api.github.com/repos/Oreomeow/SSRSpeedN/releases/latest" | grep tag_name | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)
    LATEST=${LATEST:-'1.2.1'}
    sudo wget --no-check-certificate -O SSRSpeedN/resources/$FILE https://github.com/OreosLab/SSRSpeedN/releases/download/v"$LATEST"/$FILE
    [ ! -e SSRSpeedN/resources/$FILE ] && error " $(text 18) " || sudo unzip -d SSRSpeedN/resources/ SSRSpeedN/resources/$FILE
    [ ! -e SSRSpeedN/resources/clients ] && error " $(text 19) " || sudo rm -f SSRSpeedN/resources/$FILE
  fi
  sudo chmod -R +x SSRSpeedN
  cd SSRSpeedN || exit 1
  sudo git pull || sudo git fetch --all && sudo git reset --hard origin/main
  GEOIP_LATEST=$(sudo wget --no-check-certificate -qO- "https://api.github.com/repos/P3TERX/GeoLite.mmdb/releases/latest" | grep 'tag_name' | head -n 1 | cut -d\" -f4)
  if [[ ${GEOIP_LATEST//./} -gt $(grep 'GeoIP' data/setting 2>/dev/null | cut -d= -f2 | sed "s#[.]##g") ]]; then
    [ ! -d resources/databases ] && sudo mkdir -p resources/databases
    for a in {GeoLite2-ASN.mmdb,GeoLite2-City.mmdb}; do
      sudo wget --no-check-certificate -O resources/databases/"$a" https://github.com/P3TERX/GeoLite.mmdb/releases/download/"$GEOIP_LATEST"/"$a"
    done
  fi
  echo -e "language=$L\nGeoIP=$GEOIP_LATEST" | sudo tee data/setting >/dev/null 2>&1
  #  echo -e "language=$L" | sudo tee data/setting >/dev/null 2>&1
  sudo pip3 install --upgrade pip
  sudo pip3 install six
  sudo pip3 install -r requirements.txt
  [ ! -e data/ssrspeed.json ] && sudo cp -f data/ssrspeed.example.json data/ssrspeed.json
  sudo sed -i $SED_MAC "/maxConnections/s#:.*#: $MAXCONNECTIONS,#g; /\"ping/s#:.*#: $PING,#g; /\"gping/s#:.*#: $GPING,#g; /\"port/s#:.*#: $PORT,#g; /\"speed/s#:.*#: $SPEED,#g; /\"StSpeed/s#:.*#: $STSPEED,#g; /\"stream/s#:.*#: $STREAM,#g; /\"multiplex/s#:.*#: $MULTIPLEX,#g" data/ssrspeed.json
}

# shellcheck disable=SC2086
test() {
  info "\n $(text 16) \n"
  sudo python3 -m ssrspeed $URL $INCLUDE_REMARK $EXCLUDE_REMARK $GROUP $RESULT_COLOR $SORT_METHOD --skip-requirements-check --yes
}

uninstall() {
  if [ -e SSRSpeedN ]; then
    REQS=$(sed "/^$/d" SSRSpeedN/requirements.txt)
    REQS="${REQS//[[:space:]]/, }"
    warning "\n $(text 20)\n $REQS " && reading " $(text 23) " UNINSTALL_REQS
    #  if [ "$UNAME" = Darwin ]; then
    #    warning "\n $(text 27) " && reading " $(text 23) " UNINSTALL_GIT_PYTHON3
    #    warning "\n $(text 28) " && reading " $(text 23) " UNINSTALL_BREW
    #  fi
    cd SSRSpeedN || exit 1
    [[ "$UNINSTALL_REQS" = [Yy] ]] && sudo pip3 uninstall -yr requirements.txt
    cd ..
    sudo rm -rf SSRSpeedN
    #  if [ "$UNAME" = Darwin ]; then
    #    [[ $UNINSTALL_GIT_PYTHON3 = [Yy] ]] && brew uninstall git
    #    [[ $UNINSTALL_BREW = [Yy] ]] && sudo
    #  fi
    info " $(text 24) "
    exit 0
  else
    error " $(text 25) "
  fi
}

## Main ##

# 传参 1/2
[[ "$*" =~ -[Ee] ]] && L=E
[[ "$*" =~ -[Cc] ]] && L=C

select_language

# 传参 2/2
while getopts ":AaCcHhUuR:r:" OPTNAME; do
  case "$OPTNAME" in
  [Hh]) help ;;
  [Uu]) uninstall ;;
  [Rr]) URL=$OPTARG ;;
  [Cc]) MODE_CHOICE=2 ;;
  [Aa]) MODE_CHOICE=1 ;;
  esac
done

check_operating_system
input_url
mode
check_dependencies_"$UNAME"
check_ssrspeedn
test
