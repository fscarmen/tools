pgrep -laf 'EU_docker_cron'
if [ $? -ne 0 ]
	then bash /root/EU_docker_cron.sh
fi	
