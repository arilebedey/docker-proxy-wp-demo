#!/bin/bash

read_secret() {
    cat "/run/secrets/$1" 2>/dev/null || echo ""
}

DB_ROOT_PASS=$(read_secret db_password)
DB_ADMIN_PASS=$(read_secret wp_admin_password)
DB_USER_PASS=$(read_secret wp_user_password)

if [ -z "$DB_ROOT_PASS" ] || [ -z "$DB_USER_PASS" ] || [ -z "$DB_ADMIN_PASS" ]; then
    echo "Error: Missing required secrets."
    exit 1
fi

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_ADMIN}'@'%' IDENTIFIED BY '${DB_ADMIN_PASS}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_ADMIN}'@'%';

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
GRANT SELECT, INSERT, UPDATE, DELETE ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    echo "Database initialized with users: root, ${MYSQL_ADMIN}, ${MYSQL_USER}"
else
    echo "Database already exists. Skipping initialization."
fi

exec mysqld --user=mysql
