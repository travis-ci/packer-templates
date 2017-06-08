# frozen_string_literal: true

name 'travis_internal_base'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-internal-base-cookbook@travis-ci.org'
license 'MIT'
description 'Installs/Configures travis_internal_base'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://github.com/travis-ci/packer-templates'
issues_url 'https://github.com/travis-ci/packer-templates/issues'

depends 'apt'
depends 'openssh'
depends 'papertrail'
depends 'travis_sudo'
