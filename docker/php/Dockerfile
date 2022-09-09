FROM php:8.1-fpm

# COPY ./docker/php/php.ini /usr/local/etc/app/php.ini
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini

# set -eux
# -e 何かのエラーが発生した時点で処理中断
# -u 未定義の変数使用でエラー
# -x 実行したコマンドを標準エラー出力
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ghostscript \
  ; \
  rm -rf /var/lib/apt/lists/*

RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    apt-utils \
    git \
    zip \
    unzip \
    vim \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
  ; \
  \
  docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
  ; \
  docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    zip \
  ; \
  pecl install imagick-3.6.0; \
  docker-php-ext-enable imagick; \
  rm -r /tmp/pear


# コンテナでの作業ディレクトリを指定(docker-compose exec app bashを利用した時のカレントディレクトリになる)
WORKDIR /var/www/html
