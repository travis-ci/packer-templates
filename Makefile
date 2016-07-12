SHELL := /bin/bash
BRANCH_FILE := tmp/git-meta/packer-templates-branch
SHA_FILE := tmp/git-meta/packer-templates-sha
META_FILES := $(BRANCH_FILE) $(SHA_FILE)
PHP_PACKAGES_FILE := packer-assets/ubuntu-precise-ci-php-packages.txt
TRAVIS_COOKBOOKS_GIT := https://github.com/travis-ci/travis-cookbooks.git
TRAVIS_COMMIT_RANGE := $(shell echo $${TRAVIS_COMMIT_RANGE:-@...@})
CHEF_COOKBOOK_PATH := $(PWD)/.git::cookbooks \
	$(TRAVIS_COOKBOOKS_GIT)::cookbooks@master \
	$(TRAVIS_COOKBOOKS_GIT)::community-cookbooks@master \
	$(TRAVIS_COOKBOOKS_GIT)::ci_environment@precise-stable \
	$(TRAVIS_COOKBOOKS_GIT)::worker_host@precise-stable

BUILDER ?= googlecompute

BUNDLE ?= bundle
GIT ?= git
JQ ?= jq
PACKER ?= packer
SED ?= sed

%: %.yml $(META_FILES)
	$(PACKER) build -only=$(BUILDER) <(bin/yml2json < $<)

.PHONY: all
all: $(META_FILES) $(PHP_PACKAGES_FILE)

.PHONY: langs
langs:
	@for f in ci-*.yml ; do echo $$f | $(SED) 's/ci-//;s/\.yml//' ; done

.PHONY: test
test:
	./runtests --env .example.env

.PHONY: packer-build-trigger
packer-build-trigger:
	$(BUNDLE) exec travis-packer-build \
		--chef-cookbook-path="$(shell echo $(CHEF_COOKBOOK_PATH))" \
		--packer-templates-path="$(PWD)/.git::" \
		--commit-range="$(TRAVIS_COMMIT_RANGE)" \
		--target-repo-slug=travis-infrastructure/packer-build \
		--body-json-tmpl=$(PWD)/.travis-packer-build-tmpl.json

.PHONY: hackcheck
hackcheck:
	if $(GIT) grep -q \H\A\C\K ; then exit 1 ; fi

tmp:
	mkdir -p tmp

$(META_FILES): .git/HEAD
	./bin/dump-git-meta ./tmp/git-meta

$(PHP_PACKAGES_FILE): packer-assets/ubuntu-precise-ci-packages.txt
	$(SED) 's/libcurl4-openssl-dev/libcurl4-gnutls-dev/' < $^ > $@
	chmod 0400 $@
