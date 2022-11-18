[[ $(id -u) != 0 ]] && echo -e "\033[31m 必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/tools/issues] \033[0m" && exit 1
password=$1
[[ -z $password || $password = '[PASSWORD]' ]] && read -p "请输入root密码:" password
echo root:$password | chpasswd root
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g;s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
service sshd restart
echo -e "\033[32m 请重新登陆，用户名：root ， 密码：$password \033[0m"
