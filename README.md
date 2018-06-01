# docker-hastopolis-server
Hastopolis Server Docker image

Easy to launch and highly configurable hashtopolis server on a Docker!

=RUN:=
# docker run --name mysql  -e MYSQL_ROOT_PASSWORD=my-secret-pw  -d mysql:5.7
# docker run  -e MYSQL_ROOT_PASSWORD=my-secret-pw -e H8_USER="admin" -e H8_PASS="admin" -e H8_EMAIL="youremail@example.com" --link mysql:mysql -d -p 80:80 kpeiruza/hashtopolis

Connect your agents to hashtopolis.

*Remember to map Hashtopolis /var/www/html into a persistent volume, as well as mysql's /var/lib/mysql for usage in production.*
