TEMPLATES := \
	ci-android.json \
	ci-docker-import-base.json \
	ci-docker-import.json \
	ci-erlang.json \
	ci-go.json \
	ci-haskell.json \
	ci-jvm.json \
	ci-minimal.json \
	ci-node-js.json \
	ci-perl.json \
	ci-php.json \
	ci-python.json \
	ci-rnpp.json \
	ci-ruby.json \
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
