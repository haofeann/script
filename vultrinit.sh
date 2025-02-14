#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt-get -y update
apt-get -y install lrzsz vim net-tools unzip zip wget git screen 
apt-get -y install jq pigz

sudo echo "\$nrconf{restart} = 'a'" >> /etc/needrestart/needrestart.conf

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

adduser work <<EOF
2pflTMq-
2pflTMq-






EOF

cat >> /etc/security/limits.conf  << 'EOF'
root soft nofile 65535
root hard nofile 65535
* soft nproc unlimited
* hard nproc unlimited
* soft nofile 655350
* hard nofile 655350
EOF

ufw allow 80/tcp
ufw allow 443/tcp
ufw allow ssh
ufw allow 11500:11508/tcp
ufw allow 11600:11608/tcp
ufw deny from 66.132.159.0/24
ufw deny from 162.142.125.0/24
ufw deny from 167.94.138.0/24
ufw deny from 167.94.145.0/24
ufw deny from 167.94.146.0/24
ufw deny from 167.248.133.0/24
ufw deny from 199.45.154.0/24
ufw deny from 199.45.155.0/24
ufw deny from 206.168.34.0/24
ufw deny from 206.168.35.0/24
ufw deny from 2602:80d:1000:b0cc:e::/80
ufw deny from 2620:96:e000:b0cc:e::/80
ufw deny from 2602:80d:1003::/112
ufw deny from 2602:80d:1004::/112

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p