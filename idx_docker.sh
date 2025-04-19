#!/usr/bin/env bash

# 定义颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# 检测是否具有 root 权限
[[ $EUID -ne 0 ]] && echo -e "${RED}错误: 请先运行 sudo -i 获取 root 权限后再执行此脚本${RESET}" && exit 1

# 设置 Docker 的脚本
echo -e "${GREEN}===== 开始安装 Docker =====${RESET}"

echo -e "${YELLOW}[1/5] 正在解除 Docker 服务的锁定...${RESET}"
systemctl unmask docker docker.socket containerd &>/dev/null

echo -e "${YELLOW}[2/5] 正在卸载旧版 Docker...${RESET}"
DEBIAN_FRONTEND=noninteractive apt-get purge -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>/dev/null
rm -rf /var/lib/containerd

echo -e "${YELLOW}[3/5] 正在更新软件源...${RESET}"
DEBIAN_FRONTEND=noninteractive apt-get update -qq &>/dev/null

echo -e "${YELLOW}[4/5] 正在安装 Docker...${RESET}"
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>/dev/null

echo -e "${YELLOW}[5/5] 正在启动 Docker 服务...${RESET}"
systemctl start docker docker.socket

# 验证 Docker 是否安装成功
if [[ $(systemctl is-active docker) == "active" && $(systemctl is-active docker.socket) == "active" ]]; then
  DOCKER_VERSION=$(docker --version | cut -d ' ' -f 3 | tr -d ',')
  echo -e "${GREEN}===== Docker 安装完成 =====${RESET}"
  echo ""
  echo -e "${GREEN}Docker 版本: ${RESET}$DOCKER_VERSION"
  echo -e "${GREEN}Docker 服务状态: ${RESET}active"
  echo -e "${GREEN}Docker Socket 状态: ${RESET}active"
  echo ""
else
  echo -e "${RED}===== Docker 安装失败 =====${RESET}"
  echo -e "${RED}Docker 服务状态: ${RESET}$(systemctl is-active docker)"
  echo -e "${RED}Docker Socket 状态: ${RESET}$(systemctl is-active docker.socket)"
  echo -e "${RED}请检查错误信息并重试${RESET}"
  exit 1
fi
echo ""
