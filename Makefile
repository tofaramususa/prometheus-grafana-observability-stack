# Docker Stack configuration
DS = docker stack
ENV_FILE = .env
STACK_FILE = docker-stack.yml
STACK_NAME = monitoring

# Colors for terminal output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

.PHONY: help build up down restart logs clean purge ps all init

all: build up ## Build images and start stack
	@echo "$(GREEN)Build complete and stack deployed$(NC)"

help: ## Show this help message
	@echo 'Usage:'
	@echo '  make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build or rebuild services
	@echo "$(YELLOW)Building services...$(NC)"
	@docker compose -f $(STACK_FILE) --env-file $(ENV_FILE) build

init: ## Create necessary data directories
	@echo "$(GREEN)Creating data directories...$(NC)"
	@sudo mkdir -p /home/tofara/data/prometheus
	@sudo mkdir -p /home/tofara/data/grafana
	@sudo mkdir -p /home/tofara/data/otel-collector
	@sudo chmod 777 /home/tofara/data/prometheus
	@sudo chmod 777 /home/tofara/data/grafana
	@sudo chmod 777 /home/tofara/data/otel-collector
	@sudo chown -R $(shell whoami):$(shell whoami) /home/tofara/data/prometheus
	@sudo chown -R $(shell whoami):$(shell whoami) /home/tofara/data/grafana
	@sudo chown -R $(shell whoami):$(shell whoami) /home/tofara/data/otel-collector
up: init ## Deploy stack
	@echo "$(GREEN)Deploying stack...$(NC)"
	@$(DS) deploy -c $(STACK_FILE) $(STACK_NAME)

down: ## Remove stack
	@echo "$(YELLOW)Removing stack...$(NC)"
	@$(DS) rm $(STACK_NAME)
	@echo "$(YELLOW)Waiting for stack removal to complete...$(NC)"
	@while docker stack ls | grep -q "$(STACK_NAME)"; do \
		echo "$(YELLOW)Stack still removing...$(NC)"; \
		sleep 2; \
	done
	@echo "$(GREEN)Stack removed successfully$(NC)"

restart: down ## Restart stack
	@echo "$(YELLOW)Waiting for cleanup to complete...$(NC)"
	@sleep 5
	@$(MAKE) up

logs: ## View output from services
	@echo "$(YELLOW)Note: Docker Stack doesn't support direct logs command like Docker Compose$(NC)"
	@echo "$(YELLOW)Use: docker service logs [service_name]$(NC)"
	@echo "$(YELLOW)Available services:$(NC)"
	@docker stack services $(STACK_NAME)

ps: ## List services
	@docker stack services $(STACK_NAME)

clean: down ## Clean up Docker resources
	@echo "$(RED)Cleaning up Docker resources...$(NC)"
	@docker system prune -f
	@docker image prune -f

# purge: down ## Remove all Docker resources including volumes
# 	@echo "$(RED)Purging all Docker resources...$(NC)"
# 	@docker system prune -af
# 	@docker volume prune -f
# 	@docker network prune -f

dev: up ## Deploy stack (logs command modified since Docker Stack handles logging differently)
	@echo "$(YELLOW)Stack deployed. For logs, use: docker service logs [service_name]$(NC)"
