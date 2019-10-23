#!/bin/bash

company=$1
porject=$2
basedir=/usr/local/$company

function init_dict()
{
    if [ ! -d "/data/$company" ]; then
        echo "创建基础目录"
        mkdir -p /data/$company
        mkdir -p /data/${company}data
    else
        echo "基础目录已存在"
    fi
}

function check_dict() # 检查是否存在相应的目录
{
	if [ ! -L "$basedir" ];then
		echo "软连接不存在，软连接"
        init_dict
        ln -s /data/$company $basedir
	else
        init_dict
		echo "软连接已存在"
	fi
}

function check_java()
{
	grep "jdk1.8.0_161" /etc/profile >/dev/null
	if [ $? -eq 0 ]; then
	    echo "java环境已配置"
	else
	    echo "java环境未配置，开始配置java环境"
        check_dict
        install_java
	fi
}

function check_tomcat()
{
    if [ ! -d "${basedir}/tomcat-${company}-${porject}" ]; then
        echo "项目不存在，开始安装"
        install_tomcat
    else 
        echo "项目已始安装"

    fi
}

function install_tomcat()
{
    check_dict
    tar -xf /data/apache-tomcat-8.5.29.tar.gz -C ${basedir}
    cd ${basedir}
    mv apache-tomcat-8.5.29 tomcat-${company}-${porject}
    tomcat_dir=${basedir}/tomcat-${company}-${porject}
    check_tomcat_config
    echo "清理webapps"
    rm -rf $tomcat_dir/webapps/*
    echo "复制war包到项目"
    cp /data/${porject}.war $tomcat_dir/webapps/
    chown -R work:work $tomcat_dir
    mkdir -p /data/logs/app/
    chown -R work:work /data/logs/
}

function install_java()
{
    if [ ! -d "${basedir}/jdk1.8.0_161" ];then
        echo "java文件未解压，开始解压"
        tar -xf /data/jdk-8u161-linux-x64.tar.gz  -C ${basedir}
    fi
    echo -e "\n\n# java\nexport JAVA_HOME=${basedir}/jdk1.8.0_161/\nexport JRE_HOME=${basedir}/jdk1.8.0_161/jre" >> /etc/profile
    echo -e "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar:\$JRE_HOME/lib">> /etc/profile
    echo -e "export PATH=\$JAVA_HOME/bin:\$PATH">> /etc/profile
    source /etc/profile
}

function check_tomcat_config()
{
    sed -i '163i        <Valve className="org.apache.catalina.valves.RemoteIpValve"' $tomcat_dir/conf/server.xml
    if [[ $? != 0 ]]; then
        echo "insert server.html failed"
        exit
    fi
    sed -i '164i                           remoteIpHeader="X-Forwarded-For"' $tomcat_dir/conf/server.xml
    if [[ $? != 0 ]]; then
        echo "insert server.html failed"
        exit
    fi
    sed -i '165i                           protocolHeader="X-Forwarded-Proto"' $tomcat_dir/conf/server.xml
    if [[ $? != 0 ]]; then
        echo "insert server.html failed"
        exit
    fi
    sed -i '166i                           protocolHeaderHttpsValue="https"/>' $tomcat_dir/conf/server.xml
    if [[ $? != 0 ]]; then
        echo "insert server.html failed"
        exit
    fi
    sed -i '150i       <Context path="" docBase="'${porject}'" reloadable="true" />' $tomcat_dir/conf/server.xml
    if [[ $? != 0 ]]; then
        echo "insert server.html failed"
        exit
    fi
    cd $tomcat_dir/conf
    sed -i s/8005/$server_port/g server.xml
    if [[ $? != 0 ]]; then
        echo "replace port failedd"
        exit
    fi
    sed -i s/8080/$http_port/g server.xml
    if [[ $? != 0 ]]; then
        echo "replace port failedd"
        exit
    fi
    sed -i s/8009/$ajp_port/g server.xml       
    if [[ $? != 0 ]]; then
        echo "replace port failedd"
        exit
    fi
}

case $porject in
    "exchange-web-api")
        server_port=8111
        http_port=8160
        ajp_port=8211
        check_java
        check_tomcat;;
    "exchange-app-api")
        server_port=8115
        http_port=8164
        ajp_port=8215
        check_java
        check_tomcat;;
    "exchange-open-api")
        server_port=8109
        http_port=8158
        ajp_port=8209
        check_java
        check_tomcat;;
    "exchange-otc-api")
        server_port=8116
        http_port=8165
        ajp_port=8216
        check_java
        check_tomcat;;
    "finance")
        server_port=8108
        http_port=8157
        ajp_port=8208
        check_java
        check_tomcat;;
    "operate-web")
        server_port=8107
        http_port=8156
        ajp_port=8207
        check_java
        check_tomcat;;
    "otc-chat")
        server_port=8113
        http_port=8162
        ajp_port=8213
        check_java
        check_tomcat;;
    "otc-job")
        server_port=8114
        http_port=8163
        ajp_port=8214
        check_java
        check_tomcat;;
    "schedule-web")
        server_port=8105
        http_port=8154
        ajp_port=8205
        check_java
        check_tomcat;;
    "stats-job")
        server_port=8106
        http_port=8155
        ajp_port=8206
        check_java
        check_tomcat;;
    "exchange-otc-app-api")
        server_port=8110
        http_port=8159
        ajp_port=8212
        check_java
        check_tomcat;;
    "jdk-18161")
        check_java;;
    "tomcat")
        check_tomcat;;
    *) echo "项目包名错误" ; 
        exit 2; ;;
esac