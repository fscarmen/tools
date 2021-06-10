docker ps -a
read -p "参考上面 docker 列表，填入需启动的项目名(最后一列 NAMES 下面的):" dockername
docker start $dockername
until [ $? -eq 0 ]  
  do
    docker start $dockername
  done
echo -e "\033[32m 恭喜！你的项目 $dockername 已经启动成功。 \033[0m"
