RM = rm -rf

all: node_modules export deploy

node_modules: package.json package-lock.json
	@npm ci

.PHONY: export
export:
	@./scripts/export.sh

deploy:
	@./scripts/deploy.sh

.PHONY: show
show:
	@./scripts/show.sh

.PHONY: clean
clean:
	@$(RM) node_modules dist
