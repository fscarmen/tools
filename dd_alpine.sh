#!/usr/bin/env bash
# Converts OpenVZ VPS to Alpine Linux
# WARNING: This script will wipe any data in your VPS!
# GPLv2; Partly based on https://gitlab.com/drizzt/vps2arch

server=http://images.linuxcontainers.org
path=$(wget -O- ${server}/meta/1.0/index-system | \
grep -v edge | awk '-F;' '($1=="alpine" && $3=="amd64") {print $NF}' | tail -1)

cd /
mkdir /x
wget ${server}/${path}/rootfs.tar.xz
tar -C /x -xf rootfs.tar.xz
 
sed -i '/getty/d' /x/etc/inittab
sed -i 's/rc_sys="lxc"/rc_sys="openvz"/' /x/etc/rc.conf

# save root password and ssh directory
sed -i '/^root:/d' /x/etc/shadow
grep '^root:' /etc/shadow >> /x/etc/shadow
[ -d /root/.ssh ] && cp -a /root/.ssh /x/root/

# save network configuration
dev=venet0
ip=$(ip addr show dev $dev | grep global | awk '($1=="inet") {print $2}' | cut -d/ -f1 | head -1)
hostname=$(hostname)
 
#cat > /x/etc/network/interfaces << EOF
#auto lo
#iface lo inet loopback

#auto $dev
#iface $dev inet static
#address $ip
#netmask 255.255.255.255
#up ip route add default dev $dev
# 
#hostname $hostname
#EOF

cp /etc/network/interfaces /x/etc/network/interfaces
cp /etc/resolv.conf /x/etc/resolv.conf
 
# remove all old files and replace with alpine rootfs
find / \( ! -path '/dev/*' -and ! -path '/proc/*' -and ! -path '/sys/*' -and ! -path '/x/*' \) -delete || true
 
/x/lib/ld-musl-x86_64.so.1 /x/bin/busybox cp -a /x/* /
export PATH="/usr/sbin:/usr/bin:/sbin:/bin"
 
rm -rf /x
 
apk update
apk add openssh bash
echo PermitRootLogin yes >> /etc/ssh/sshd_config
rc-update add sshd default
rc-update add mdev sysinit
rc-update add devfs sysinit
#sh # (for example, run `passwd`)

sync
reboot -f
