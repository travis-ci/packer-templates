SHELL := /bin/bash
BRANCH_FILE := tmp/git-meta/packer-templates-branch
SHA_FILE := tmp/git-meta/packer-templates-sha
META_FILES := $(BRANCH_FILE) $(SHA_FILE)
PHP_PACKAGES_FILE := packer-assets/ubuntu-precise-ci-php-packages.txt
TRAVIS_COOKBOOKS_GIT_REMOTE := https://github.com/travis-ci/travis-cookbooks.git

BUILDER ?= googlecompute

GIT ?= git
JQ ?= jq
PACKER ?= packer
SED ?= sed

%: %.yml $(META_FILES)
	$(PACKER) build -only=$(BUILDER) <(bin/yml2json < $<)

tmp/travis-cookbooks-%: tmp
	$(GIT) clone --branch=$(patsubst tmp/travis-cookbooks-%,%,$@) \
		$(TRAVIS_COOKBOOKS_GIT_REMOTE) $@

.PHONY: all
all: $(META_FILES) $(PHP_PACKAGES_FILE)

.PHONY: langs
langs:
	@for f in ci-*.yml ; do echo $$f | $(SED) 's/ci-//;s/\.yml//' ; done

.PHONY: test
test:
	./runtests --env .example.env

.PHONY: hackcheck
hackcheck:
	if $(GIT) grep -q \H\A\C\K ; then exit 1 ; fi

.PHONY: upstream-cookbooks
upstream-cookbooks: tmp/travis-cookbooks-master tmp/travis-cookbooks-precise-stable
	$(foreach clone,$^,\
			pushd $(clone) && $(GIT) pull ; popd ; \
	)

tmp:
	mkdir -p tmp

$(META_FILES): .git/HEAD
	./bin/dump-git-meta ./tmp/git-meta

$(PHP_PACKAGES_FILE): packer-assets/ubuntu-precise-ci-packages.txt
	$(SED) 's/libcurl4-openssl-dev/libcurl4-gnutls-dev/' < $^ > $@
	chmod 0400 $@
