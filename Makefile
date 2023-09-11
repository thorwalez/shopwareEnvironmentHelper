#!/bin/bash

.DEFAULT_GOAL:=help

.PHONY: help build deploy start stop logs restart shell up

DOCKER_COMPOSE_COMMAND := @docker-compose -f ${PWD}/docker-compose.yml
DOCKER_COMPOSE_COPY := cp ${PWD}/docker-compose.yml.dist ${PWD}/docker-compose.yml
DOCKER_PLATFORM := docker run --rm -v$(PWD):/external -w/external -it ubuntu:latest sh starter.sh

help: ## Display this help.

	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#################
# Base Commands #
#################
build: ## Build the shopware environment

	@if [ ! -f docker-compose.yml.dist ] ; then ${DOCKER_PLATFORM} ; fi

	@if [ ! -f docker-compose.yml ] ; then ${DOCKER_COMPOSE_COPY} ; fi

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

down: ## Destroy Container

	${DOCKER_COMPOSE_COMMAND} down -v

MAKEFLAGS = -s
clean: ## Clean Root project Folder

	rm -rf docker-compose.*
	docker images | grep "dockware/dev" | awk '{print $3}' | xargs docker rmi -f
