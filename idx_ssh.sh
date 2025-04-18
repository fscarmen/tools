#!/usr/bin/env bash

# 检测是否具有 root 权限
[[ $EUID -ne 0 ]] && echo "错误: 请先运行 sudo -i 获取 root 权限后再执行此脚本" && exit 1

# 设置 SSH 和 Ngrok 隧道的脚本

echo "===== 开始设置 SSH 和 Ngrok 隧道 ====="

# 获取用户输入
echo "[1/8] 获取必要信息..."
read -p "请输入root密码:" PASSWORD
read -p "请输入ngrok token (可以从 https://dashboard.ngrok.com/get-started/your-authtoken 获取):" NGROK_TOKEN

echo "[2/8] 正在解除 SSH 服务的锁定..."
systemctl unmask ssh

echo "[3/8] 正在停止当前运行的 SSH 服务..."
pkill sshd

echo "[4/8] 正在卸载旧版 SSH 服务器并安装新版..."
apt remove -y --purge openssh-server &>/dev/null
apt update &>/dev/null
apt install -y openssh-server &>/dev/null

echo "[5/8] 正在设置 root 用户密码..."
echo root:$PASSWORD | chpasswd root

echo "[6/8] 正在配置 SSH 服务，允许 root 登录和密码认证..."
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g;s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config

echo "[7/8] 正在重启 SSH 服务并设置 ngrok 隧道..."
systemctl restart ssh
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -qO- | tar -xz -C /usr/local/bin
nohup ngrok tcp 22 --authtoken=${NGROK_TOKEN} &>/dev/null &

echo "等待 ngrok 服务启动..."
sleep 5

echo "[8/8] 获取 ngrok 隧道信息..."
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | sed 's#.*tcp://\([^"]\+\)".*#\1#')
NGROK_HOST=$(cut -d: -f1 <<< $NGROK_URL)
NGROK_PORT=$(cut -d: -f2 <<< $NGROK_URL)

echo "===== 设置完成 ====="
echo ""
echo "SSH 地址: $NGROK_HOST"
echo "SSH 端口: $NGROK_PORT"
echo "SSH 密码: $PASSWORD"
echo ""
echo "使用以下命令连接到您的服务器:"
echo "ssh root@$NGROK_HOST -p $NGROK_PORT"
