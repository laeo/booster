#!/bin/sh
DATADIR=`/usr/bin/mysqld --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }'`

if [ ! -d "${DATADIR}mysql" ]; then
    # should initialize
    /usr/bin/mysql_install_db
    /usr/bin/mysqld --user=root &
    PID=$!
    echo -e "PID: $PID"

    # waiting for mysqld online
    pong='1'
    while [ $pong -eq '1' ]; do
        echo -e "waiting for mysqld online...\n"
        /usr/bin/mysqladmin -uroot --password='' ping
        pong=$?
        sleep 1s
    done

    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        MYSQL_ROOT_PASSWORD=''
        echo -e "WARN: mysql root password will be set to empty.\n"
    fi

    /usr/bin/mysql -uroot <<EOF
DELETE FROM mysql.user;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

    if [ ! -z "$MYSQL_DATABASE" ]; then
        /usr/bin/mysqladmin -uroot --password="$MYSQL_ROOT_PASSWORD" create $MYSQL_DATABASE
    fi

    kill -s TERM $PID
fi

# waiting for mysqld offline
pong='0'
while [ $pong -eq '0' ]; do
    echo -e "waiting for mysqld offline...\n"
    /usr/bin/mysqladmin -uroot --password='' ping
    pong=$?
    sleep 1s
done

echo -e "starting db service...\n"
/usr/bin/mysqld --user=root
