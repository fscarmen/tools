docker ps -a | egrep 'Created|Exited'
until [ $? -ne 0 ]  
      do
        docker start $(docker ps -aq)
        docker ps -a | egrep 'Created|Exited'
done
