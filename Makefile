SHELL := /bin/bash
TEMPLATES := \
	$(wildcard ci-*.json) \
	$(wildcard internal-*.json) \
	$(shell echo {jupiter-brain,play,worker}.json)

JQ ?= jq

%.json: %.yml
	@touch $@
	@chmod 0600 $@
	@echo generating $@ from $^
	@bin/yml2json < $^ | $(JQ) . > $@
	@chmod 0400 $@

all: $(TEMPLATES)
