#!/bin/bash
mkdir -p /data/kcoin
mkdir -p /data/logs/app/
chown -R work:work /data/logs/
ln -s /data/kcoin /usr/local/kcoin
tar -xvf /tmp/apache-tomcat-8.5.29.tar.gz -C /usr/local/kcoin/
rm -rf /usr/local/kcoin/apache-tomcat-8.5.29/webapps/*
mv /tmp/*.war /usr/local/kcoin/apache-tomcat-8.5.29/webapps/
mv /tmp/config.properties /usr/local/kcoin/apache-tomcat-8.5.29/conf
mv /tmp/server.xml /usr/local/kcoin/apache-tomcat-8.5.29/conf -f