REPO_URL=https://github.com/diegopego/harbour-core.git
REPO_DIR=../harbour-core

.PHONY: all clone update

all: clone

clone:
	@if [ -d "$(REPO_DIR)/.git" ]; then \
		echo "Repositório já existe. Rode 'make update' para atualizar."; \
	else \
		echo "Clonando $(REPO_URL) em $(REPO_DIR)"; \
		git clone $(REPO_URL) $(REPO_DIR); \
	fi

update:
	@if [ -d "$(REPO_DIR)/.git" ]; then \
		echo "Atualizando repositório em $(REPO_DIR)"; \
		cd $(REPO_DIR) && git pull --rebase; \
	else \
		echo "Repositório não encontrado. Rode 'make clone' primeiro."; \
		exit 1; \
	fi

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs

run:
	docker compose run --rm harbour /scripts/build-harbour.sh	