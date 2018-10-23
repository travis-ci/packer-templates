# frozen_string_literal: true

name 'travis_ci_sardonyx'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+packer-templates@travis-ci.org'
license 'MIT'
description 'Installs/Configures travis_ci_sardonyx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url 'https://github.com/travis-ci/packer-templates'
issues_url 'https://github.com/travis-ci/packer-templates/issues'

depends 'memcached'
depends 'openssl'
depends 'travis_build_environment'
depends 'travis_docker'
depends 'travis_java'
depends 'travis_jdk'
depends 'travis_packer_templates'
depends 'travis_perlbrew'
depends 'travis_phantomjs'
depends 'travis_postgresql'
depends 'travis_sbt_extras'
depends 'travis_system_info'
