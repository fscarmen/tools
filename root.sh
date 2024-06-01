#!/bin/bash

[[ $(id -u) != 0 ]] && echo -e "\033[31m 必须以root方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/fscarmen/tools/issues] \033[0m" && exit 1
password=$1
[[ -z $password || $password = '[PASSWORD]' ]] && read -p "请输入root密码:" password
echo root:$password | chpasswd root
sed -i 's@^\(Include[ ]*/etc/ssh/sshd_config.d/\*\.conf\)@# \1@' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g;s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
sed -i 's/#ListenAddress ::/ListenAddress ::/' /etc/ssh/sshd_config
sed -i 's/#AddressFamily any/AddressFamily any/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication no/g' /etc/ssh/sshd_config
sed -i '/^AuthorizedKeysFile/s/^/#/' /etc/ssh/sshd_config
sed -i 's/^#[[:space:]]*KbdInteractiveAuthentication.*\|^KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
[ -f /etc/selinux/config ] && [ $(type -p getenforce) ] && [ $(getenforce) = 'Enforcing' ] && { setenforce 0; sed -i 's/^SELINUX=.*/# &/; /SELINUX=/a\SELINUX=disabled' /etc/selinux/config; }
if [ -f /etc/os-release ]; then
  if [ "$(awk -F= '/VERSION_CODENAME/{print $2}' /etc/os-release)" = 'noble' ]; then
    systemctl restart ssh
  elif [[ "$(grep 'PRETTY_NAME' /etc/os-release)" =~ 'Alpine' ]]; then
    service sshd restart
  else
    systemctl restart sshd
  fi
else
  systemctl restart ssh >/dev/null 2>&1
  systemctl restart sshd >/dev/null 2>&1
  service sshd restart >/dev/null 2>&1
fi
echo -e "\033[32m 请重新登陆，用户名：root ， 密码：$password \033[0m"