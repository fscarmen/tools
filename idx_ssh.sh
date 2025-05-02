#!/usr/bin/env bash

# 定义颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# 检测是否具有 root 权限
[[ $EUID -ne 0 ]] && echo -e "${RED}错误: 请先运行 sudo -i 获取 root 权限后再执行此脚本${RESET}" && exit 1

# 设置 SSH 和 Ngrok 隧道的脚本

echo -e "${GREEN}===== 开始设置 SSH 和 Ngrok 隧道 =====${RESET}"

# 获取用户输入
echo -e "${YELLOW}[1/5] 获取必要信息...${RESET}"

# 获取密码，确保至少10位且不为空
while true; do
  read -p "请输入root密码 (至少10位): " PASSWORD
  if [[ -z "$PASSWORD" ]]; then
    echo -e "${RED}错误: 密码不能为空，请重新输入${RESET}"
  elif [[ ${#PASSWORD} -lt 10 ]]; then
    echo -e "${RED}错误: 密码长度不足10位，请重新输入${RESET}"
  else
    break
  fi
done

# 获取ngrok token，确保不为空
while true; do
  read -p "请输入ngrok token (可以从 https://dashboard.ngrok.com 获取): " NGROK_TOKEN
  if [[ -z "$NGROK_TOKEN" ]]; then
    echo -e "${RED}错误: ngrok token不能为空，请重新输入${RESET}"
  else
    break
  fi
done

echo -e "${YELLOW}[2/5] 正在终止现有的 SSH 进程...${RESET}"
lsof -i:22 | awk '/IPv4/{print $2}' | xargs kill -9 2>/dev/null || true

echo -e "${YELLOW}[3/5] 正在配置 SSH 服务，允许 root 登录和密码认证...${RESET}"
echo -e '\nPermitRootLogin yes\nPasswordAuthentication yes' >> /etc/ssh/sshd_config

echo -e "${YELLOW}[4/5] 正在设置 root 用户密码...${RESET}"
echo root:$PASSWORD | chpasswd root

echo -e "${YELLOW}[5/5] 正在解除 SSH 和 Docker 服务的锁定，启用密码访问...${RESET}"
systemctl unmask ssh containerd docker.socket docker
pkill dockerd
pkill containerd
systemctl start ssh containerd docker.socket docker

# 下载并设置 ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -qO- | tar -xz -C /usr/local/bin

# 使用 nohup 在后台运行 ngrok
pkill -f "ngrok tcp 22" >/dev/null 2>&1 || true
nohup /usr/local/bin/ngrok tcp 22 --authtoken=${NGROK_TOKEN} >/dev/null 2>&1 &

echo -e "${YELLOW}等待 ngrok 服务启动...${RESET}"
sleep 5

echo -e "${YELLOW}获取 ngrok 隧道信息...${RESET}"
NGROK_INFO=$(curl -s http://localhost:4040/api/tunnels)
grep -q "Your account is limited to 1 simultaneous ngrok agent sessions." <<< $NGROK_INFO && echo -e "${RED}错误: 您的 ngrok 账户限制了同时只能有一个 ngrok 代理会话，请检查您的 ngrok 设置。${RESET}" && exit 1
! grep -q "public_url" <<< $NGROK_INFO && echo -e "${RED}错误: 无法获取 ngrok 隧道信息，请检查 ngrok 是否正常运行。${RESET}" && exit 1
NGROK_URL=$(sed 's#.*tcp://\([^"]\+\)".*#\1#' <<< $NGROK_INFO)
NGROK_HOST=$(cut -d: -f1 <<< $NGROK_URL)
NGROK_PORT=$(cut -d: -f2 <<< $NGROK_URL)

echo -e "${GREEN}===== 设置完成 =====${RESET}"
echo ""
echo -e "${GREEN}SSH 地址: ${RESET}$NGROK_HOST"
echo -e "${GREEN}SSH 端口: ${RESET}$NGROK_PORT"
echo -e "${GREEN}SSH 用户: ${RESET}root"
echo -e "${GREEN}SSH 密码: ${RESET}$PASSWORD"
echo ""
echo -e "${GREEN}使用以下命令连接到您的服务器:${RESET}"
echo -e "${GREEN}ssh root@$NGROK_HOST -p $NGROK_PORT${RESET}"
echo ""
echo -e "${YELLOW}注意: SSH 和 Docker 服务已解除锁定，可以使用密码进行访问${RESET}"
echo -e "${YELLOW}注意: ngrok 进程在后台运行，如需停止请使用 'pkill -f \"ngrok tcp 22\"' 命令${RESET}"
echo ""
