#!/usr/bin/env bash

# 定义颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

# 检测是否具有 root 权限
[[ $EUID -ne 0 ]] && echo -e "${RED}错误: 请先运行 sudo -i 获取 root 权限后再执行此脚本${RESET}" && exit 1

# 设置 Ngrok 隧道和 Docker Firefox 的脚本

echo -e "${GREEN}===== 开始设置 Ngrok 隧道和 Docker Firefox =====${RESET}"
echo -e "${RED}重要提示: ${BLUE}此保活方法最长持续时间为24小时${RESET}"
echo ""

# 获取用户输入
echo -e "${YELLOW}[1/4] 获取必要信息...${RESET}"

echo -e "${YELLOW}注意: Ngrok 免费账户限制了同时只能有一个代理会话，请确保此 token 与用于 SSH 的 token 不同${RESET}"

# 获取ngrok token，确保不为空
while true; do
  read -p "请输入ngrok token (可以从 https://dashboard.ngrok.com 获取): " NGROK_TOKEN
  if [[ -z "$NGROK_TOKEN" ]]; then
    echo -e "${RED}错误: ngrok token不能为空，请重新输入${RESET}"
    continue
  fi
  
  # 检查系统中是否已有使用相同token的ngrok进程
  if ps -ef | grep -v grep | grep -q "ngrok.*--authtoken=${NGROK_TOKEN}"; then
    echo -e "${RED}错误: 系统中已存在使用此token的ngrok进程，请使用其他token${RESET}"
    continue
  fi
  
  # 如果通过了所有检查，跳出循环
  break
done

echo -e "${YELLOW}[2/4] 正在设置 Docker 和 Firefox 容器...${RESET}"

# 确保 Docker 服务正在运行
if [ "$(systemctl is-active docker)" != 'active' ]; then
  systemctl unmask containerd docker.socket docker 2>/dev/null || true
  pkill dockerd 2>/dev/null || true
  pkill containerd 2>/dev/null || true
  systemctl start containerd docker.socket docker 2>/dev/null || true
fi

# 创建 Firefox 数据目录
mkdir -p ~/firefox-data

# 运行 Firefox 容器
echo -e "${YELLOW}正在启动 Firefox 容器...${RESET}"
docker rm -f firefox 2>/dev/null || true
docker run -d \
  --name firefox \
  -p 5800:5800 \
  -v ~/firefox-data:/config:rw \
  -e FF_OPEN_URL=https://idx.google.com/ \
  -e TZ=Asia/Shanghai \
  -e LANG=zh_CN.UTF-8 \
  -e ENABLE_CJK_FONT=1 \
  --restart unless-stopped \
  jlesage/firefox

# 检查容器是否成功启动
if ! docker ps | grep -q firefox; then
  echo -e "${RED}错误: Firefox 容器启动失败，请检查 Docker 是否正常运行${RESET}"
  exit 1
fi

echo -e "${YELLOW}[3/4] 正在设置 Ngrok 隧道...${RESET}"

# 下载并设置 ngrok（如果尚未安装）
if [ ! -f /usr/local/bin/ngrok ]; then
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -qO- | tar -xz -C /usr/local/bin
fi

# 使用 nohup 在后台运行 ngrok
pkill -f "ngrok http 5800 --name firefox" >/dev/null 2>&1 || true
nohup /usr/local/bin/ngrok http 5800 --name firefox --authtoken=${NGROK_TOKEN} >/dev/null 2>&1 &

echo -e "${YELLOW}[4/4] 等待 Ngrok 服务启动...${RESET}"
sleep 5

# 获取指定 ngrok 进程的 API 端口
NGROK_PID=$(ps -ef | grep "ngrok http 5800 --name firefox" | grep -v grep | awk '{print $2}')
[ -n "$NGROK_PID" ] && NGROK_API_PORT=$(lsof -p $NGROK_PID 2>/dev/null | grep "LISTEN" | grep "127.0.0.1:" | awk -F":" '{print $2}' | awk '{print $1}')

# 如果无法获取端口，使用默认端口 4040
[ -z "$NGROK_API_PORT" ] && NGROK_API_PORT=4040 && echo -e "${YELLOW}警告: 无法获取 ngrok API 端口，使用默认端口 4040${RESET}"

echo -e "${YELLOW}获取 Ngrok 隧道信息...${RESET}"
NGROK_INFO=$(curl -s http://localhost:${NGROK_API_PORT}/api/tunnels)
grep -q "Your account is limited to 1 simultaneous ngrok agent sessions." <<< $NGROK_INFO && echo -e "${RED}错误: 您的 ngrok 账户限制了同时只能有一个 ngrok 代理会话，请检查您的 ngrok 设置或使用不同的 token。${RESET}" && exit 1
! grep -q "public_url" <<< $NGROK_INFO && echo -e "${RED}错误: 无法获取 ngrok 隧道信息，请检查 ngrok 是否正常运行。尝试访问 http://localhost:${NGROK_API_PORT}/api/tunnels 查看详情。${RESET}" && exit 1
NGROK_URL=$(echo $NGROK_INFO | grep -o '"public_url":"[^"]*"' | grep -o 'https://[^"]*')

echo -e "${GREEN}===== 设置完成 =====${RESET}"
echo ""
echo -e "${GREEN}Firefox 本地访问地址: ${RESET}http://localhost:5800"
echo -e "${GREEN}Firefox Ngrok 访问地址: ${RESET}$NGROK_URL"
echo ""
echo -e "${YELLOW}注意: Docker 容器设置为自动重启，除非手动停止${RESET}"
echo -e "${YELLOW}注意: Ngrok 进程在后台运行，如需停止请使用 'pkill -f \"ngrok http 5800 --name firefox\"' 命令${RESET}"
echo -e "${YELLOW}注意: 这是一个 IDX 保活方案，请确保定期访问以保持活跃状态${RESET}"
echo ""