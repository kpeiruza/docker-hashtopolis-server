# Hastopolis Server Docker image

[Hashtopolis](https://github.com/hashtopolis/server) is a multi-platform client-server tool for distributing hashcat tasks to multiple computers. The main goals for Hashtopolis's development are portability, robustness, multi-user support, and multiple groups management. This repository is a dockerized version of Hashtopolis using MariaDB.

## RUNNING IT

### Preparation
Clone this repository to your machine:

```
git clone https://github.com/kpeiruza/docker-hashtopolis-server.git
cd docker-hashtopolis-server/
```

Then, edit the `docker-compose.yaml` to fit your needs (using `nano`, `vi`, `vim`, or `emacs` if your'e feeling adventurous)

### Build the image (optional)
Build the Hashtopolis image from scratch:
```
docker build -t htp:latest
```

### Run it!
Bring the whole thing up:
```
docker compose up -d
```
or on older systems:

```
docker-compose up -d
```

This is the preferred method of running this, and includes volume persistence.

NOTE: the first time you run this, MariaDB will initialize its database. This can take a while. You can monitor progress using `docker logs <IMAGE ID> -f`. The Hashtopolis container should return `Setup finished, pruning /install folder!` when it is done.

### Run it the hard(er) way!
Run using individual `docker` commands:

```
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=changemeRoot mariadb:10.11
```

```
docker run -d \
  -e MYSQL_ROOT_PASSWORD=changemeRoot \
  -e MYSQL_DB=hashtopolis \
  -e MYSQL_HOST=mysql \
  -e MYSQL_PORT=3306 \
  -e H8_USER=root \
  -e H8_PASS=changemeHTPuser \
  -e H8_EMAIL="root@localhost" \
  --link mysql:mysql -p 80:80 \
  kpeiruza/hashtopolis
```

NOTE: `--link` has been deprecated, and may be removed from `docker` in the future. Additionally, these commands do not deal with persistence. If you need this, you'll have to add it where necessary using the `-v` switch. 

## ENVIRONMENT VARIABLES

#### `MYSQL_HOST`
This is a host where your database is hosted. Defaults to `mysql`.

#### `MYSQL_PORT`
The port where `mysql` listens on. Defaults `3306` (<-- not working, fixed to 3306)

#### `MYSQL_DB`
The name of your database. Defaults to `hashtopolis`.

#### `MYSQL_ROOT_PASSWORD`
This specifies the password that will be set for the MariaDB `root` superuser account. This should be the same value for your `hashtopolis` container.

#### `MYSQL_USER`
You can set your own username to be used for database access if not using the `root` user. You don't need it if you are using the root password.

#### `MYSQL_PASSWORD`
Password for `MYSQL_USER`. Cannot be unset if `MYSQL_USER` is defined.

#### `H8_USER`
Username for the Hastopolis administrator account to be created on first run. Defaults to a 256 char random string.

#### `H8_PASS`
Password for the Hashtopolis administrator account. Defaults to a 256 char random string.

#### `H8_EMAIL`
Email for the Hashtopolis administrator account.

#### `PHP_MAIL_HOST`
SMTP server, defaults to php.ini

#### `PHP_MAIL_PORT`
SMTP port, defaults to php.ini

#### `PHP_MAIL_FROM`
Sender for email, defaults to php.ini

#### `HTP_MEMORY_LIMIT`
Allows setting the memory limit on the server (default 128M).

#### `HTP_UPLOAD_MAX_SIZE`
Sets the maximum allows upload file size (default 2M).

#### `HTP_SERVER_NAME`
Sets a server (sub)domain name (default none).

## PERSISTENCE

Remember to map MariaDB's /var/lib/mysql for usage in production. Hashtopolis upload folders should be mapped as well.

- `mysql:/var/lib/mysql`
- `import:/var/www/html/import`
- `files:/var/www/html/files`
- `inc:/var/www/html/inc`
- `locks:/var/www/html/inc/utils/locks`

-------------------------
Please provide feedback about any trouble encountered as well as your success in deployment. Any feedback with regards to improvements is also highly appreciated.

Enjoy!
