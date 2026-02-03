_This project has been created as part of the 42 curriculum by alebedev._

# Description

This is a project aiming to create a few independent services using docker.

Those services are:

1. A MariaDB instance
2. A nginx reverse proxy
3. A WordPress instance

# Project Description

## Docker vs. Virtual Machines

Docker shares the host OS kernel (containerization), instead of full virtualization

## Secrets vs. Environment Variables

Secrets is a Docker concept. They are files that are mounted onto the container at `/run/secrets`.
Docker with not log them in `docker inspect` and `docker logs`.

Environment variables are key-value pairs string. They are readable in docker log.

One should contain non-sensitive configuration settings, the other can contain credentials.

## Docker Network vs Host Network

Docker containers get their own IP addresses. Only exposed ports are accessible outside.

Host network cannot hide port from other processes. Once its open its open to the local network and beyond if your router forwards your ports to other networks (routers) or program redirects traffic somewhere.

## Docker Volumes vs Bind Mounts

Both allow us to persist data after the container stops or deletes.

Named volumes work the same on Linux, Mac, Windows. Bind mounts have OS-specific path issues and hard-coded paths break when teammates use different machines. Bind mounts are a convenience and don't need volume definition in compose file. They should not be used in production.

# Instructions

```
make all      # Setup, build, and start all services
make setup    # Create data directories
make build    # Build Docker images
make up       # Start all services
make down     # Stop services
make clean    # Stop services and remove volumes/images
make re       # Restart everything (clean + all)
```

# Resources

[https://tuto.grademe.fr/inception/](https://tuto.grademe.fr/inception/)

[Docker Engine Storage Volumes](https://docs.docker.com/engine/storage/volumes/)

[Docker Build CI GitHub Actions Secrets](https://docs.docker.com/build/ci/github-actions/secrets/)

[Debian on Docker Hub](https://hub.docker.com/_/debian)

[Host X is not allowed to connect to this MySQL server](https://stackoverflow.com/questions/54030469/host-x-is-not-allowed-to-connect-to-this-mysql-server)

[GitHub Actions: How to handle GitHub Secrets and use them in Docker container](https://stackoverflow.com/questions/77840895/github-actions-how-to-handle-github-secrets-and-use-them-in-docker-container)

[ER_HOST_NOT_PRIVILEGED: Docker container fails to connect to MariaDB](https://stackoverflow.com/questions/47270505/er-host-not-privileged-docker-container-fails-to-connect-to-mariadb)

[Cloudera: CEM Install Configure MariaDB](https://docs.cloudera.com/cem/2.2.0/installation/topics/cem-install-configure-mariadb.html)

[MariaDB: Get Started with MariaDB](https://mariadb.com/get-started-with-mariadb/)

[ServerFault: Correct WordPress Nginx PHP-FPM Configuration](https://serverfault.com/questions/696341/correct-wordpress-nginx-php-fpm-configuration)

# AI Usage

AI was used to:

1. Find commands flags, getting a first grasp on configurations during research
2. Get quick answers on how Docker and the different modules work
3. Format markdown and redact parts of the documentation
4. Check files for inconsistencies / potential enhancements / obvious errors
