TEMPLATES := \
	ci-minimal.json \
	ci-docker-import-base.json \
	ci-docker-import.json \
	ci-standard.json \
	internal-base.json \
	ubuntu-precise-base.json \
	ubuntu-trusty-base.json \
	worker.json

JQ ?= jq

%.json: %.yml
	touch $@
	chmod 0600 $@
	bin/yml2json < $^ | $(JQ) . > $@
	chmod 0400 $@

all: $(TEMPLATES)
