#!/usr/bin/env bash

# 定义颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# 检测是否具有 root 权限
[[ $EUID -ne 0 ]] && echo -e "${RED}错误: 请先运行 sudo -i 获取 root 权限后再执行此脚本${RESET}" && exit 1

# 解锁服务函数
unlock_services() {
  echo -e "${YELLOW}[4/5] 正在解除 SSH 和 Docker 服务的锁定，启用密码访问...${RESET}"
  if [ "$(systemctl is-active ssh)" != "active" ]; then
    systemctl unmask ssh 2>/dev/null || true
    systemctl start ssh 2>/dev/null || true
  fi

  if [[ "$(systemctl is-active docker)" != "active" || "$(systemctl is-active docker.socket)" != "active" ]]; then
    systemctl unmask containerd docker.socket docker 2>/dev/null || true
    pkill dockerd 2>/dev/null || true
    pkill containerd 2>/dev/null || true
    systemctl start containerd docker.socket docker 2>/dev/null || true
    sleep 2
  fi
}

# SSH 配置函数
configure_ssh() {
  echo -e "${YELLOW}[2/5] 正在终止现有的 SSH 进程...${RESET}"
  lsof -i:22 | awk '/IPv4/{print $2}' | xargs kill -9 2>/dev/null || true

  echo -e "${YELLOW}[3/5] 正在配置 SSH 服务，允许 root 登录和密码认证...${RESET}"

  # 检查并配置 root 登录
  ! grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config && echo -e '\nPermitRootLogin yes' >> /etc/ssh/sshd_config

  # 检查并配置密码认证
  ! grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config && echo -e '\nPasswordAuthentication yes' >> /etc/ssh/sshd_config

  echo root:$PASSWORD | chpasswd
}

# 设置 SSH 和隧道的脚本
echo -e "${GREEN}===== 开始设置 SSH 和隧道 =====${RESET}"

# 选择隧道类型
echo -e "请选择要使用的隧道类型:"
echo -e "1. Ngrok (免费版不支持 TCP，需要信用卡验证) [默认]"
echo -e "2. Frp (需要自己的服务器)"
read -p "请输入选择 [1-2] (默认: 1): " TUNNEL_TYPE

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

