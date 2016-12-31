include app.env
init: app.env
	@echo "PLEASE NOTE THAT MODIFY YOUR app.env FILE!"
	@echo "initializing docker-compose.yml file..."
	@echo 'version: "2"' > docker-compose.yml
	@echo 'services:' >> docker-compose.yml
	@echo '  web:' >> docker-compose.yml
	@echo '    build: "web"' >> docker-compose.yml
	@echo '    volumes:' >> docker-compose.yml
	@echo '      - "..:/www"' >> docker-compose.yml
	@echo '      - "./web/logs:/var/log/web"' >> docker-compose.yml
	@echo '    ports:' >> docker-compose.yml
	@echo "      - \"${WEB_ADDR}:80\"" >> docker-compose.yml
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
	@echo '    ports:' >> docker-compose.yml
	@echo "      - \"${MYSQL_ADDR}:3306\"" >> docker-compose.yml
	@echo '  redis:' >> docker-compose.yml
	@echo '    build: "redis"' >> docker-compose.yml
	@echo '    ports:' >> docker-compose.yml
	@echo "      - \"${REDIS_ADDR}:6379\"" >> docker-compose.yml
	@echo "booster initialize has been finished."
	@echo "NOTE: now you can use \"make install\" to up your service!"

install: app.env
	docker-compose build

start: app.env
	docker-compose up -d -p ${APP_NAME}