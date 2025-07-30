#!/bin/bash
set -e

# 检查 Caddy 是否已安装，并显示版本号
if command -v caddy >/dev/null 2>&1; then
  CADDY_VERSION=$(caddy version | grep -o 'v[0-9.]*')
  echo -e "\033[1;33mCaddy is already installed. Version: $CADDY_VERSION\033[0m"
  exit 0
fi

# 检测操作系统
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
  OS_VERSION=$VERSION_ID
else
  echo -e "\033[1;31mError: Unable to detect OS from /etc/os-release\033[0m"
  exit 1
fi
echo -e "\033[1;32mDetected OS: $OS $OS_VERSION\033[0m"

# 设置 IS_SUDO（使用一行命令）
command -v sudo >/dev/null 2>&1 && IS_SUDO="sudo" || IS_SUDO=""

# 检查是否具有 root 权限
if [ $(id -u) -ne 0 ] && [ -z "$IS_SUDO" ]; then
  echo -e "\033[1;31mError: This script requires root privileges. Please run as root or with sudo.\033[0m"
  exit 1
fi

# 处理命令行参数
if [ -z "$1" ] || [ "$1" == "install" ]; then
  ACTION="install"
elif [ "$1" == "uninstall" ]; then
  ACTION="uninstall"
else
  echo "Usage: $0 [install|uninstall]"
  exit 1
fi

if [ "$ACTION" == "install" ]; then
  echo -e "\033[1;33mInstalling Caddy on $OS...\033[0m"
  if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ] || [ "$OS" == "raspbian" ]; then
    # 确定获取工具
    if command -v curl >/dev/null 2>&1; then
      FETCH_TOOL="curl"
      FETCH_OPTIONS="-1sLf"
    elif command -v wget >/dev/null 2>&1; then
      FETCH_TOOL="wget"
      FETCH_OPTIONS="-qO-"
    else
      echo -e "\033[1;33mNeither curl nor wget is installed. Installing curl...\033[0m"
      $IS_SUDO apt update
      $IS_SUDO apt install -y curl
      FETCH_TOOL="curl"
      FETCH_OPTIONS="-1sLf"
    fi

    # 安装依赖
    $IS_SUDO apt install -y debian-keyring debian-archive-keyring apt-transport-https

    # 获取 gpg 密钥
    $FETCH_TOOL $FETCH_OPTIONS 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | $IS_SUDO gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

    # 获取 debian.list
    $FETCH_TOOL $FETCH_OPTIONS 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | $IS_SUDO tee /etc/apt/sources.list.d/caddy-stable.list

    # 设置权限
    $IS_SUDO chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    $IS_SUDO chmod o+r /etc/apt/sources.list.d/caddy-stable.list

    # 更新 apt
    $IS_SUDO apt update

    # 安装 caddy
    $IS_SUDO apt install -y caddy
  elif [ "$OS" == "fedora" ]; then
    # Fedora
    $IS_SUDO dnf install -y 'dnf-command(copr)'
    $IS_SUDO dnf copr enable -y @caddy/caddy
    $IS_SUDO dnf install -y caddy
  elif [ "$OS" == "centos" ] || [ "$OS" == "rhel" ]; then
    # RHEL/CentOS
    if [ "$OS_VERSION" == "7" ]; then
      # RHEL/CentOS 7
      $IS_SUDO yum install -y yum-plugin-copr
      $IS_SUDO yum copr enable -y @caddy/caddy
      $IS_SUDO yum install -y caddy
    else
      # RHEL/CentOS 8+
      $IS_SUDO dnf install -y 'dnf-command(copr)'
      $IS_SUDO dnf copr enable -y @caddy/caddy
      $IS_SUDO dnf install -y caddy
    fi
  elif [ "$OS" == "arch" ] || [ "$OS" == "manjaro" ] || [ "$OS" == "parabola" ]; then
    # Arch Linux/Manjaro/Parabola
    $IS_SUDO pacman -Syu --noconfirm caddy
  else
    echo -e "\033[1;31mError: Installation on $OS is not supported.\033[0m"
    exit 1
  fi
elif [ "$ACTION" == "uninstall" ]; then
  echo -e "\033[1;33mUninstalling Caddy from $OS...\033[0m"
  if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ] || [ "$OS" == "raspbian" ]; then
    $IS_SUDO apt remove -y caddy
  elif [ "$OS" == "fedora" ]; then
    $IS_SUDO dnf remove -y caddy
  elif [ "$OS" == "centos" ] || [ "$OS" == "rhel" ]; then
    if [ "$OS_VERSION" == "7" ]; then
      $IS_SUDO yum remove -y caddy
    else
      $IS_SUDO dnf remove -y caddy
    fi
  elif [ "$OS" == "arch" ] || [ "$OS" == "manjaro" ] || [ "$OS" == "parabola" ]; then
    $IS_SUDO pacman -R --noconfirm caddy
  else
    echo -e "\033[1;31mError: Uninstallation on $OS is not supported.\033[0m"
    exit 1
  fi
fi

echo -e "\033[1;32mOperation completed successfully.\033[0m"