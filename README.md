# Booster

Yet another dockerized develop environment for Laravel developers.

# Requirements

- make
- docker
- docker-compose
- internet-connection

# Environment

- Alpine    [3.4]
- PHP       [5.6.25]
- NginX     [1.10.1]
- MariaDB   [10.1.17]
- Redis     [3.2.0]

# Usage

```bash
# first you should install [make](https://www.gnu.org/software/make/)
cd my-laravel-app
git clone https://github.com/doubear/booster.git
cd booster
# edit app.env
make
make install
make start # run any booster services
make stop  # stop booster services
```

Now open `http://127.0.0.1:8080` to see if normal access, please ensure the `booster` is in the Laravel project. And the MySQL root password is `root`, it can be configured in `docker-compose.yml`.

# License

Based on MIT license. Thanks Google Translate.
