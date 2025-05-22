#!/usr/bin/env bash

# 定义颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# 检测是否具有 root 权限
[[ $EUID -ne 0 ]] && echo -e "${RED}错误: 请先运行 sudo -i 获取 root 权限后再执行此脚本${RESET}" && exit 1

# 设置 Docker 的脚本
if [[ "$(systemctl is-active docker)" != "active" || "$(systemctl is-active docker.socket)" != "active" ]]; then
  echo -e "${YELLOW}正在解除 Docker 服务的锁定并启动服务...${RESET}"
  systemctl unmask containerd docker.socket docker 2>/dev/null || true
  pkill dockerd 2>/dev/null || true
  pkill containerd 2>/dev/null || true
  systemctl start containerd docker.socket docker 2>/dev/null || true
  sleep 2
fi

# 等待几秒检查输出，验证 Docker 是否启动成功
if [[ "$(systemctl is-active docker)" == "active" && "$(systemctl is-active docker.socket)" == "active" ]]; then
  DOCKER_VERSION=$(docker --version | cut -d ' ' -f 3 | tr -d ',')
  echo -e "${GREEN}===== Docker 服务启动完成 =====${RESET}"
  echo ""
  echo -e "${GREEN}Docker 版本: ${RESET}$DOCKER_VERSION"
  echo -e "${GREEN}Docker 服务状态: ${RESET}active"
  echo -e "${GREEN}Docker Socket 状态: ${RESET}active"
  echo ""
else
  echo -e "${RED}===== Docker 服务启动失败 =====${RESET}"
  echo -e "${RED}Docker 服务状态: ${RESET}$(systemctl is-active docker)"
  echo -e "${RED}Docker Socket 状态: ${RESET}$(systemctl is-active docker.socket)"
  echo -e "${RED}请检查错误信息并重试${RESET}"
  exit 1
fi
echo ""