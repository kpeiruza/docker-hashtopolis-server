#!/bin/bash

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
	if [ ! -z "$MYSQL_ROOT_PASSWORD" ]
	then
		mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST -e "CREATE database $MYSQL_DB;" || exit 5
	fi

	MYSQL="mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST $MYSQL_DB"
	$MYSQL -e "SELECT 'PING';" &>/dev/null

	if [ $? -ne 0 ]
	then
		echo "Failed connecting to the database...."
		echo $MYSQL
		exit 3
	fi

	MYSQL="mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST $MYSQL_DB"
#	IMPORT DB
	$MYSQL < /var/www/html/install/hashtopolis.sql
	if [ $? -ne 0 ]
	then
		echo "DB Import Failed!!!"
		exit 12
	fi
#	CONFIGURE DB
#	RUN SETUP & ADD USER
	cd /var/www/html/inc || echo "Failed cd"
	sed -i "s/MYSQL_USER/$MYSQL_USER/" db.php
	sed -i "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/" db.php
	sed -i "s/MYSQL_DB/$MYSQL_DB/" db.php
	sed -i "s/MYSQL_HOST/$MYSQL_HOST/" db.php
	sed -i "s/MYSQL_PORT/$MYSQL_PORT/" db.php
	sed -i "s/PENDING/true/" db.php
	cd ../install || echo "Failed cd"
	/usr/bin/php setup.php
#	CREATE USER & PASSWORD
	if [ -z "$H8_USER" ]
	then
		echo "No login/password provided, using admin/admin"
		H8_USER="admin"
		H8_PASS="admin"
	fi

	if [ -z "$H8_PASS" ]
	then
		echo "Please, provide H8_USER & H8_PASS or leave both unsetted to use admin/admin"
		exit 11
	fi
	sed -i "s/H8_USER/$H8_USER/" adduser.php
	sed -i "s/H8_PASS/$H8_PASS/" adduser.php
	sed -i "s/H8_EMAIL/$H8_EMAIL/" adduser.php

	/usr/bin/php adduser.php
	echo "Setup finished, pruning /install folder"
	rm -rf /var/www/html/install
fi

/usr/sbin/apachectl -DFOREGROUND