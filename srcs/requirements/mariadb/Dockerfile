FROM alpine:3.22.0

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb mariadb-client bash

RUN rm -f /etc/my.cnf.d/mariadb-server.cnf

COPY conf/50-server.cnf /etc/my.cnf.d/50-server.cnf
COPY tools/init-db.sh /usr/bin/init-db.sh

RUN chmod +x /usr/bin/init-db.sh

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
    chmod 755 /var/lib/mysql /run/mysqld

EXPOSE 3306

CMD ["init-db.sh"]
