SHELL := /bin/bash
TEMPLATES := \
	$(wildcard ci-*.json) \
	$(wildcard internal-*.json) \
	$(shell echo {jupiter-brain,play,worker}.json)

JQ ?= jq
SED ?= sed

%.json: %.yml
	@touch $@
	@chmod 0600 $@
	@echo generating $@ from $^
	@bin/yml2json < $^ | $(JQ) . > $@
	@chmod 0400 $@

.PHONY: all
all: $(TEMPLATES)

.PHONY: langs
langs:
	@for f in ci-*.json ; do echo $$f | $(SED) 's/ci-//;s/\.json//' ; done
