FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.19

# set version label
LABEL maintainer="Cyrus"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    rsync \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-fileinfo \
    php83-fpm \
    php83-gd \
    php83-intl \
    php83-mbstring \
    php83-mysqli \
    php83-pdo \
    php83-pdo_mysql \
    php83-opcache \
    php83-openssl \
    php83-phar \
    php83-session \
    php83-tokenizer \
    php83-xml \
    php83-xmlreader \
    php83-xmlwriter \
    php83-bcmath \
    php83-pecl-redis \
    php83-pecl-imagick \
    php83-zip \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libwebp \
    libwebp-dev && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php83/php-fpm.d/www.conf && \
  grep -qxF 'clear_env = no' /etc/php83/php-fpm.d/www.conf || echo 'clear_env = no' >> /etc/php83/php-fpm.d/www.conf && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php83/php-fpm.conf && \
  printf "post_max_size = 50M\nupload_max_filesize = 50M" > /etc/php83/conf.d/50_size_limit.ini && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

COPY root/ /

EXPOSE 80 443
