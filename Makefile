-include .env
UID ?= $(shell id -u)
GID ?= $(shell id -g)
export UID GID

DC = docker compose -f docker-compose.yml

.PHONY: local locald up down build restart logs ps shell wp

# フォアグラウンドで起動
local up:
	$(DC) up

# バックグラウンドで起動
locald upd:
	$(DC) up -d

build:
	$(DC) build

down:
	$(DC) down

restart:
	$(DC) restart

logs:
	$(DC) logs -f

ps:
	$(DC) ps

# phpコンテナのシェルに入る
shell:
	$(DC) exec php bash

# wp-cliを実行する 例: make wp ARGS="plugin list"
wp:
	$(DC) exec php wp $(ARGS)
