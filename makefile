include .env

SRCS := $(wildcard $(SRC_DIR)/*.js)
PACKAGES := node_modules
DEPENDENCY_PACKAGES := package.json package-lock.json
DEPLOY_LOG := $(LOG_DIR)/deploy.log
RM := rm -rf

.PHONY: all
all: $(PACKAGES)

$(PACKAGES): $(DEPENDENCY_PACKAGES)
	@npm ci

.PHONY: deploy
deploy: $(DEPLOY_LOG)

$(DEPLOY_LOG): $(SRCS) $(DEPENDENCY_PACKAGES) .env
	@./scripts/deploy.sh; \
	mkdir -p $(LOG_DIR); \
	date >$(DEPLOY_LOG)

.PHONY: export
export:
	@./scripts/export.sh

.PHONY: show
show:
	@./scripts/show.sh

.PHONY: clean
clean:
	@$(RM) $(OUTPUT_DIR) $(PACKAGES) $(LOG_DIR)
