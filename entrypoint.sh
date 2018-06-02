#!/bin/bash

#	Try to connect to mysql 3 times
ATTEMPTS=12
#	Wait 5 secconds before trying to reconnect
INTERVAL=5

function getRandom() {
	dd if=/dev/urandom bs=32768 count=1 2>/dev/null | openssl sha512  | grep stdin | cut -d " " -f2 | cut -c1-64
}

if [ -n "$MYSQL_ENV_MYSQL_ROOT_PASSWORD" ]
then
	MYSQL_ROOT_PASSWORD="$MYSQL_ENV_MYSQL_ROOT_PASSWORD"
fi

if [ -n "$MYSQL_ENV_MYSQL_USER" ]
then
	MYSQL_USER="$MYSQL_ENV_MYSQL_USER"
fi

if [ -n "$MYSQL_ENV_MYSQL_PASSWORD" ]
then
	MYSQL_PASSWORD="$MYSQL_ENV_MYSQL_PASSWORD"
fi

if [ -n "$MYSQL_ENV_MYSQL_DATABASE" ]
then
	MYSQL_DB="$MYSQL_ENV_MYSQL_DATABASE"
fi

if [ -n "$MYSQL_PORT_3306_TCP_ADDR" ]
then
	MYSQL_HOST="$MYSQL_PORT_3306_TCP_ADDR"
fi

if [ -z "$MYSQL_HOST" ]
then
	MYSQL_HOST="mysql"
fi

if [ -z "$MYSQL_DB" ]
then
	MYSQL_DB="hashtopolis"
fi

if [ -z "$MYSQL_PORT" ]
then
	MYSQL_PORT="3306"
fi

if [ ! -z "$MYSQL_ROOT_PASSWORD" ]
then
	MYSQL_USER="root"
	MYSQL_PASSWORD=$MYSQL_ROOT_PASSWORD
fi

if grep "PENDING" /var/www/html/inc/db.php &>/dev/null
then
#	CHECK MYSQL AVAILABILITY
	MYSQL="mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST $MYSQL_DB"
	$MYSQL -e "SELECT 'PING';" &>/dev/null
		echo "Used: $MYSQL"
	ERROR=$?

	while [ $ERROR -ne 0 -a $ATTEMPTS -gt 1 ]
	do
		ATTEMPTS=$(($ATTEMPTS-1))
		echo "Failed connecting to the database.... Sleeping 5s and retrying $ATTEMPTS more."
		sleep $INTERVAL
		$MYSQL -e "SELECT 'PING';" &>/dev/null
		ERROR=$?
	done

	if [ $ERROR -ne 0 ]
	then
		echo "Could not connect to mysql. Please double check your settings and mysql's availability."
		echo "Used: $MYSQL"
#		exit 20
	fi

#	CREATE DB
	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST -e "CREATE database $MYSQL_DB;"
	if [ $? -ne 0 ]
	then
		echo "Failed to create the database... insufficient access??? already exists??? this shouldn't happen, I'm doing setup..."
		exit 21
	fi
#	IMPORT DB
	$MYSQL < /var/www/html/install/hashtopolis.sql
	if [ $? -ne 0 ]
	then
		echo "DB Import Failed!!!"
		exit 12
	fi
#	CONFIGURE DB
#	RUN SETUP & ADD USER
sed -i -e "s/MYSQL_USER/$MYSQL_USER/" -e "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/" -e "s/MYSQL_DB/$MYSQL_DB/" -e "s/MYSQL_HOST/$MYSQL_HOST/" -e "s/PENDING/true/" /var/www/html/inc/db.php || exit 8
#	-e "s/MYSQL_PORT/$MYSQL_PORT/"  <--- fails and I don't get why...
/usr/bin/php /var/www/html/install/setup.php
#	CREATE USER & PASSWORD
if [ -z "$H8_USER" ]
then

	H8_USER=$(getRandom)
	echo -e "No login provided, generating random username:\n\t$H8_USER\n\nIf you don't like it, check the docs first, this is for your own security. admin/admin on a cracking tool sounds a bit funny.\n"
fi

if [ -z "$H8_PASS" ]
then
	H8_PASS=$(getRandom)
	echo -e "Your random password is: $H8_PASS\n\n\n"
fi

sed -i -e "s/H8_USER/$H8_USER/" -e  "s/H8_PASS/$H8_PASS/" -e "s/H8_EMAIL/$H8_EMAIL/" /var/www/html/install/adduser.php

/usr/bin/php /var/www/html/install/adduser.php

#	PHP MAIL SETTINGS
if [ -n "$PHP_MAIL_HOST" ]
then
	sed -i "s/^SMTP.*/SMTP = $PHP_MAIL_HOST/" /etc/php/7.0/apache2/php.ini
fi


if [ -n "$PHP_MAIL_PORT" ]
then
	sed -i "s/^smtp_port.*/smtp_port = $PHP_MAIL_PORT/" /etc/php/7.0/apache2/php.ini
fi


if [ -n "$PHP_MAIL_FROM" ]
then
	sed -i "s/^;sendmail_from.*/sendmail_from = $PHP_MAIL_FROM/" /etc/php/7.0/apache2/php.ini
fi


echo "Setup finished, pruning /install folder"
	rm -rf /var/www/html/install
fi

/usr/sbin/apachectl -DFOREGROUND
