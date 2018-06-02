# Hastopolis Server Docker image

Easy to launch and highly configurable hashtopolis server on a Docker.

__RUN:__
- *docker run --name mysql  -e MYSQL_ROOT_PASSWORD=my-secret-pw  -d mysql:5.7*
- *docker run -e H8_USER="admin" -e H8_PASS="adminPasswordisTooLame" -e H8_EMAIL="youremail@example.com" --link mysql:mysql -d -p 80:80 kpeiruza/hashtopolis*

This is compatible with reading Docker Mysql environment variables, so you can even launch the service with a random mysql password, random username and random passwords :-)

- *docker run --name mydb  -e MYSQL_RANDOM_ROOT_PASSWORD=yes  -d mysql:5.7*
- *docker run --link mydb:mysql -d -p 80:80 kpeiruza/hashtopolis*

Supported environment configuration variables:
- __MYSQL_HOST__, defaults to *mysql*
- __MYSQL_PORT__, defaults *3306* <-- *not working, fixed to 3306*
- __MYSQL_DB__, defaults to *Hashtopolis*
- __MYSQL_ROOT_PASSWORD__
- __MYSQL_USER__, you don't need it if you have the root password
- __MYSQL_PASSWORD__, cannot be unset if set MYSQL_USER
- __H8_USER__, username for Hastopolis administrator account to be created on first run. Defaults to *admin*
- __H8_PASS__, password for Hashtopolis, defaults to *adminAsPasswordWasTooLame*
- __H8_EMAIL__



__Remember to map mysql's /var/lib/mysql for usage in production. Hashtopolis server's upload folders should be mapped as well.__
- *docker run --name mysql -v ./mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw  -d mysql:5.7*
- *docker run -v ./hashtopolis:/var/www/html -e MYSQL_ROOT_PASSWORD=my-secret-pw -e H8_USER="admin" -e H8_PASS="admin" -e H8_EMAIL="youremail@example.com" --link mysql:mysql -d -p 80:80 kpeiruza/hashtopolis*


Please provide feedback about any trouble encountered as well as your success deploying a farm of thousands of nodes :-)

Enjoy it!

