#!/bin/bash
mkdir -p /data/kcoin
ln -s /data/kcoin /usr/local/kcoin
tar -xvf /data/jdk-8u161-linux-x64.tar.gz -C /usr/local/kcoin

echo '' >>/etc/profile
echo '' >>/etc/profile
echo '#java' >>/etc/profile
echo 'export JAVA_HOME=/usr/local/kcoin/jdk1.8.0_161' >>/etc/profile
echo 'export JRE_HOME=/usr/local/kcoin/jdk1.8.0_161/jre' >>/etc/profile
echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >>/etc/profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >>/etc/profile
