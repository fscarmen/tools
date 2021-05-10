read -p "当地IP:" ip
wget -N https://github.com/fscarmen/tools/raw/main/besttrace
chmod +x besttrace
./besttrace $ip -g cn
