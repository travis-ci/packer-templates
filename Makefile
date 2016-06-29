SHELL := /bin/bash
BRANCH_FILE := tmp/git-meta/packer-templates-branch
SHA_FILE := tmp/git-meta/packer-templates-sha
PHP_PACKAGES_FILE := packer-assets/ubuntu-precise-ci-php-packages.txt

GIT ?= git
JQ ?= jq
PACKER ?= packer
SED ?= sed

.PHONY: all
all: $(BRANCH_FILE) $(SHA_FILE) $(PHP_PACKAGES_FILE)

.PHONY: langs
langs:
	@for f in ci-*.yml ; do echo $$f | $(SED) 's/ci-//;s/\.yml//' ; done

$(BRANCH_FILE): .git/HEAD
	./bin/dump-git-meta ./tmp/git-meta

$(SHA_FILE): .git/HEAD
	./bin/dump-git-meta ./tmp/git-meta

$(PHP_PACKAGES_FILE): packer-assets/ubuntu-precise-ci-packages.txt
	$(SED) 's/libcurl4-openssl-dev/libcurl4-gnutls-dev/' < $^ > $@
	chmod 0400 $@

.PHONY: test
test:
	./runtests

.PHONY: hackcheck
hackcheck:
	if $(GIT) grep -q \H\A\C\K ; then exit 1 ; fi
