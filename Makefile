.PHONY: install create-dirs clone-magento2 up clean-install

install: create-dirs clone-magento2 up

up:
	docker-compose up -d;

create-dirs:
	mkdir -p $(PWD)/.docker/mysql/data;

clone-magento2:
	git clone --branch 2.3-develop --depth=1 git@github.com:magento/magento2.git magento2;

clean-install:
	sudo rm -Rf $(PWD)/.docker/mysql;
	sudo rm -Rf $(PWD)/magento2;