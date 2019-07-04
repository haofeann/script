#!/bin/bash
yum -y install vim lrzsz ntp unzip zip wget
mkdir -p /data
echo "n
p
1


w
" | fdisk /dev/vdb && mkfs.ext4 /dev/vdb1


echo '/dev/vdb1 /data ext4 defaults 0 0'>>/etc/fstab
mount -a 