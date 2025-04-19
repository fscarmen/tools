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
echo -e "${YELLOW}[1/8] 获取必要信息...${RESET}"

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

echo -e "${YELLOW}[2/8] 正在解除 SSH 服务的锁定...${RESET}"
systemctl unmask ssh

echo -e "${YELLOW}[3/8] 正在停止当前运行的 SSH 服务...${RESET}"
pkill sshd

echo -e "${YELLOW}[4/8] 正在卸载旧版 SSH 服务器并安装新版...${RESET}"
DEBIAN_FRONTEND=noninteractive apt-get remove -y -qq --purge openssh-server &>/dev/null
DEBIAN_FRONTEND=noninteractive apt-get -qq update &>/dev/null
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openssh-server &>/dev/null

echo -e "${YELLOW}[5/8] 正在设置 root 用户密码...${RESET}"
echo root:$PASSWORD | chpasswd root

echo -e "${YELLOW}[6/8] 正在配置 SSH 服务，允许 root 登录和密码认证...${RESET}"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g;s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config

echo -e "${YELLOW}[7/8] 正在重启 SSH 服务并设置 ngrok 隧道...${RESET}"
systemctl restart ssh
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -qO- | tar -xz -C /usr/local/bin

# 创建 ngrok systemd 服务
cat > /etc/systemd/system/ngrok.service << EOF
[Unit]
Description=ngrok tunnel service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ngrok tcp 22 --authtoken=${NGROK_TOKEN}
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启用并启动 ngrok 服务
systemctl daemon-reload
systemctl enable --now ngrok &>/dev/null

echo -e "${YELLOW}等待 ngrok 服务启动...${RESET}"
sleep 5

echo -e "${YELLOW}[8/8] 获取 ngrok 隧道信息...${RESET}"
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
