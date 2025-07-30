root+自定义密码登陆，可以带上密码，如果没有填，运行时会要求输入
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/root.sh) '[PASSWORD]'
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

OpenVZ dd 为 alpine
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/dd_alpine.sh)
```

解码加密 shell 脚本
```bash
bash <(curl -sSL https://raw.githubusercontent.com/fscarmen/tools/main/decode_shell.sh)
```

融合怪测评脚本
```bash
bash <(wget -qO- --no-check-certificate https://github.com/spiritLHLS/ecs/raw/main/ecs.sh)
```

在 Docker 容器中或 Serverless 平台中使用 systemctl python 版
```bash
bash <(wget -qO- --no-check-certificate https://raw.githubusercontent.com/fscarmen/tools/main/systemctl-py.sh)
```

idx.google.com 开启 ssh 密码登陆
```bash
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/tools/main/idx_ssh.sh)
```

idx.google.com 安装 docker
```bash
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/tools/main/idx_docker.sh)
```

idx.google.com 24小时保活
```bash
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/tools/main/idx_alive.sh)
```

Caddy 一键脚本
```bash
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/tools/main/caddy.sh)
```

Docker 一键脚本
```bash
bash <(wget -qO- get.docker.com)
```bash