case $TUNNEL_TYPE in
  2)
    # Frp 配置
    read -p "请输入 Frp 服务器地址 (域名或IP): " FRP_SERVER
    read -p "请输入 Frp 服务器端口: " FRP_PORT
    read -p "请输入 Frp Token: " FRP_TOKEN
    read -p "请输入远程端口: " FRP_REMOTE_PORT

    configure_ssh

    unlock_services

    echo -e "${YELLOW}[5/5] 正在下载和配置 Frp 客户端...${RESET}"
    FRP=$(wget -qO- https://api.github.com/repos/fatedier/frp/releases/latest | grep 'browser_download_url.*linux_amd64' | cut -d '"' -f 4)
    wget -qO- $FRP | tar xz
    mv frp_*/frpc /usr/local/bin/
    rm -rf frp_*

    mkdir -p /etc/frp
    cat > /etc/frp/frpc.toml << EOF
# 通用配置
serverAddr = "${FRP_SERVER}"
serverPort = ${FRP_PORT}
loginFailExit = false

# 认证配置
auth.method = "token"
auth.token = "${FRP_TOKEN}"

# 传输配置
transport.heartbeatInterval = 10
transport.heartbeatTimeout = 30
transport.dialServerKeepalive = 10
transport.dialServerTimeout = 30
transport.tcpMuxKeepaliveInterval = 10
transport.poolCount = 5

# 代理配置
[[proxies]]
name = "$(hostname)"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = ${FRP_REMOTE_PORT}
EOF

    # 清理已存在的 frpc 进程
    ps -ef | grep "frpc -c /etc/frp/frpc.toml" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null || true
    pkill -f "frpc -c /etc/frp/frpc.toml" >/dev/null 2>&1 || true

    # 启动 frpc
    nohup /usr/local/bin/frpc -c /etc/frp/frpc.toml >/dev/null 2>&1 &

    echo -e "${GREEN}===== 设置完成 =====${RESET}"
    echo ""
    echo -e "${GREEN}SSH 地址: ${RESET}${FRP_SERVER}"
    echo -e "${GREEN}SSH 端口: ${RESET}${FRP_REMOTE_PORT}"
    echo -e "${GREEN}SSH 用户: ${RESET}root"
    echo -e "${GREEN}SSH 密码: ${RESET}$PASSWORD"
    echo ""
    echo -e "${GREEN}使用以下命令连接到您的服务器:${RESET}"
    echo -e "${GREEN}ssh root@${FRP_SERVER} -p ${FRP_REMOTE_PORT}${RESET}"
    echo ""
    echo -e "${YELLOW}注意: SSH 服务已配置，可以使用密码进行访问${RESET}"
    echo -e "${YELLOW}注意: frpc 进程在后台运行，如需停止请使用 'pkill -f frpc' 命令${RESET}"
    echo ""
    ;;
  *)
    # 获取 Ngrok token，确保不为空
    while true; do
      read -p "请输入 Ngrok token (可以从 https://dashboard.ngrok.com 获取): " NGROK_TOKEN
      if [[ -z "$NGROK_TOKEN" ]]; then
        echo -e "${RED}错误: Ngrok token不能为空，请重新输入${RESET}"
      else
        break
      fi
    done

    configure_ssh

    unlock_services

    echo -e "${YELLOW}[5/5] 正在下载和配置 Ngrok 客户端...${RESET}"
    # 下载并设置 Ngrok
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -qO- | tar -xz -C /usr/local/bin

    # 测试运行 Ngrok
    echo -e "${YELLOW}测试 Ngrok 运行状态...${RESET}"
    # 在后台运行 Ngrok 并将输出重定向到临时文件
    TEST_LOG="/tmp/ngrok_test.log"
    /usr/local/bin/ngrok tcp 22 --authtoken=${NGROK_TOKEN} > $TEST_LOG 2>&1 &
    TEST_PID=$!

    # 等待几秒检查输出
    sleep 2

    # 检查日志文件中是否有错误信息
    if grep -q "You must add a credit or debit card" $TEST_LOG; then
      kill $TEST_PID 2>/dev/null
      echo -e "${RED}错误: 免费账户需要添加信用卡或借记卡才能使用 TCP 端点。这是为了防止滥用并保持互联网安全。该卡不会被收费。${RESET}"
      rm -f $TEST_LOG
      exit 1
    elif grep -q "limited to 1 simultaneous ngrok agent session" $TEST_LOG; then
      kill $TEST_PID 2>/dev/null
      echo -e "${RED}错误: 您的 Ngrok 账户限制了同时只能有一个 Ngrok 代理会话，请检查是否有其他正在运行的 Ngrok 进程。${RESET}"
      rm -f $TEST_LOG
      exit 1
    fi

    # 清理测试进程和日志
    kill $TEST_PID 2>/dev/null
    rm -f $TEST_LOG

    # 如果测试成功，终止测试进程
    ps -ef | grep "ngrok tcp 22" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null || true

    # 使用 nohup 在后台运行 Ngrok
    pkill -f "ngrok tcp 22" >/dev/null 2>&1 || true
    sleep 1
    nohup /usr/local/bin/ngrok tcp 22 --authtoken=${NGROK_TOKEN} >/dev/null 2>&1 &

    echo -e "${YELLOW}等待 Ngrok 服务启动...${RESET}"
    sleep 5

    echo -e "${YELLOW}获取 Ngrok 隧道信息...${RESET}"
    # 获取指定 ngrok 进程的 API 端口
    NGROK_PID=$(ps -ef | grep "ngrok tcp 22" | grep -v grep | awk '{print $2}')
    [ -n "$NGROK_PID" ] && NGROK_API_PORT=$(lsof -p $NGROK_PID 2>/dev/null | grep "LISTEN" | grep "localhost:" | awk -F":" '{print $2}' | awk '{print $1}')
    
    # 如果无法获取端口，使用默认端口 4040
    [ -z "$NGROK_API_PORT" ] && NGROK_API_PORT=4040 && echo -e "${YELLOW}警告: 无法获取 ngrok API 端口，使用默认端口 4040${RESET}"
    
    NGROK_INFO=$(curl -s http://localhost:${NGROK_API_PORT}/api/tunnels)
    ! grep -q "public_url" <<< $NGROK_INFO && echo -e "${RED}错误: 无法获取 Ngrok 隧道信息，请检查 Ngrok 是否正常运行。${RESET}" && exit 1
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
    ;;
esac