DATA_DIR = $(HOME)/data

all: setup build up

setup:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@bash setup-passwords.sh

build:
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker compose -f srcs/docker-compose.yml down -v --rmi all
	sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

re: clean all

nuke-docker: clean
	docker system prune -a --volumes -f

.PHONY: all setup build up down clean re nuke-docker
