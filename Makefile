.PHONY: docker-nice install create-dirs clone-magento2 magento-setup-install console fix-hosts tunning up down clean-install compile deploy-front cache simple-data

install: docker-nice fix-hosts create-dirs clone-magento2 up tunning magento-setup-install

up:
	docker-compose up -d;

down:
	docker-compose down;

create-dirs:
	mkdir -p $(PWD)/.docker/mysql/data;

clone-magento2:
	git clone --branch 2.3-develop --depth=1 git@github.com:magento/magento2.git magento2;

magento-setup-install:
	docker container run -it --rm --user www-data -v $(PWD)/.docker/php/cli/php.ini:/opt/php/lib/php.ini -v $(PWD)/magento2:/var/www/html --network net_magento2 00f100/magento-php-cli:7.2.20-alpine sh -c "composer install; bin/magento setup:install --admin-firstname=Webjump --admin-lastname=Develop --admin-email=developer@webjump.com.br --admin-user=admin --admin-password=123123q --base-url=http://localhost.magento.com --backend-frontname=admin --db-host=magento2-database --db-name=magento2 --db-user=root --db-password=root --use-rewrites=1 --use-secure=1 --base-url-secure=https://localhost.magento.com --use-secure-admin=1 "

console:
	docker container run -it --rm --user www-data -v $(PWD)/.docker/php/cli/php.ini:/opt/php/lib/php.ini -v $(PWD)/magento2:/var/www/html --network net_magento2 00f100/magento-php-cli:7.2.20-alpine

fix-hosts:
	sudo sed -i -e '/127.0.0.1 localhost.magento.com/d' /etc/hosts;
	sudo bash -c "echo \"127.0.0.1 localhost.magento.com\" >> /etc/hosts";

docker-nice:
	sudo renice -20 $(shell pidof dockerd);
	sudo bash -c "ls /proc/$(shell pidof dockerd)/task | xargs renice -20";

tunning:
	docker update --cpu-shares 4 --cpus 4 --cpuset-cpus 0-3 magento2-php-fpm-pool1;
	docker update --cpu-shares 4 --cpus 4 --cpuset-cpus 0-3 magento2-php-fpm-pool2;
	docker update --cpu-shares 4 --cpus 4 --cpuset-cpus 0-3 magento2-php-fpm-pool3;
	docker update --cpu-shares 4 --cpus 4 --cpuset-cpus 0-3 magento2-database;
	docker update --cpu-shares 4 --cpus 4 --cpuset-cpus 0-3 magento2-phpmyadmin;
	docker update --cpu-shares 4 --cpus 4 --cpuset-cpus 0-3 magento2-nginx;

clean-install:
	sudo rm -Rf $(PWD)/.docker/mysql;
	sudo rm -Rf $(PWD)/magento2;

simple-data:
	docker container run -it --rm --user www-data -v $(PWD)/.docker/php/cli/php.ini:/opt/php/lib/php.ini -v $(PWD)/magento2:/var/www/html --network net_magento2 00f100/magento-php-cli:7.2.20-alpine sh -c "git clone --branch 2.3-develop --depth=1 https://github.com/magento/magento2-sample-data.git; php -f magento2-sample-data/dev/tools/build-sample-data.php -- --ce-source=/var/www/html; bin/magento setup:upgrade;"