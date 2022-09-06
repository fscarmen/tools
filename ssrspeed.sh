#!/usr/bin/env bash

# shellcheck disable=SC2034

# 当前脚本版本号和新增功能
VERSION=1.0.0

E[0]="Language:\n  1.English (default) \n  2.简体中文"
C[0]="${E[0]}"
E[1]="Speed test and unlocking test is for reference only and does not represent the actual usage, due to network changes, Netflix blocking and ip replacement. Speed test is time-sensitive."
C[1]="测速及解锁测试仅供参考, 不代表实际使用情况, 由于网络情况变化, Netflix 封锁及 ip 更换, 测速具有时效性"
E[2]="New Features: "
C[2]="新特性: "
E[3]="Choose:"
C[3]="请选择:"
E[4]="! This cannot be empty !"
C[4]="! 此处不能为空 !"
E[5]="More than 5 errors have been entered, and the script exits."
C[5]="输入错误超过5次, 脚本退出"
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
E[11]="Set the colors when exporting images:\n  1. origin (default)\n  2. poor"
C[11]="导出图像时设置颜色:\n  1. origin (默认)\n  2. poor"
E[12]="Select sort method, default not sorted:\n  1. Sort by [speed] from fast to slow\n  2. Sort by [speed] from slow to fast\n  3. Sort by [ping] from low to high\n  4. Sort by [ping] from high to low"
C[12]="请选择排序方法, 默认不排序, 如默认请跳过:\n  1. 按 [速度] 从快到慢排序\n  2. 按 [速度] 从慢到快排序\n  3. 按 [ping] 从低到高排序\n  4. 按 [ping] 从高到低排序"
E[13]="This script only supports macOS."
C[13]="本脚本只支持 macOS "
E[14]="Step 1/3: Detect and install brew, python3 and git."
C[14]="进度 1/3: 检测并安装 brew, python3 和 git"
E[15]="Step 2/3: Update SSRSpeedN and dependencies."
C[15]="进度 2/3: 更新 SSRSpeedN 和依赖"
E[16]="Step 3/3: SSRSpeedN speed test."
C[16]="进度 3/3: SSRSpeedN 测速"
E[17]="Installing"
C[17]="安装"
E[18]="Failed to download the client zip package."
C[18]="下载客户端压缩包失败"
E[19]="Client decompression failed."
C[19]="客户端解压失败"
E[20]="Whether to uninstall the following python3 dependencies:"
C[20]="是否卸载以下 python3 依赖:"
E[21]="Whether to uninstall the following environment dependencies:\n git and python3."
C[21]="是否卸载以下环境依赖:\n git 和 python3"
E[22]="Whether to uninstall brew, a package management tool for Mac?"
C[22]="是否卸载 Mac 下的一个包管理工具 brew"
E[23]="To uninstall the above dependencies, please press [y]. The default is not to uninstall:"
C[23]="卸载以上依赖请按[y], 默认为不卸载:"
E[24]="Uninstallation of SSRSpeedN is complete."
C[24]="卸载 SSRSpeedN 已完成"
E[25]="The SSRSpeedN installation folder cannot be found in the current path. Please check if it is already installed or the installation path."
C[25]="当前路径下找不到 SSRSpeedN 安装文件夹, 请确认是否已安装或安装路径"

# 彩色 log 函数, read 函数, text 函数, 友道翻译函数
error() { echo -e "\033[31m\033[01m$1\033[0m" && exit 1; }
info() { echo -e "\033[32m\033[01m$1\033[0m"; }
warning() { echo -e "\033[33m\033[01m$1\033[0m"; }
reading() { read -rp "$(info "$1")" "$2"; }
text() { eval echo "\${${T}[$1]}"; }
# translate() { [[ -n "$1" ]] && curl -ksm8 "http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i=${1//[[:space:]]/}" | cut -d \" -f18 2>/dev/null; }

# 选择语言, 先判断 SSRSpeedN/data/language 里的语言选择, 没有的话再让用户选择, 默认英语
select_language() {
  if [[ $T != [CE] ]]; then
    if [ -e SSRSpeedN/data/language ]; then
      T=$(cat SSRSpeedN/data/language 2>&1)
    else
      T=E && warning "\n $(text 0) \n" && reading " $(text 3) " LNG_CHOICE
      [[ $LNG_CHOICE = 2 ]] && T=C
    fi
  fi
}

