docker-compose up -d
until [ $? -eq 0 ]  
  do
    docker-compose up -d
done
