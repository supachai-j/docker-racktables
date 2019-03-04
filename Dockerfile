FROM php:5-apache
MAINTAINER Supachai Jaturaprom <jaturaprom.su@gmail.com>

## -- Install Package --
RUN \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y dos2unix \
                     libfreetype6-dev \
                     libjpeg62-turbo-dev \
                     libmcrypt-dev \
                     libsnmp-dev \
                     snmp \
                     libldb-dev \
  && docker-php-ext-install gd \
                            snmp \
                            pdo_mysql \
                            mcrypt \
                            bcmath \
                            mbstring \
                            ldap \
                            pcntl \
  && rm -rf /var/lib/apt/lists/*

## -- Copy File --
COPY ./racktables /racktables

## --- Start ---
COPY startup.sh /startup.sh
RUN dos2unix /startup.sh

ENTRYPOINT ["/startup.sh"]

EXPOSE 80 443