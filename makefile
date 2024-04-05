SRCDIR := src
SRCS := $(shell echo $(SRCDIR)/*.js)
modules := node_modules
OUTPUTDIR := dist
LOGDIR := logs
LOGS := $(LOGDIR)/deploy.log
RM := rm -rf

.PHONY: all export show clean

all: $(modules) $(LOGS) export

$(modules): package.json package-lock.json
	@npm ci

$(LOGS): $(SRCS) $(modules) .env
	@./scripts/deploy.sh
	@mkdir -p $(LOGDIR)
	@date >$@

export:
	@./scripts/export.sh

show:
	@./scripts/show.sh

clean:
	@$(RM) $(modules) $(OUTPUTDIR) $(LOGDIR)
