# 生成 EU_docker_AutoUp.sh 文件，判断当前 docker 状态，遇到 Created 或 Exited 时重启，直至刷成功
echo 'until [[ -z $(docker ps -a | egrep "Created|Exited") ]]' >  /root/EU_docker_AutoUp.sh
echo '	do' >> /root/EU_docker_AutoUp.sh
echo '		docker start $(docker ps -a | egrep "Created|Exited" | awk '"'{print \$1}')" >> /root/EU_docker_AutoUp.sh
echo 'done'  >> /root/EU_docker_AutoUp.sh

# 生成 EU_docker_check.sh 文件，判断刷重启进程 EU_docker_AutoUp.sh 是否存在，不存在则启动刷重启脚本
echo 'if [[ -z $(pgrep -laf EU_docker_AutoUp) ]]' >  /root/EU_docker_check.sh
echo '	then bash /root/EU_docker_AutoUp.sh' >> /root/EU_docker_check.sh
echo 'fi' >> /root/EU_docker_check.sh

# 守护进程，定时1分钟运行一次，避免重复运行 EU_docker_AutoUp.sh 而浪费系统资源
grep -qE '^[ ]*\*/1[ ]*\*[ ]*\*[ ]*\*[ ]*\*[ ]*root[ ]*bash[ ]*/root/EU_docker_check.sh' /etc/crontab || echo '*/1 * * * *  root bash /root/EU_docker_check.sh' >> /etc/crontab

# 输出执行结果
echo -e "\033[32m EUserv Docker 守护进程已运行，系统1分钟判断一次 Docker 状态，重启已停止的 docker ！ \033[0m"
