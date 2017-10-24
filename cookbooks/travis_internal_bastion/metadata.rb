# frozen_string_literal: true

name 'travis_internal_bastion'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+packer-templates@travis-ci.org'
license 'MIT'
description 'Installs/Configures travis_internal_bastion'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://github.com/travis-ci/packer-templates'
issues_url 'https://github.com/travis-ci/packer-templates/issues'

depends 'apt'
depends 'iptables'
depends 'openssh'
depends 'travis_duo'
depends 'travis_internal_base'
