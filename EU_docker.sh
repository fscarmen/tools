timedatectl set-timezone Asia/Shanghai
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
i=1
docker ps -a
read -p "参考上面 docker 列表，填入需启动的项目名(最后一列 NAMES 下面的):" dockername
docker start $dockername
until [ $? -eq 0 ]  
  do
    let i++
    docker start $dockername
done
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]
echo -e "\033[32m 恭喜！你的项目 $dockername 经过$i次努力终于启动成功，$startTime ---> $endTime", "总耗时:$sumTime秒。\033[0m"
