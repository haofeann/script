#!/bin/bash
apt-get update
apt -y install libgd-dev
apt -y install libpcre3 libpcre3-dev
apt-get -y install openssl libssl-dev 
apt-get -y install zlib1g zlib1g-dev
apt-get -y install build-essential
apt -y install libgl1-mesa-dev


wget http://nginx.org/download/nginx-1.22.1.tar.gz
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
wget https://www.openssl.org/source/openssl-3.2.0.tar.gz
wget http://www.zlib.net/zlib-1.3.1.tar.gz


tar -xvf pcre-8.45.tar.gz  -C  /usr/local/src/
tar -xvf zlib-1.3.1.tar.gz  -C /usr/local/src/
tar -xvf openssl-3.2.0.tar.gz -C /usr/local/src/

tar -xvf nginx-1.22.1.tar.gz
cd nginx-1.22.1


mkdir -p /data/logs/nginx

mkdir -p \
  /data/upload \
  /data/webdata/welcome/build \
  /data/website/
echo hello > /data/webdata/welcome/build/index.html
chown -R work:work /data/webdata/ /data/website/ /data/upload


./configure --prefix=/usr/local/applications/nginx/ \
--with-pcre \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_auth_request_module \
--with-http_image_filter_module \
--with-http_slice_module \
--with-mail \
--with-threads \
--with-file-aio \
--with-stream \
--with-mail_ssl_module \
--with-stream_ssl_module \
--with-stream \
--with-pcre=/usr/local/src/pcre-8.45


make  && make install 

echo "# nginx" >> /etc/profile
echo "export PATH=\$PATH:/usr/local/applications/nginx/sbin" >> /etc/profile
cd ..
rm -rf nginx-1.22.1  nginx-1.22.1.tar.gz  openssl-3.2.0.tar.gz  pcre-8.45.tar.gz zlib-1.3.1.tar.gz 


cat > /usr/lib/systemd/system/nginx.service << 'EOF'
[Unit]
Description=nginx
After=network.target

[Service]
Type=forking
PIDFile=/usr/local/applications/nginx/logs/nginx.pid
ExecStartPost=/bin/sleep 0.1
ExecStart=/usr/local/applications/nginx/sbin/nginx
ExecReload=/usr/local/applications/nginx/sbin/nginx -s reload
ExecStop=/usr/local/applications/nginx/sbin/nginx -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
