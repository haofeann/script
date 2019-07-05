#!/bin/bash
mkdir -p /data/kcoin
mkdir -p /data/logs/app/

tar -xvf /tmp/apache-tomcat-8.5.29.tar.gz -C /usr/local/kcoin/
rm -rf /usr/local/kcoin/apache-tomcat-8.5.29/webapps/*
mv /tmp/*.war /usr/local/kcoin/apache-tomcat-8.5.29/webapps/