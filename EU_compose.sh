timedatectl set-timezone Asia/Shanghai
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
i=1
docker-compose up -d
until [ $? -eq 0 ]  
  do
    let i++
    docker-compose up -d
done
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]
echo -e "\033[32m 恭喜！你的项目经过$i次努力终于启动成功，$startTime ---> $endTime", "总耗时:$sumTime秒。\033[0m"
