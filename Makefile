TEMPLATES := \
	ci-android.json \
	ci-erlang.json \
	ci-go.json \
	ci-haskell.json \
	ci-jvm.json \
	ci-mega.json \
	ci-minimal.json \
	ci-nodejs.json \
	ci-perl.json \
	ci-php.json \
	ci-python.json \
	ci-ruby.json \
	internal-base.json \
	internal-bastion.json \
	internal-nat.json \
	jupiter-brain.json \
	play.json \
	worker.json

JQ ?= jq

%.json: %.yml
	touch $@
	chmod 0600 $@
	bin/yml2json < $^ | $(JQ) . > $@
	chmod 0400 $@

all: $(TEMPLATES)
