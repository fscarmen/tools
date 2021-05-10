read -p "请输入root密码:" password
echo root:$password | sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart
echo -e "\033[32m 请重新登陆，用户名：root ， 密码：$password \033[0m"
