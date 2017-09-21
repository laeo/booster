# Booster
Yet another dockerized develop environment for Laravel developers.

# Usage
```bash
# first you should install [make](https://www.gnu.org/software/make/)
cd my-laravel-app
wget https://raw.githubusercontent.com/doubear/booster/master/docker-compose.yml
docker-compose up -d
```

Now open `http://127.0.0.1:8000` to view your website.

#Configuration
You can easily configure the MySQL in your `.env` file.

```bash
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=root
DB_PASSWORD=root
```

The Redis service is included by default, you can also configure it in your `.env` file.

```bash
REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379
```

# License

Based on MIT license. Thanks Google Translate.
