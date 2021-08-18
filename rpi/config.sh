#!/bin/bash
# $1 - username
# $2 - IP Address
# $3 - hostname

### Add User
useradd -g users -G sudo,pi,adm -m ${1}

### Add Authorized Key
mkdir -p /home/${1}/.ssh
chmod 700 /home/${1}/.ssh 

curl -o /home/${1}/.ssh/authorized_keys https://github.com/joeygrasso.keys

chmod 600 /home/${1}/.ssh/authorized_keys

chown -R joey:users /home/${1}/

### Set Network Interface
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

iface eth0 inet static
    address ${2}
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 192.168.1.101 8.8.8.8 8.8.4.4
    dns-search cpunation.net
EOF
 
### Set Hostname
echo ${3} > /etc/Hostname

cat << EOF > /etc/hosts
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

127.0.1.1       ${3}
EOF

### Install
apt-get update
apt-get dist-upgrade -y
apt-get install -y vim, git, net-tools

### Reboot
reboot