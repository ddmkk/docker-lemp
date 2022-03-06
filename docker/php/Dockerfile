FROM php:7.4.1-fpm

COPY ./docker/php/php.ini /usr/local/etc/app/php.ini

RUN apt-get update \
    && apt-get install -y \
    git \
    zip \
    unzip \
    vim \
    && docker-php-ext-install pdo_mysql bcmath

# コンテナでの作業ディレクトリを指定(docker-compose exec app bashを利用した時のカレントディレクトリになる)
WORKDIR /var/www/html
