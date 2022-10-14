root+自定义密码登陆，可以带上密码，如果没有填，运行时会要求输入
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/root.sh) [PASSWORD]
```

测vps到对端经过的地区及线路，填本地IP就是测回程。如果没有填，运行时会要求输入，暂只支持 AMD64 和 ARM64 的VPS
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/return.sh) [DESTINATION_IP]

```

测vps端口是否被墙，可跟参数如 8.8.8.8:443，如不填端口，默认为80
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/check_port.sh) [IP:PORT]

```

端口转发，解决代理443端口被墙，本机用 127.0.0.1
```bash
bash <(curl -sSL http://www.arloor.com/sh/iptablesUtils/natcfg.sh)
```

EUserv docker、docker-compose 状态异常自动恢复，定时任务为1分钟检查一次各docker状态，菜单选择
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/EU_docker_Up.sh)
```

docker 更换端口
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/docker_port.sh)
```

机场测活节点， -c 中文; -e 英文; -r <订阅 URL和节点>; -u 卸载; -a 全自动; -m 手动
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/ssrspeed.sh) [OPTION]
```

OpenVZ dd 为 alpine
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/dd_alpine.sh)
```
