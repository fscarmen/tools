read -p "当地IP:" ip
wget -nc https://github.com/fscarmen/tools/raw/main/besttrace
chmod +x besttrace
./besttrace $ip -g cn
