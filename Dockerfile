FROM php:7.3-fpm-alpine
MAINTAINER dekmabot@gmail.com

# Timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# System
RUN apk update && apk upgrade
RUN apk add --no-cache composer bash wget supervisor
RUN apk add --update mysql-client nginx nano libjpeg libpng-dev libxml2-dev imap-dev libzip-dev freetype imagemagick
RUN apk add php-curl php-mbstring mysql-client

# Php
RUN docker-php-ext-install pdo pdo_mysql gd dom imap json iconv fileinfo xml bcmath zip

# Laravel
RUN mkdir -p /var/run/sshd /var/log/supervisor /var/www/bootstrap/cache /var/www/storage/logs /var/www/storage/framework
RUN chmod -R 0777 /var/www/bootstrap/cache /var/www/storage/logs /var/www/storage/framework

# Configs
ADD php-laravel.conf /etc/php7/fpm/pool.d/laravel.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx-host.conf /etc/nginx/conf.d/default.conf
ADD entrypoint.sh /docker-entrypoint.sh
ADD cron.txt /var/www/cron.txt

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

WORKDIR /var/www

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
