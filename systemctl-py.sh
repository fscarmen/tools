#!/bin/bash

CMD=( "$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)"
      "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)"
      "$(lsb_release -sd 2>/dev/null)"
      "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)"
      "$(grep . /etc/redhat-release 2>/dev/null)"
      "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')"
    )

for i in "${CMD[@]}"; do
  SYS="$i" && [ -n "$SYS" ] && break
done

REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "amazon linux" "alpine" "arch linux")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Alpine" "Arch")
PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "apk update -f" "pacman -Sy")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "apk add -f" "pacman -S --noconfirm")
PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "yum -y autoremove" "apk del -f" "pacman -Rcnsu --noconfirm")

for ((int=0; int<${#REGEX[@]}; int++)); do
  [[ $(tr 'A-Z' 'a-z' <<< "$SYS") =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && [ -n "$SYSTEM" ] && break
done

if [ ! $(type -p python2) ]; then
  if [ ! $(type -p python3) ]; then
    ${PACKAGE_UPDATE[int]}
    ${PACKAGE_UPDATE[int]} python3
  fi
  wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -O /bin/systemctl
else
  wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /bin/systemctl
fi

chmod a+x /bin/systemctl

[ -e /bin/systemctl ] && echo -e "\n\033[32m\033[01m Systemctl-py installation is complete. \033[0m\n" || echo -e "\n\033[31m Systemctl-py install failed. \033[0m\n"
