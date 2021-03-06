#/bin/sh
apk --update add wget nginx php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-sqlite3 php7-mysqlnd \
	php7-redis php7-xmlrpc php7-common php7-zlib php7-zip php7-openssl php7-ftp php7-memcached php7-posix php7-json \
	php7-mbstring php7-bcmath php7-iconv php7-intl php7-session php7-sysvsem php7-ftp php7-xml php7-xmlreader php7-xmlwriter \
	php7-dom php7-sockets php7-exif
set -x \ && adduser -u 82 -D -S -G www-data www-data
sed -i 's/127.0.0.1:9000/9000/g' /etc/php7/php-fpm.d/www.conf \
	&& sed -i 's/disable_functions =/disable_functions =passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen/g' /etc/php7/php.ini \
	&& sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /etc/php7/php.ini \
	&& sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php7/php.ini \
	&& sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php7/php.ini \
	&& sed -i 's/user = nobody/user = www-data/g' /etc/php7/php-fpm.d/www.conf \
	&& sed -i 's/group = nobody/group = www-data/g' /etc/php7/php-fpm.d/www.conf \
	&& sed -i 's/user nginx/user www-data/g' /etc/nginx/nginx.conf
wget -O /etc/nginx/conf.d/default.conf "https://raw.githubusercontent.com/ljm000/mylnmp/master/default.conf"
wget -O /var/www/wordpress.tar.gz "https://cn.wordpress.org/latest-zh_CN.tar.gz"
tar -zxvf /var/www/wordpress.tar.gz -C /var/www && mv /var/www/wordpress /var/www/html
rm /var/www/wordpress.tar.gz
chown -R www-data:www-data /var/www/*
mkdir -p /run/nginx
nginx && php-fpm7 -F
