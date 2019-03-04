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
                     mysql \
  && docker-php-ext-install gd \
                            snmp \
                            pdo_mysql \
                            mcrypt \
                            bcmath \
                            mbstring \
                            #ldap \
                            pcntl \
  && rm -rf /var/lib/apt/lists/*

## -- Copy File --
COPY ./racktables /racktables

COPY ./init-db.sql /init-db.sql

RUN \
  tar -zxf /racktables/RackTables-*.tar.gz -C /tmp && \
  cd /tmp/RackTables-*/ && make install && find /etc/apache2 -type f -print0 \
  | xargs -0 sed -i 's@/var/www/html@/usr/local/share/RackTables/wwwroot@g;s@Directory /var/www@Directory /usr/local/share/RackTables@g' \
  && touch /usr/local/share/RackTables/wwwroot/inc/secret.php \
  && chmod a=rw '/usr/local/share/RackTables/wwwroot/inc/secret.php' \
  && chown -R www-data: /usr/local/share/RackTables/wwwroot
  
## --- Start ---
COPY startup.sh /startup.sh
RUN dos2unix /startup.sh

ENTRYPOINT ["/startup.sh"]

EXPOSE 80 443