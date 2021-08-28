docker ps -a
read -p "参考上面 docker 列表，填入需改端口的项目名:" dockername
read -p "原来的端口:" port1
read -p "变更后的端口:" port2

docker stop $dockername
systemctl stop docker
cd /var/lib/docker/containers/$(docker ps -a | grep $dockername | awk '{print $1}')*
sed -i "s/\"HostPort\"\:\"$port1\"\/\"HostPort\"\:\"$port2\"/g" hostconfig.json
echo -e "\033[32m 恭喜！你的项目 $dockername 端口 $port1 已变更为 $port2 。\033[0m"
