wget -N https://github.com/fscarmen/tools/raw/main/besttrace
chmod +x besttrace
read -p "当地IP:" ip
./besttrace $ip -g cn
