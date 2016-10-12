FROM alpine:3.4
MAINTAINER doubear admin@doubear.com

RUN apk -f update
RUN apk -f add php5 php5-fpm php5-curl php5-common php5-openssl php5-sqlite3 php5-opcache php5-phar php5-bcmath php5-json php5-dom php5-posix php5-sysvsem php5-pdo php5-intl php5-pdo_pgsql php5-pcntl php5-xml php5-gd php5-exif php5-mcrypt php5-iconv php5-sysvmsg php5-pdo_mysql php5-sysvshm php5-pgsql php5-zip php5-xmlrpc php5-zlib php5-calendar php5-shmop php5-ctype

RUN mkdir -p /var/log/web && chmod 0777 /var/log/web
COPY conf/php-fpm.conf /etc/php5/fpm/php-fpm.conf

RUN wget -qO /usr/bin/composer http://getcomposer.org/composer.phar && chmod ugo+x /usr/bin/composer
RUN composer self-update

RUN apk -f add nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /www/public && chmod -R 0755 /www

VOLUME /www /var/log/web

WORKDIR /www

EXPOSE 80

CMD /usr/bin/php-fpm && /usr/sbin/nginx -g 'daemon off;'
