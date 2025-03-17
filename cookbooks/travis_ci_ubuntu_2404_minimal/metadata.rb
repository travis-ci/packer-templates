# frozen_string_literal: true

name 'travis_ci_ubuntu_2404_minimal'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+packer-templates@travis-ci.org'
license 'MIT'
description 'Installs/Configures travis_ci_ubuntu_2404_minimal'
long_description File.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://github.com/travis-ci/packer-templates'
issues_url 'https://github.com/travis-ci/packer-templates/issues'

depends 'travis_build_environment'
depends 'travis_docker'
depends 'travis_java'
depends 'travis_jdk'
depends 'travis_packer_templates'
depends 'travis_perlbrew'
depends 'travis_postgresql'
depends 'travis_system_info'
