FROM debian:stretch-slim
MAINTAINER Kenneth Peiruza <kenneth@floss.cat>
RUN	apt update && \
	apt -y upgrade && \
	apt install -y apache2 libapache2-mod-php php-mcrypt php-mysql php php-gd php-pear php-curl git pwgen mysql-client && \
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
