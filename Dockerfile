FROM ubuntu:18.04
MAINTAINER Kenneth Peiruza <kenneth@floss.cat>

RUN	export DEBIAN_FRONTEND=noninteractive && \
	apt update && \
	apt -y upgrade && \
	apt -y install apache2 libapache2-mod-php php-mysql php php-gd php-pear php-curl git pwgen mariadb-client && \
	apt -y install gcc make autoconf libc-dev pkg-config libmcrypt-dev php7.2-dev && \
	pecl install mcrypt-1.0.1 && \
	echo 'extension=mcrypt.so' >> /etc/php/7.2/apache2/php.ini && \
	cd /var/www/ && \
	rm -f html/index.html && \
	git clone https://github.com/s3inlc/hashtopolis.git && \
	mv hashtopolis/src/* html/ && \
	chown -R www-data:www-data /var/www/html && \
	ln -sf /dev/stdout /var/log/apache2/access.log && \
	ln -sf /dev/sterr /var/log/apache2/error.log && \
	echo "ServerName Hashtopolis" > /etc/apache2/conf-enabled/serverName.conf && \
	rm -rf /var/lib/apt /var/lib/dpkg /var/cache/apt /usr/share/doc /usr/share/man /usr/share/info
COPY	entrypoint.sh 	/
COPY	db.php /var/www/html/inc
COPY	setup.php adduser.php /var/www/html/install/

EXPOSE 80
ENTRYPOINT [ "/entrypoint.sh" ]
