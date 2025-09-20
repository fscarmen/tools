#!/bin/bash

# 字体颜色
red(){ echo -e "\033[31m\033[01m$1\033[0m"; }
green(){ echo -e "\033[32m\033[01m$1\033[0m"; }
yellow(){ echo -e "\033[33m\033[01m$1\033[0m"; }

# 安装必要的依赖包
install_dependencies() {
  # 根据系统类型安装 cron 或 cronie
  if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu 系列
    INSTALL='apt -y install'
    type -p crontab >/dev/null 2>&1 || apt -y install cron
  elif [ -f /etc/redhat-release ]; then
    # CentOS/RHEL 系列
    INSTALL='yum -y install'
    type -p crontab >/dev/null 2>&1 || yum -y install cronie
  else
    red "不支持的操作系统"
    exit 1
  fi

  # 安装 flock
  type -p flock >/dev/null 2>&1 || $INSTALL util-linux
}

# 安装守护进程
install(){
  install_dependencies

  # 添加定时任务（每分钟检查一次）
  if ! grep -qE '^[ ]*\*/1[ ]*\*[ ]*\*[ ]*\*[ ]*\*[ ]*root[ ]*bash[ ]*/root/Docker_AutoUp.sh' /etc/crontab; then
    echo '*/1 * * * *  root bash /root/Docker_AutoUp.sh' >> /etc/crontab
  fi

  # 生成 Docker_AutoUp.sh 文件
  cat <<EOF >/root/Docker_AutoUp.sh
#!/bin/bash

# 使用 flock 加锁，确保脚本只会有一个实例在运行
(
  flock -n 200 || exit 1  # 尝试获取锁，若未获取到锁则退出

  # 查找状态为 Created 或 Exited 的容器并尝试重启
  for CONTAINER in \$(docker ps -a --filter "status=created" --filter "status=exited" --format "{{.ID}}")
  do
    docker start \$CONTAINER
    # 检查容器是否已成功启动
    if [[ \$(docker inspect -f '{{.State.Status}}' \$CONTAINER) == "running" ]]; then
      green "容器 \$CONTAINER 已成功启动"
    else
      yellow "容器 \$CONTAINER 启动失败，正在重试..."
      sleep 10  # 等待一段时间后再次尝试
    fi
  done
) 200>/root/Docker_AutoUp.lock  # 锁文件位置，确保同一时刻只允许一个进程执行
EOF

  chmod +x /root/Docker_AutoUp.sh

  # 输出执行结果
  green "Docker 守护进程已运行，系统每分钟检查一次 Docker 状态，重启已停止的容器！"
}

# 卸载守护进程
uninstall(){
  # 删除定时任务
  sed -i '/Docker_AutoUp/d' /etc/crontab

  # 终止与 Docker_AutoUp.sh 相关的所有进程
  kill -9 $(pgrep -f Docker_AutoUp) >/dev/null 2>&1

  # 删除 Docker_AutoUp.sh 文件
  rm -f /root/Docker_AutoUp.sh

  # 删除锁文件
  rm -f /root/Docker_AutoUp.lock

  # 输出执行结果
  green "Docker 守护进程已卸载，相关文件已清除！"
}

# 脚本菜单
clear
green "项目地址：https://github.com/fscarmen/tools/issues"
yellow "1. 安装 Docker 守护进程，定时检查 Docker 状态，每分钟检查一次，检测到 Docker 容器为 Created 或 Exited 时自动启动。"
yellow "2. 卸载 Docker 守护进程"
yellow "0. 退出脚本"
read -p "请选择： " CHOOSE

case "$CHOOSE" in
  1 ) install;;
  2 ) uninstall;;
  0 ) exit 0;;
  * ) red "输入错误，脚本退出"; exit 1;;
esac
