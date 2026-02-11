## Prerequisites

- Docker & Docker Compose installed
- Linux / MacOS with sudo persmissions (for Docker)
- Change `USERNAME_42` in `srcs/.env` to the current user of your OS

## Environment Setup

1. Clone the repository

2. Create the secrets directory and files:

```bash
mkdir -p secrets
echo "your_db_root_password" > secrets/db_password.txt
echo "your_wp_admin_password" > secrets/wp_admin_password.txt
echo "your_wp_user_password" > secrets/wp_user_password.txt
chmod 600 secrets/*.txt
```

Or running `make setup` will create those files. Then you only need to write passwords to files through editor.

3. Add the domain to your local `/etc/hosts`:

```
127.0.0.1 alebedev.42.fr
```

## Build & Launch

```bash
make all          # Setup data dirs, build images, start containers
make build        # Rebuild Docker images
make setup        # Create db and password dirs and files
make up           # Start running containers
make down         # Stop containers
make clean        # Stop and remove volumes/images
make re           # Clean + all
make nuke-docker  # Clean any cached data in Docker
```

## Managing Containers & Volumes

Inside `srcs` dir, run:

```bash
docker compose build                                   # Build all images
docker compose up -d                                   # Start in background
docker compose down                                    # Stop services
docker compose down -v                                 # Stop and remove volumes

docker compose ps                                      # List running containers
docker compose logs -f                                 # Stream all logs
docker compose logs nginx                              # Service-specific logs

docker exec -it wordpress sh                           # Shell into WordPress container
docker exec -it mariadb mariadb -u root -p             # MariaDB CLI

docker volume ls                                       # List volumes
docker volume inspect inception_mariadb_data           # Volume details
```

## Accessing the DB

```sh
docker exec -it mariadb mariadb -u user -p -h localhost
```

This runs the MariaDB client inside the container named `mariadb` to connect to the database as the root user, with `-it` enabling interactive terminal access and `-p` prompting for the password.

Checking that users were created: `SELECT user, host FROM mysql.user;`

## Data Persistence

Both named volumes bind data to `/home/alebedev/data`:

- **MariaDB**: `/home/alebedev/data/mariadb` → persists database files
- **WordPress**: `/home/alebedev/data/wordpress` → persists site files and wp-cli.phar

Data survives container restart (`make down && make up`). To destroy all data, run `make clean`.

## Troubleshooting

**Website won't load:**

- Ensure WordPress container is ready: `docker logs wordpress -f`
- Check that `alebedev.42.fr` is in `/etc/hosts`
- Run `make re` and look for errors
- Verify containers are running: `docker ps`
- Check container logs (see instructions above)

**Database connection error:**

- Ensure MariaDB container is ready: `docker logs mariadb`
- Wait 5–10 seconds after startup
