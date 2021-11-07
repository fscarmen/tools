[[ ! $(arch) =~ .*x86_64* ]] && echo -e "\033[31m 只支持 AMD64 架构的 VPS 使用，问题反馈:[https://github.com/fscarmen/tools/issues] \033[0m" && exit 1 
ip=$1
[[ -z $ip || $ip = '[LOCAL_IP]' ]] && read -p "当地IP:" ip
wget -nc https://github.com/fscarmen/tools/raw/main/besttrace
chmod +x besttrace
./besttrace $ip -g cn
