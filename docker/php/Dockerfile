FROM php:8.5.12-fpm

# Mailpitのsendmail互換バイナリを取り込む(PHPのmail()をMailpitへ転送するため)
COPY --from=axllent/mailpit:v1.33.1 /mailpit /usr/local/bin/mailpit

COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/wp-cli.yml /usr/local/etc/wp-cli.yml

ARG WP_CLI_VERSION=2.12.0
ARG IMAGICK_VERSION=3.8.1

# set -eux
# -e 何かのエラーが発生した時点で処理中断
# -u 未定義の変数使用でエラー
# -x 実行したコマンドを標準エラー出力
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    apt-utils \
    default-mysql-client \
    ghostscript \
    git \
    less \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    pkg-config \
    unzip \
    vim \
    zip \
  ; \
  # PHP 8.5ではgdのconfigureオプション指定は不要
  # opcacheはPHP 8.5から本体に組み込まれたため、ここでは導入しない
  docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    zip \
  ; \
  # Imagickはバージョンを固定してpeclから導入する
  pecl install "imagick-${IMAGICK_VERSION}"; \
  docker-php-ext-enable imagick; \
  rm -rf /tmp/pear /var/lib/apt/lists/*

# wp-cli(公式SHA512でチェックサム検証)
RUN set -eux; \
  curl -fsSL -o /usr/local/bin/wp \
    "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar"; \
  curl -fsSL -o /tmp/wp.sha512 \
    "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar.sha512"; \
  echo "$(cut -d' ' -f1 /tmp/wp.sha512)  /usr/local/bin/wp" | sha512sum -c -; \
  rm /tmp/wp.sha512; \
  chmod +x /usr/local/bin/wp

# mysqlクライアント設定(wp dbなどが自己署名証明書で失敗しないようにする)
COPY ./docker/php/mysql-client.cnf /etc/mysql/conf.d/99-dev-client.cnf

# 任意のUIDで実行してもwp-cliが動くよう、設定とキャッシュの場所を固定する
ENV WP_CLI_CONFIG_PATH=/usr/local/etc/wp-cli.yml \
    WP_CLI_CACHE_DIR=/tmp/.wp-cli/cache \
    WP_CLI_PACKAGES_DIR=/tmp/.wp-cli/packages

# コンテナでの作業ディレクトリを指定(docker compose exec php bashを利用した時のカレントディレクトリになる)
WORKDIR /var/www/html
