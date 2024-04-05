SRCDIR := src
SRCS := $(shell echo $(SRCDIR)/*.js)
MODULES := node_modules
OUTPUTDIR := dist
LOGDIR := logs
LOGS := $(LOGDIR)/deploy.log
RM := rm -rf

.PHONY: all export show clean

all: $(MODULES) $(LOGS) export

$(MODULES): package.json package-lock.json
	@npm ci

$(LOGS): $(SRCS) $(MODULES) .env
	@./scripts/deploy.sh; \
	mkdir -p $(LOGDIR); \
	date >$@

export:
	@./scripts/export.sh

show:
	@./scripts/show.sh

clean:
	@$(RM) $(MODULES) $(OUTPUTDIR) $(LOGDIR)
