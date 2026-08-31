SHELL := /bin/sh

COMPOSE := docker compose --env-file compose/.env -f compose/compose.yaml

.PHONY: local-config local-down local-env local-logs local-ps local-up local-verify

local-env:
	@test -f compose/.env || cp compose/.env.example compose/.env
	@echo "Local environment file is available at compose/.env"

local-config:
	@test -f compose/.env || { echo "Run 'make local-env' first." >&2; exit 1; }
	$(COMPOSE) config --quiet

local-up: local-config
	$(COMPOSE) up -d --wait etcd postgresql rabbitmq redis otel-collector apisix

local-verify: local-config
	./scripts/verify-local.sh

local-ps:
	$(COMPOSE) ps

local-logs:
	$(COMPOSE) logs --follow --tail=200

local-down:
	$(COMPOSE) down --remove-orphans

