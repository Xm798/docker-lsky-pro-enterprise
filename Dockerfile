FROM xm798/lsky-pro-enterprise-baseimage:latest

# set version label
LABEL maintainer="Cyrus"

COPY lsky-pro.zip /tmp/lsky-pro.zip

RUN \
  echo "**** install lsky pro ****" && \
  mkdir -p /app/src/ && \
  unzip /tmp/lsky-pro.zip -d /app/src/ && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*
