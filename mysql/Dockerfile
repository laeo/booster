FROM alpine:3.4

MAINTAINER doubear admin@doubear.com

RUN apk -f update
RUN apk -f add mysql mysql-client

RUN rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /run/mysqld && chmod 0777 /run/mysqld
COPY my.cnf /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY entry.sh /entry.sh

RUN chmod 0777 /entry.sh

EXPOSE 3306

ENTRYPOINT ["/entry.sh"]
