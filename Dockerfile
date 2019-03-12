FROM ubuntu:latest
MAINTAINER Tung Dang <dangqtung@gmail.com>
RUN apt-get -qq update

RUN apt-get install -y build-essential zip wget gcc make curl libpcre3-dev openssl libssl-dev gettext zlib1g zlib1g-dev vim
 
RUN wget -O /tmp/nginx-1.14.2.tar.gz http://nginx.org/download/nginx-1.14.2.tar.gz && \
    wget -O /tmp/v2.1-20190302.tar.gz https://github.com/openresty/luajit2/archive/v2.1-20190302.tar.gz  && \
    wget -O /tmp/lua-nginx-module-0.10.14.tar.gz https://github.com/openresty/lua-nginx-module/archive/v0.10.14.tar.gz && \
    wget -O /tmp/ngx_devel_kit-0.3.1.tar.gz https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz && \
    wget -O /tmp/ngx_cache_purge-2.3.tar.gz http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz && \
    ( cd /tmp/ && tar zxf nginx-1.14.2.tar.gz ) && \
    ( cd /tmp/ && tar zxf v2.1-20190302.tar.gz ) && \
    ( cd /tmp/ && tar zxf ngx_cache_purge-2.3.tar.gz ) && \
    ( cd /tmp/ && tar xzf lua-nginx-module-0.10.14.tar.gz ) && \
    ( cd /tmp/ && tar xzf ngx_devel_kit-0.3.1.tar.gz ) && \
    rm -f /tmp/*.tar.gz && \
    rm -f /tmp/*.zip && \
    ( bash && \
      cd /tmp/luajit2-2.1-20190302 && \
      make && \
      make install ) && \
    ( cd /tmp/nginx-1.14.2 && \
      export LUAJIT_LIB=/usr/local/lib && \
      export LUAJIT_INC=/usr/local/include/luajit-2.1 && \
      ./configure --prefix=/etc/nginx --with-ld-opt=-Wl,-rpath,/usr/local/lib --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-threads --with-http_v2_module --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-file-aio --add-module=../ngx_devel_kit-0.3.1rc1 --add-module=../lua-nginx-module-0.10.14 --add-module=../ngx_cache_purge-2.3 && \
            make -j4 && \
            make install ) && \
    ln -s /usr/local/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2 && \
    mkdir -p /etc/nginx/sites && \
    mkdir -p /etc/nginx/certs && \
    mkdir -p /var/cache/nginx/client_temp && \ 
    rm -rf /tmp/*

#COPY ./nginx.conf /etc/nginx/nginx.conf
WORKDIR /etc/nginx
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]
EXPOSE 80 80
CMD ["nginx"]