help() {
  if [[ $T = C ]] || grep -q 'C' SSRSpeedN/data/language; then
    echo "
用法: ssrspeed [-h] [--version] [-c GUICONFIG] [-u URL] [-m TEST_METHOD]
                   [-M TEST_MODE] [--include FILTER [FILTER ...]]
                   [--include-remark REMARKS [REMARKS ...]]
                   [--include-group GROUP [GROUP ...]]
                   [--exclude EFLITER [EFLITER ...]]
                   [--exclude-group EGFILTER [EGFILTER ...]]
                   [--exclude-remark ERFILTER [ERFILTER ...]] [--use-ssr-cs]
                   [-g GROUP_OVERRIDE] [-y] [-C RESULT_COLOR] [-s SORT_METHOD]
                   [-i IMPORT_FILE] [--skip-requirements-check] [--debug]
                   [--paolu]

选项:

 --version                               显示程序的版本号并退出
 -h,--help                               显示此帮助消息并退出
 -c GUICONFIG,--config = GUICONFIG       加载由 shadowsocksr-csharp 生成的配置。
 -u URL,--url = URL                      从订阅 URL 加载 ssr 配置。
 -m TEST_METHOD,--method = TEST_METHOD   在 [speedtestnet, fast, socket, stasync] 中选择测试方法。
 -M TEST_MODE,--mode = TEST_MODE         在 [all, pingonly, wps] 中选择测试模式。
 --include                               按组过滤节点,并使用关键字注释。
 --include-remark                        使用关键字通过注释过滤节点。
 --include-group                         使用关键字按组名过滤节点。
 --exclude                               按组排除节点,并使用关键字进行注释。
 --exclude-group                         使用关键字按组排除节点。
 --exclude-remark                        通过使用关键字的注释排除节点。
 --use-ssr-cs                            用 ShadowsocksR-C# 替换 ShadowsocksR-libev(仅 Windows)
 -g GROUP                                手动设置组。
 -y,--yes                                测试前跳过节点列表确认。
 -C RESULT_COLOR,--color = RESULT_COLOR  导出图像时设置颜色。
 -S SORT_METHOD,--sort = SORT_METHOD     在 [speed, rspeed, ping, rping] 中选择排序方法,默认不排序。
 -i IMPORT_FILE,--import = IMPORT_FILE   从 json 文件导入测试结果并导出。
 -skip-requirements-check                跳过要求检查。
 --debug                                 在调试模式下运行程序。

 测试模式
 模式                  备注
 TCP_PING             仅 tcp ping,无速度测试
 WEB_PAGE_SIMULATION  网页模拟测试
 ALL                  全速测试(不包括网页模拟)

 测试方法
 方法                  备注
 ST_ASYNC             单线程异步下载
 SOCKET               具有多线程的原始套接字
 SPEED_TEST_NET       SpeedTest.Net 速度测试
 FAST                 Fast.com 速度测试
"
  else

    echo "
usage: ssrspeed [-h] [--version] [-c GUICONFIG] [-u URL] [-m TEST_METHOD]
                  [-M TEST_MODE] [--include FILTER [FILTER ...]]
                  [--include-remark REMARKS [REMARKS ...]]
                  [--include-group GROUP [GROUP ...]]
                  [--exclude EFLITER [EFLITER ...]]
                  [--exclude-group EGFILTER [EGFILTER ...]]
                  [--exclude-remark ERFILTER [ERFILTER ...]] [--use-ssr-cs]
                  [-g GROUP_OVERRIDE] [-y] [-C RESULT_COLOR] [-s SORT_METHOD]
                  [-i IMPORT_FILE] [--skip-requirements-check] [--debug]
                  [--paolu]

Options:

 --version                              show program's version number and exit
 -h, --help                             show this help message and exit
 -c GUICONFIG, --config=GUICONFIG       Load config generated by shadowsocksr-csharp.
 -u URL, --url=URL                      Load ssr config from subscription url.
 -m TEST_METHOD, --method=TEST_METHOD   Select test method in in [speedtestnet, fast, socket, stasync].
 -M TEST_MODE, --mode=TEST_MODE         Select test mode in [all, pingonly, wps].
 --include                              Filter nodes by group and remarks using keyword.
 --include-remark                       Filter nodes by remarks using keyword.
 --include-group                        Filter nodes by group name using keyword.
 --exclude                              Exclude nodes by group and remarks using keyword.
 --exclude-group                        Exclude nodes by group using keyword.
 --exclude-remark                       Exclude nodes by remarks using keyword.
 --use-ssr-cs                           Replace the ShadowsocksR-libev with the ShadowsocksR-C# (Only Windows)
 -g GROUP                               Manually set group.
 -y, --yes                              Skip node list confirmation before test.
 -C RESULT_COLOR, --color=RESULT_COLOR  Set the colors when exporting images..
 -S SORT_METHOD, --sort=SORT_METHOD     Select sort method in [speed, rspeed, ping, rping], default not sorted.
 -i IMPORT_FILE, --import=IMPORT_FILE   Import test result from json file and export it.
 --skip-requirements-check              Skip requirements check.
 --debug                                Run program in debug mode.

 Test Modes
 Mode                 Remark
 TCP_PING             Only tcp ping, no speed test
 WEB_PAGE_SIMULATION  Web page simulation test
 ALL                  Full speed test (exclude web page simulation)

 Test Methods
 Methods              Remark
 ST_ASYNC             Asynchronous download with single thread
 SOCKET               Raw socket with multithreading
 SPEED_TEST_NET       Speed Test Net speed test
 FAST                 Fast.com speed test
"
  fi
  exit 0
}

