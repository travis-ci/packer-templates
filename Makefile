SHELL := /bin/bash
BRANCH_FILE := tmp/git-meta/packer-templates-branch
SHA_FILE := tmp/git-meta/packer-templates-sha
META_FILES := \
	$(BRANCH_FILE) \
	$(SHA_FILE) \
	$(PWD)/tmp/docker-meta/.dumped \
	$(PWD)/tmp/job-board-env/.dumped
PHP_PACKAGES_FILE := packer-assets/ubuntu-precise-ci-php-packages.txt
SYSTEM_INFO_COMMANDS_FILES := \
	packer-assets/amethyst-system-info-commands.yml \
	packer-assets/connie-system-info-commands.yml \
	packer-assets/garnet-system-info-commands.yml \
	packer-assets/sugilite-system-info-commands.yml
TRAVIS_COOKBOOKS_GIT := https://github.com/travis-ci/travis-cookbooks.git
TRAVIS_COMMIT_RANGE := $(shell echo $${TRAVIS_COMMIT_RANGE:-@...@})
CHEF_COOKBOOK_PATH := $(PWD)/.git::cookbooks \
	$(TRAVIS_COOKBOOKS_GIT)::cookbooks@master \
	$(TRAVIS_COOKBOOKS_GIT)::community-cookbooks@master \
	$(TRAVIS_COOKBOOKS_GIT)::ci_environment@precise-stable \
	$(TRAVIS_COOKBOOKS_GIT)::worker_host@precise-stable
UNAME := $(shell uname | tr '[:upper:]' '[:lower:]')

BUILDER ?= googlecompute

CURL ?= curl
GIT ?= git
JQ ?= jq
PACKER ?= packer
SED ?= sed
TRAVIS_PACKER_BUILD ?= travis-packer-build
UNZIP ?= unzip

%: %.yml $(META_FILES)
	$(PACKER) build -only=$(BUILDER) <(bin/yml2json < $<)

.PHONY: all
all: $(META_FILES) $(PHP_PACKAGES_FILE) $(SYSTEM_INFO_COMMANDS_FILES)

.PHONY: stacks-short
stacks-short:
	@$(MAKE) stacks | sed 's/-trusty//;s/-precise//'

.PHONY: stacks
stacks: stacks-precise stacks-trusty

.PHONY: stacks-precise
stacks-precise:
	@bin/list-stacks precise

.PHONY: stacks-trusty
stacks-trusty:
	@bin/list-stacks trusty

.PHONY: test
test:
	./runtests --env .example.env

.PHONY: clean
clean:
	$(RM) -r $(PWD)/tmp/docker-meta $(PWD)/tmp/git-meta
	find packer-assets/system-info.d -type f | xargs touch

.PHONY: packer-build-trigger
packer-build-trigger:
	bin/packer-build-trigger

.PHONY: packer-build-trigger-all-ci
packer-build-trigger-all-ci:
	bin/packer-build-trigger $(shell for f in ci-*.yml ; do echo -I $$f ; done)

.PHONY: install-packer
install-packer: tmp/packer.zip
	mkdir -p ~/bin
	$(UNZIP) -o -d ~/bin $<
	chmod +x ~/bin/packer

.PHONY: install-bats
install-bats: tmp/bats/.git
	cd tmp/bats && ./install.sh $$HOME

.PHONY: update-gce-images
update-gce-images:
	bin/gce-image-update $$(git grep -lE 'source_image: ubuntu' *.yml)

tmp/packer.zip:
	$(CURL) -sSLo $@ 'https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_$(UNAME)_amd64.zip'

tmp/bats/.git:
	$(GIT) clone https://github.com/sstephenson/bats.git tmp/bats

tmp:
	mkdir -p tmp

$(META_FILES): .git/HEAD
	./bin/dump-git-meta ./tmp/git-meta
	./bin/write-envdir $(PWD)/tmp/docker-meta 'DOCKER_LOGIN_(USERNAME|PASSWORD|SERVER)'
	./bin/write-envdir $(PWD)/tmp/job-board-env 'JOB_BOARD'

$(PHP_PACKAGES_FILE): packer-assets/ubuntu-precise-ci-packages.txt
	chmod 0600 $@
	$(SED) 's/libcurl4-openssl-dev/libcurl4-gnutls-dev/' < $^ > $@
	chmod 0400 $@

packer-assets/%-system-info-commands.yml: $(wildcard packer-assets/system-info.d/*.yml)
	chmod 0600 $@
	./bin/generate-system-info-commands \
		$(shell echo $@ | sed 's,packer-assets/,,;s,-system-info-commands.yml,,') \
		>$@
	chmod 0400 $@
