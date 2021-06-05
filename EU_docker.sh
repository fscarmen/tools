docker ps -a
read -p "想要启动的项目名(NAMES下面的):" dockername
docker start $dockername
until [ $? -eq 0 ]  
  do
    docker start $dockername
  done 
    exit 0