input() {
  local i=0
  while [ -z "$URL" ]; do
    ((i++)) || true
    [ "$i" -gt 1 ] && NOT_BLANK="$(text 4) " && [ "$i" = 6 ] && error "\n $(text 5) "
    reading "\n ${NOT_BLANK}$(text 6) " URL
  done
  [ -n "$URL" ] && URL="-u $URL"
  warning "\n $(text 7) "
  reading "\n $(text 8) " INCLUDE_REMARK
  [ -n "$INCLUDE_REMARK" ] && INCLUDE_REMARK="--include-remark $INCLUDE_REMARK"
  reading "\n $(text 9) " EXCLUDE_REMARK
  [ -n "$EXCLUDE_REMARK" ] && EXCLUDE_REMARK="--exclude-remark $EXCLUDE_REMARK"
  reading "\n $(text 10) " GROUP
  [ -n "$GROUP" ] && GROUP="-g $GROUP"
  RESULT_COLOR="--color=origin"
  #  RESULT_COLOR="--color=origin" && warning "\n $(text 11) " && reading " $(text 3) " CHOOSE_COLOR && [ "$CHOOSE_COLOR" = 2 ] && RESULT_COLOR="--color=poor"
  warning "\n $(text 12) " && reading " $(text 3) " METHOD_CHOICE
  case "$METHOD_CHOICE" in 1) SORT_METHOD="--sort=speed" ;; 2) SORT_METHOD="--sort=rspeed" ;; 3) SORT_METHOD="--sort=ping" ;; 4) SORT_METHOD="--sort=rping" ;; esac
}

check_operating_system() {
  sw_vesrs 2>/dev/null | grep -iqv macos && error " $(text 13) "
}

check_brew() {
  info "\n $(text 14) \n"
  ! type -p brew >/dev/null 2>&1 && warning " $(text 17) brew " && sudo /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
  ! type -p pip3 >/dev/null 2>&1 && warning " $(text 17) python3 " && sudo brew install python3
  ! type -p git >/dev/null 2>&1 && warning " $(text 17) git " && sudo brew install git
}

# shellcheck disable=SC2015
check_ssrspeedn() {
  info "\n $(text 15) \n"
  [ ! -e SSRSpeedN ] && sudo git clone https://github.com/Oreomeow/SSRSpeedN
  if [ ! -e SSRSpeedN/resources/clients ]; then
    local LATEST
    LATEST=$(sudo curl -fsSL "https://api.github.com/repos/Oreomeow/SSRSpeedN/releases/latest" | grep tag_name | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)
    LATEST=${LATEST:-'1.1.1'}
    sudo curl -oL SSRSpeedN/resources/clients_darwin_64.zip https://github.com/OreosLab/SSRSpeedN/releases/download/v"$LATEST"/clients_darwin_64.zip
    [ ! -e SSRSpeedN/resources/clients_darwin_64.zip ] && error " $(text 18) " || sudo unzip -d SSRSpeedN/resources/ SSRSpeedN/resources/clients_darwin_64.zip
    [ ! -e SSRSpeedN/resources/clients ] && error " $(text 19) " || sudo rm -f SSRSpeedN/resources/clients_darwin_64.zip
  fi
  sudo chmod -R +x SSRSpeedN
  cd SSRSpeedN || exit 1
  sudo git pull || sudo git fetch --all && sudo git reset --hard origin/main
  echo "$T" | sudo tee data/language >/dev/null 2>&1
  sudo pip3 install --upgrade pip
  sudo pip3 install six
  sudo pip3 install -r requirements.txt
  [ ! -e data/ssrspeed.json ] && sudo cp -f data/ssrspeed.example.json data/ssrspeed.json
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
    #   warning "\n $(text 21) " && reading " $(text 23) " UNINSTALL_GIT_PYTHON3
    #   warning "\n $(text 22) " && reading " $(text 23) " UNINSTALL_BREW
    cd SSRSpeedN || exit 1
    [[ $UNINSTALL_REQS = [Yy] ]] && sudo pip3 uninstall -ry requirements.txt
    cd ..
    sudo rm -rf SSRSpeedN
    #   [[ $UNINSTALL_GIT_PYTHON3 = [Yy] ]] && brew uninstall git
    #   [[ $UNINSTALL_BREW = [Yy] ]] && sudo
    info " $(text 24) "
    exit 0
  else
    error " $(text 25) "
    exit 1
  fi
}

## Main ##

# 传参 1/2
[[ "$*" =~ -[Ee] ]] && T=E
[[ "$*" =~ -[Cc] ]] && T=C

select_language

# 传参 2/2
while getopts ":HhUuR:r:" OPTNAME; do
  case "$OPTNAME" in
  [Hh]) help ;;
  [Uu]) uninstall ;;
  [Rr]) URL=$OPTARG ;;
  esac
done

check_operating_system
input
check_brew
check_ssrspeedn
test
