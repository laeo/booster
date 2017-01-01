include app.env
.PHONY: init install start stop enter deploy db.migrate db.refresh db.seed
init: app.env
	@echo "***PLEASE NOTE THAT EDIT YOUR app.env FILE***"

ifneq ("$(wildcard docker-compose.yml)","")
	@echo "try to stop existed container..."
	@docker-compose -p $(APP_NAME) stop
endif

	@echo "initializing docker-compose.yml file..."
	@echo 'version: "2"' > docker-compose.yml
	@echo 'services:' >> docker-compose.yml
	@echo '  web:' >> docker-compose.yml
	@echo '    build: "web"' >> docker-compose.yml
	@echo '    volumes:' >> docker-compose.yml
	@echo '      - "..:/www"' >> docker-compose.yml
	@echo '      - "./web/logs:/var/log/web"' >> docker-compose.yml
	@echo '    ports:' >> docker-compose.yml
	@echo "      - \"$(WEB_ADDR):80\"" >> docker-compose.yml
	@echo '    links:' >> docker-compose.yml
	@echo '      - db' >> docker-compose.yml
	@echo '      - redis' >> docker-compose.yml
	@echo '  db:' >> docker-compose.yml
	@echo '    build: "mysql"' >> docker-compose.yml
	@echo '    volumes:' >> docker-compose.yml
	@echo '      - "./mysql/data:/var/lib/mysql"' >> docker-compose.yml
	@echo '    environment:' >> docker-compose.yml
	@echo '      MYSQL_ROOT_PASSWORD: "root"' >> docker-compose.yml
	@echo '      MYSQL_DATABASE: "app"' >> docker-compose.yml

ifdef MYSQL_ADDR
ifneq ($(MYSQL_ADDR),'')
	@echo '    ports:' >> docker-compose.yml
	@echo "      - \"$(MYSQL_ADDR):3306\"" >> docker-compose.yml
endif
endif

	@echo '  redis:' >> docker-compose.yml
	@echo '    build: "redis"' >> docker-compose.yml

ifdef REDIS_ADDR
ifneq ($(REDIS_ADDR),'')
	@echo '    ports:' >> docker-compose.yml
	@echo "      - \"$(REDIS_ADDR):6379\"" >> docker-compose.yml
endif
endif

	@echo "booster initialize has been finished."
	@echo "NOTE: now you can use \"make install\" to up your service!"

install: app.env
	@docker-compose -p $(APP_NAME) build

start: app.env
	@docker-compose -p $(APP_NAME) up -d

stop: app.env
	@docker-compose -p $(APP_NAME) stop

enter: app.env
	@docker-compose -p $(APP_NAME) exec web sh

deploy: app.env
	@chmod -R 0755 ../
	@chmod -R 0777 ../storage ../bootstrap
	@docker-compose -p $(APP_NAME) exec web composer install
	@docker-compose -p $(APP_NAME) exec web cp .env.example .env
	@docker-compose -p $(APP_NAME) exec web composer key:generate
	@docker-compose -p $(APP_NAME) exec web -i 's/DB_HOST=.*/DB_HOST=db/g' .env
	@docker-compose -p $(APP_NAME) exec web -i 's/DB_DATABASE=.*/DB_DATABASE=app/g' .env
	@docker-compose -p $(APP_NAME) exec web -i 's/DB_USERNAME=.*/DB_USERNAME=root/g' .env
	@docker-compose -p $(APP_NAME) exec web -i 's/DB_PASSWORD=.*/DB_PASSWORD=root/g' .env
	@docker-compose -p $(APP_NAME) exec web -i 's/CACHE_DRIVER=.*/CACHE_DRIVER=redis/g' .env
	@docker-compose -p $(APP_NAME) exec web -i 's/SESSION_DRIVER=.*/SESSION_DRIVER=redis/g' .env
	@docker-compose -p $(APP_NAME) exec web -i 's/QUEUE_DRIVER=.*/QUEUE_DRIVER=redis/g' .env
	@docker-compose -p $(APP_NAME) exec web echo -e 'REDIS_HOST=redis\nREDIS_PORT=6379' >> .env
	@echo 'deployment has been finished.'
	@echo '***PLEASE NOTE THAT EDIT YOUR config/database.php AND CHANGE THE redis SECTION***'

db.migrate: app.env
	@docker-compose -p $(APP_NAME) exec web php artisan migrate

db.refresh: app.env
	@docker-compose -p $(APP_NAME) exec web php artisan migrate:refresh

db.seed: app.env
	@docker-compose -p $(APP_NAME) exec web php artisan db:seed