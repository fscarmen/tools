# 字体彩色
red(){
	echo -e "\033[31m\033[01m$1\033[0m"
    }
green(){
	echo -e "\033[32m\033[01m$1\033[0m"
    }
yellow(){
	echo -e "\033[33m\033[01m$1\033[0m"
}


install(){
# EUserv docker 守护进程，定时1分钟检查一次
type -p yum && INSTALL='yum -y install' || INSTALL='apt -y install'
! type -p crontab >/dev/null 2>&1 && $INSTALL cron
grep -qE '^[ ]*\*/1[ ]*\*[ ]*\*[ ]*\*[ ]*\*[ ]*root[ ]*bash[ ]*/root/EU_docker_AutoUp.sh' /etc/crontab || echo '*/1 * * * *  root bash /root/EU_docker_AutoUp.sh' >> /etc/crontab

# 生成 EU_docker_AutoUp.sh 文件，判断当前 docker 状态，遇到 Created 或 Exited 时重启，直至刷成功。1分钟后还没有刷成功，将不会重复该进程而浪费系统资源
        cat <<EOF >/root/EU_docker_AutoUp.sh
[[ \$(pgrep -laf ^[/d]*bash.*EU_docker_AutoUp | awk -F, '{a[\$2]++}END{for (i in a) print i" "a[i]}') -le 2 ]] &&
        until [[ -z \$(docker ps -a | egrep "Created|Exited") ]]
                do docker start \$(docker ps -a | egrep "Created|Exited" | awk '{print \$1}')
        done
EOF

# 输出执行结果
green " EUserv Docker 守护进程已运行，系统1分钟判断一次 Docker 状态，重启已停止的 docker ！"
}

uninstall(){
sed -i '/EU_docker/d' /etc/crontab
kill -9 $(pgrep -f EU_docker_AutoUp) >/dev/null 2>&1
rm -f /root/EU_docker_AutoUp.sh

# 输出执行结果
green " EUserv Docker 守护进程已卸载 ！"
}

clear
green " 项目地址：https://github.com/fscarmen/tools/issues\n=========================================================== "
yellow " 1.安装 docker 守护进程,定时1分钟检查一次,检测到 docker 状态为 Created 或 Exited 时自动开刷直至成功\n 2.卸载\n 0.退出脚本 "
read -p " 请选择： " CHOOSE
case "$CHOOSE" in
1 ) install;;
2 ) uninstall;;
0 ) exit 0;;
* ) red " 输入错误，脚本退出 ";exit 1;;
esac
