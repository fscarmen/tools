docker ps -a
read -p "参考上面 docker 列表，填入需改端口的项目名:" dockername
read -p "原来的端口:" port1
read -p "变更后的端口:" port2

systemctl stop docker.socket
sed -i 's/"HostPort":"'$port1'"/"HostPort":"'$port2'"/g' /var/lib/docker/containers/$(docker ps -a | grep $dockername | awk '{print $1}')*/hostconfig.json
systemctl start docker.socket
docker start $dockername
echo -e "\033[32m 恭喜！你的项目 $dockername 端口 $port1 变更为 $port2 ，请在下表检查结果。\033[0m"
docker ps -a | grep $dockername | grep $port2
