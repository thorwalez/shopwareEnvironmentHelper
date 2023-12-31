#!/bin/bash

.DEFAULT_GOAL:=help

.PHONY: help build start stop logs restart exec down clean db-backup db-restore

today := $(shell date +%Y-%m-%d)
DOCKER_COMPOSE_COMMAND := @docker compose -f ${PWD}/docker-compose.yml
DOCKER_PLATFORM := docker run --rm -v ${PWD}:/external -w /external -it ubuntu:latest sh starter.sh

dbShopware ?= $(shell bash -c 'read -p "Wie heißt die Datei [Beispiel: shopware.sql]?" dbShopware; echo $$dbShopware')

transferNetworkNameLine := $(shell grep "extern-network" env | awk -F ':' '{print $$2}')


help: ## Display this help.

	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#################
# Base Commands #
#################
build: ## Build the shopware environment
	mkdir -p plugins backup uploads
	@if [ ! -f docker-compose.yml.dist ] ; then ${DOCKER_PLATFORM} ; fi
	${DOCKER_COMPOSE_COMMAND} up -d

start: ## Start the shopware container

	${DOCKER_COMPOSE_COMMAND} start

stop: ## Stop the shopware container

	${DOCKER_COMPOSE_COMMAND} stop

logs: ## Tail container logs with -n 100

	${DOCKER_COMPOSE_COMMAND} logs -f --tail=100

restart: ## Restart shopware container

	${DOCKER_COMPOSE_COMMAND} restart

exec: ## Exec into the container

	${DOCKER_COMPOSE_COMMAND} exec shop bash

exec-root: ## root Exec into the container

	${DOCKER_COMPOSE_COMMAND} exec -uroot shop bash

down: ## Destroy Container

	${DOCKER_COMPOSE_COMMAND} down -v

update: ## Image Dockware

	docker pull -a dockware/play

db-backup: ## Database backup create

	${DOCKER_COMPOSE_COMMAND} exec -uroot shop mysqldump -uroot -proot shopware | gzip > ./backup/shopware_$(today).sql.gz

db-restore: ## restore Database to shopware

	${DOCKER_COMPOSE_COMMAND} exec -uroot -T shop mysql -uroot -proot shopware< ./backup/$(dbShopware)

db-persist: ## Shopware Database persist on host

	mkdir -p ./db-persist && docker cp shop:/var/lib/mysql/ ./db-persist

shopware-persist: ## Shopware source code persist on host

	mkdir -p ./src-persist && docker cp shop:/var/www/html/. ./src-persist

shopware-version: ## Shows Shopware version and saves it in root

	${DOCKER_COMPOSE_COMMAND} exec shop bin/console --version
	${DOCKER_COMPOSE_COMMAND} exec shop bin/console --version >versionInUse.md

MAKEFLAGS = -s
clear: ## Clear Root project Folder

	if [ -n "$(docker ps -q -f name=shop)" ]; then \
		${DOCKER_COMPOSE_COMMAND} down -v --rmi local --remove-orphans; \
	fi

	rm -rf docker-compose.* env

	if docker images | grep "dockware" > /dev/null; then \
        docker images | grep "dockware" | awk '{print $3}' | xargs docker rmi -f; \
    fi

create-network: ## creates external link network for container

	if ! docker network ls | grep "$(transferNetworkNameLine)"  > /dev/null; then \
       docker network create --driver=bridge $(transferNetworkNameLine);  \
    fi
