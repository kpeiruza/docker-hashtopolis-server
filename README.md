# Hastopolis Server Docker image

Easy to launch and highly configurable hashtopolis server on a Docker.

__RUN:__
- *docker run --name mysql  -e MYSQL_ROOT_PASSWORD=my-secret-pw  -d mysql:5.7*
- *docker run -e H8_USER="your-admin" -e H8_PASS="your-password" -e H8_EMAIL="youremail@example.com" --link mysql:mysql -d -p 80:80 kpeiruza/hashtopolis*

This is compatible with reading Docker Mysql environment variables, so you can even launch the service with a random username and password.

- *docker run --name mydb  -e MYSQL_ROOT_PASSWORD=PleaseChangeMe  -d mysql:5.7*
- *docker run --link mydb:mysql -d -p 80:80 kpeiruza/hashtopolis*


Or simply use the docker-compose.yaml: *docker-compose up -d*

The compose deals with persistence on all levels: database, config, dictionaries ... If something isn't persisting, please, feel free to open an issue.

__*If you find problems using latest version of this Docker, please run "kpeiruza/hashtopolis:stable", which is based on php5 and Debian:9 and has been working for ages. This newer "latest" version is using PHP 7.2 on Ubuntu 18.04.*__


Supported environment configuration variables:
- __MYSQL_HOST__, defaults to *mysql*
- __MYSQL_PORT__, defaults *3306* <-- *not working, fixed to 3306*
- __MYSQL_DB__, defaults to *Hashtopolis*
- __MYSQL_ROOT_PASSWORD__
- __MYSQL_USER__, you don't need it if you have the root password
- __MYSQL_PASSWORD__, cannot be unset if set MYSQL_USER.
- __H8_USER__, username for Hastopolis administrator account to be created on first run. <__Defaults to a 256 char random string!!!__>
- __H8_PASS__, password for Hashtopolis, <__Defaults to a 256 char random string!!!__>
- __H8_EMAIL__
- __PHP_MAIL_HOST__, smtp server, defaults to php.ini
- __PHP_MAIL_PORT__, smtp port, defaults to php.ini
- __PHP_MAIL__FROM, defaults to php.ini



__Remember to map mysql's /var/lib/mysql for usage in production. Hashtopolis server's upload folders should be mapped as well.__
- *docker run --name mysql -v ./mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw  -d mysql:5.7*
- *docker run -v ./inc:/var/www/html/inc -v ./import:/var/www/html/import -v ./files:/var/www/html/files -e MYSQL_ROOT_PASSWORD=my-secret-pw -e H8_USER="admin" -e H8_PASS="admin" -e H8_EMAIL="youremail@example.com" --link mysql:mysql -d -p 80:80 kpeiruza/hashtopolis*

Please provide feedback about any trouble encountered as well as your success deploying a farm of thousands of nodes :-)

Enjoy it!

-------------------------
Try it out as well with this docker-compose.yaml 

..version: '3.7'
..
..services:
.. 
....mysql:
......image: mysql:5.7
......volumes:
........- mysql:/var/lib/mysql
......environment:
........MYSQL_ROOT_PASSWORD: verySecret
..
....hashtopolis:
......image: kpeiruza/hashtopolis:latest
......environment:
........H8_USER: root
........H8_PASS: verySecret
........H8_EMAIL: root@localhost
........MYSQL_HOST: mysql
........MYSQL_PORT: 3306
........MYSQL_ROOT_PASSWORD: verySecret
........MYSQL_DB: hashtopolis
......volumes:
........- import:/var/www/html/import
........- files:/var/www/html/files
........- inc:/var/www/html/inc
........- locks:/var/www/html/inc/utils/locks
......ports:
........- "8000:80"
..
..volumes:
....import: {}
....files: {}
....inc: {}
....locks: {}
....mysql: {}
..
