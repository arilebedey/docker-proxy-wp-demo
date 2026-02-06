#!/bin/sh

read_secret() {
    cat "$1" 2>/dev/null || echo ""
}

MYSQL_ADMIN_PASSWORD=$(read_secret "${MYSQL_ADMIN_PASSWORD_FILE}")
MYSQL_USER_PASSWORD=$(read_secret "${MYSQL_USER_PASSWORD_FILE}")
WP_ADMIN_PASSWORD=$(read_secret "${WP_ADMIN_PASSWORD_FILE}")
WP_USER_PASSWORD=$(read_secret "${WP_USER_PASSWORD_FILE}")

echo "Waiting for MariaDB..."

until mysqladmin ping -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_USER_PASSWORD}" >/dev/null 2>&1; do
    sleep 1
done

echo "MariaDB is ready."

mkdir -p /srv/www/wordpress
cd /srv/www/wordpress

if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."
    wp core download --allow-root
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_ADMIN}" \
        --dbpass="${MYSQL_ADMIN_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root

    wp config set DB_USER "${MYSQL_USER}" --allow-root
    wp config set DB_PASSWORD "${MYSQL_USER_PASSWORD}" --allow-root
fi

chmod 755 /srv /srv/www /srv/www/wordpress

find /srv/www/wordpress -type d -exec chmod 755 {} \;
find /srv/www/wordpress -type f -exec chmod 644 {} \;
chown -R www-data:www-data /srv/www/wordpress

sed -i 's|listen = 127.0.0.1:9000|listen = 9000|' /etc/php83/php-fpm.d/www.conf

echo "Starting PHP-FPM..."
mkdir -p /var/lib/php83/sessions
chown -R www-data:www-data /var/lib/php83/sessions
chmod 755 /var/lib/php83/sessions

# PID 1
exec php-fpm83 -F
