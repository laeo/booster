FROM alpine:3.4

MAINTAINER doubear admin@doubear.com

RUN apk -f update
RUN apk -f add redis

COPY redis.conf /etc/redis.conf

EXPOSE 6379

CMD ["/usr/bin/redis-server", "/etc/redis.conf"]
