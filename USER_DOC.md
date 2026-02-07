## Overview

This project runs a secure WordPress website with three services:

- **NGINX**: Web server handling HTTPS traffic (port 443)
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database storing website data

## Managing Credentials

All passwords are stored in the `secrets/` directory:

- `db_password.txt` — MariaDB root password
- `wp_admin_password.txt` — WordPress admin password
- `wp_user_password.txt` — WordPress editor password

If passwords aren't set, `make` will prompt you to write passwords to those files.

## Starting & Stopping

Build and start:

```bash
make
```

Start all services:

```bash
make up
```

Stop services:

```bash
make down
```

Restart everything from scratch:

```bash
make re
```

## Accessing the Website

1. Add this line to `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):

   ```
   127.0.0.1  alebedev.42.fr
   ```

2. Open your browser and visit:
   ```
   https://alebedev.42.fr
   ```

## Admin Panel

Access WordPress admin at:

```
https://alebedev.42.fr/wp-admin
```

**Login credentials:**

- Username: `wp_owner`
- Password: Check `secrets/wp_admin_password.txt`

## Checking Services

Verify all containers are running:

```bash
docker ps
```

You should see three containers: `mariadb`, `wordpress`, `nginx`
