#!/bin/bash

if [ ! -f /configured ]; then

# Installation Racktables
tar -zxf /racktables/RackTables-*.tar.gz -C /tmp
cd /tmp/RackTables-*/ && make install && find /etc/apache2 -type f -print0 \
  | xargs -0 sed -i 's@/var/www/html@/usr/local/share/RackTables/wwwroot@g;s@Directory /var/www@Directory /usr/local/share/RackTables@g' \
  && touch /usr/local/share/RackTables/wwwroot/inc/secret.php \
  && chmod 666 /usr/local/share/RackTables/wwwroot/inc/secret.php \
  && chown -R www-data: /usr/local/share/RackTables/wwwroot

## set database racktables
cat <<EOF > /usr/local/share/RackTables/wwwroot/inc/secret.php
<?php
\$pdo_dsn = 'mysql:host=$DB_HOST;dbname=$DB_NAME';
\$db_username = '$DB_USER';
\$db_password = '$DB_PASS';
#\$user_auth_src = 'database';
#\$require_local_account = TRUE;
?>
EOF

# set permission
chown www-data: /usr/local/share/RackTables/wwwroot/inc/secret.php
chmod 400 /usr/local/share/RackTables/wwwroot/inc/secret.php

# setup finished.
touch /configured

fi

exec apache2-foreground
#apache2ctl -D FOREGROUND 