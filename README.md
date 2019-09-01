# Magento2 Docker Develop Install

This repository is dedicated to magento 2.3-develop for bug fixes and make features.

[Docker MySQL](https://hub.docker.com/_/mysql)

[Docker PHPMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin)

[Docker Nginx](https://hub.docker.com/_/nginx)

[Docker PHP 7.2.20-alpine](https://github.com/00F100/magento-php/tree/master/alpine/7.2.20/fpm)

### Install

```
$ make install
```

### HTTPs

- Storefront: https://localhost.magento.com
- Admin: https://localhost.magento.com/admin
- Username: `admin`
- Password: `123123q`

### Console PHP + Composer + NPM

```
$ make console
```

### Up Docker

```
$ make up
```

### Down Docker

```
$ make down
```

### Simple data

```
$ make simple-data
```