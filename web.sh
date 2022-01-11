#!/bin/sh
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0;37m'
WH='\033[1;37m'

systemctl start lighttpd && systemctl enable lighttpd && \
systemctl status lighttpd && sleep 3 && \
echo "${GREEN}DONE${NC}." && \
sed -i "/listen = /run/php/php7.4-fpm.sock/c\dlisten = 127.0.0.1:9000" \
/etc/php/7.4/fpm/pool.d/www.conf && \
sed -i "/\"bin-path\"/c\d\t\t\"host\" => 127.0.0.1" \
/etc/lighttpd/conf-available/15-fastcgi-php.conf && \
sed -i "/\"socket\"/c\d\t\t\"port\" => 9000" \
/etc/lighttpd/conf-available/15-fastcgi-php.conf && \
lighty-enable-mod fastcgi && lighty-enable-mod fastcgi-php && \
systemctl restart lighttpd && systemctl restart php7.4-fpm && \
read DB_NAME?"Your DB: "
read USERNAME?"Your username: "
read PASSWORD?"Your password: "
read LOCALHOST?"Your hostname: "
sed -i "/define( 'DB_NAME', 'database_name_here' );/c\define( 'DB_NAME', '$DB_NAME' );" \
/var/www/html/wordpress/wp-config.php && \
sed -i "/define( 'DB_USER', 'username_here' );/c\define( 'DB_USER', '$USERNAME' );" \
/var/www/html/wordpress/wp-config.php && \
sed -i "/define( 'DB_PASSWORD', 'password_here' );/c\define( 'DB_PASSWORD', '$PASSWORD' );" \
/var/www/html/wordpress/wp-config.php && \
sed -i "/define( 'DB_HOST', 'localhost' );/c\define( 'DB_HOST', '$LOCALHOST' );" \
/var/www/html/wordpress/wp-config.php && \
#sed -i "/define( 'DB_CHARSET', 'utf8' );/c\define( 'DB_CHARSET', 'utf8' );" \
#/var/www/html/wordpress/wp-config.php && \
echo "${GREEN}DONE${NC}."
