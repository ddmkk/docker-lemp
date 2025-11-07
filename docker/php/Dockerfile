# FROM php:8.1-fpm
# FROM php:8.3.12-fpm
FROM php:8.4.14-fpm

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
    pkg-config \
  ; \
  \
  # php 8.4では不要。むしろエラーが発生する
  # docker-php-ext-configure gd --enable-gd \
    # --with-freetype \
    # --with-jpeg \
    # --with-webp \
  # ; \
  docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    zip \
  ; \
  \
  # pecl install imagick-3.6.0; \
  # docker-php-ext-enable imagick; \
  # rm -r /tmp/pear
  # ✅ GitHubのImagick最新版を取得してビルド（PHP 8.4対応）
  git clone https://github.com/Imagick/imagick.git /tmp/imagick; \
  cd /tmp/imagick; \
  phpize; \
  ./configure; \
  make -j"$(nproc)"; \
  make install; \
  docker-php-ext-enable imagick; \
  rm -rf /tmp/imagick

# コンテナでの作業ディレクトリを指定(docker-compose exec app bashを利用した時のカレントディレクトリになる)
WORKDIR /var/www/html
