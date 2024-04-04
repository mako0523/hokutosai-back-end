RM = rm -rf

all: node_modules logs/deploy.log export

node_modules: package.json package-lock.json
	@npm ci

logs/deploy.log: .env package.json package-lock.json src/vote.js
	@./scripts/deploy.sh

.PHONY: export
export:
	@./scripts/export.sh

.PHONY: show
show:
	@./scripts/show.sh

.PHONY: clean
clean:
	@$(RM) node_modules logs dist
