# EUserv docker 守护进程，定时1分钟检查一次
grep -qE '^[ ]*\*/1[ ]*\*[ ]*\*[ ]*\*[ ]*\*[ ]*root[ ]*bash[ ]*/root/EU_docker_AutoUp.sh' /etc/crontab || echo '*/1 * * * *  root bash /root/EU_docker_AutoUp.sh' >> /etc/crontab

# 生成 EU_docker_AutoUp.sh 文件，判断当前 docker 状态，遇到 Created 或 Exited 时重启，直至刷成功。1分钟后还没有刷成功，将不会重复该进程而浪费系统资源
echo "[[ \$(pgrep -laf ^[/d]*bash.*EU_docker_AutoUp | awk -F, '{a[\$2]++}END{for (i in a) print i"'" "'"a[i]}') -le 2 ]] && " >EU_docker_AutoUp.sh
echo '	until [[ -z $(docker ps -a | egrep "Created|Exited") ]]' >>EU_docker_AutoUp.sh
echo '		do docker start $(docker ps -a | egrep "Created|Exited" | awk '"'{print \$1}'); done" >>EU_docker_AutoUp.sh

# 输出执行结果
echo -e "\033[32m EUserv Docker 守护进程已运行，系统1分钟判断一次 Docker 状态，重启已停止的 docker ！ \033[0m"
