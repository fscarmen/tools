root+自定义密码登陆
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/root.sh)
```

测vps回程线路
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/return.sh)
```
端口转发，解决代理443端口被墙，本机用 127.0.0.1
```bash
bash <(curl -sSL http://www.arloor.com/sh/iptablesUtils/natcfg.sh)
```

EUserv docker 无限启动直至成功
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/EU_docker.sh)
```

EUserv docker-compose 无限启动直至成功，需要先进入 docker-compose.yml 文件所在目录再运行
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/EU_compose.sh)
```
EUserv docker 状态异常自动恢复，定时任务为1分钟检查一次各docker状态
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/EU_docker_Up.sh)
```
取消定时任务并删相关文件，彻底清除
```bash
sed -i '/EU_docker_check/d' /etc/crontab;kill $(pgrep -f EU_docker);rm -f  EU_docker*
```

docker 更换端口
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/docker_port.sh)
```
