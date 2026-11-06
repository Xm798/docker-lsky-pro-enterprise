# 3.22 is the last LSIO base on PHP 8.4; 3.23+ ships PHP 8.5, which Laravel 9 was never tested against.
FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.22 AS base

# set version label
LABEL maintainer="Cyrus"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    rsync \
    php84-ctype \
    php84-curl \
    php84-dom \
    php84-fileinfo \
    php84-fpm \
    php84-gd \
    php84-intl \
    php84-mbstring \
    php84-mysqli \
    php84-pdo \
    php84-pdo_mysql \
    php84-opcache \
    php84-openssl \
    php84-phar \
    php84-session \
    php84-tokenizer \
    php84-xml \
    php84-xmlreader \
    php84-xmlwriter \
    php84-bcmath \
    php84-pecl-redis \
    php84-pecl-imagick \
    php84-zip && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php84/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php84/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php84/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php84/php-fpm.conf && \
  printf "post_max_size = 50M\nupload_max_filesize = 50M" > /etc/php84/conf.d/50_size_limit.ini && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

COPY root/ /

EXPOSE 80 443

# The licensed release cannot be published, so CI pushes only the `base` stage
# and this stage is built locally next to lsky-pro.zip.
FROM base

COPY lsky-pro.zip /tmp/lsky-pro.zip

RUN \
  echo "**** install lsky pro ****" && \
  mkdir -p /app/src/ && \
  unzip -q /tmp/lsky-pro.zip -d /app/src/ && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*
