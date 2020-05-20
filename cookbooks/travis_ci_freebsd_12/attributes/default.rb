# frozen_string_literal: true

override['travis_java']['jdk_switcher_path'] = '/opt/jdk_switcher/jdk_switcher.sh'
override['travis_java']['jvm_base_dir'] = '/usr/lib/jvm'

override['travis_java']['default_version'] = 'openjdk8'
override['travis_java']['openjdk8']['jvm_name'] = "java-1.8.0-openjdk-#{node['travis_java']['arch']}"
override['travis_java']['alternate_versions'] = []
override['travis_java']['jdk_switcher_url'] = 'https://raw.githubusercontent.com/travis-ci/jdk_switcher/freebsd/jdk_switcher.sh'

override['travis_phpenv']['prerequisite_recipes'] = []
override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

override['travis_python']['pyenv_install_url'] = 'https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer'
override['travis_python']['pyenv_install_path'] = '/opt/pyenv/install'

gimme_versions = %w[
  1.7.4
]

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

override['travis_build_environment']['pythons'] = []
override['travis_build_environment']['python_aliases'] = {
  '2.7.15' => %w[2.7],
  '3.6.10' => %w[3.6],
  'pypy2.7-5.8.0' => %w[pypy],
  'pypy3.5-5.8.0' => %w[pypy3]
}
override['travis_build_environment']['pip']['packages'] = {}
override['travis_build_environment']['system_python']['pythons'] = %w[2.7 3.6]

override['travis_build_environment']['nodejs_default'] = ''
override['travis_build_environment']['nodejs_versions'] = []
override['travis_build_environment']['nodejs_aliases'] = {}
override['travis_build_environment']['nodejs_default_modules'] = []

rubies = %w[
  2.6.5
]

override['travis_build_environment']['default_ruby'] = rubies.max
override['travis_build_environment']['rubies'] = rubies
override['travis_build_environment']['php_versions'] = []
override['travis_build_environment']['php_aliases'] = {}
override['travis_build_environment']['otp_releases'] = []
override['travis_build_environment']['elixir_versions'] = []
override['travis_build_environment']['default_elixir_version'] = ''
override['travis_build_environment']['hhvm_enabled'] = false
override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['install_gometalinter_tools'] = false
override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '4.2.2~trusty1'

override['travis_packer_templates']['job_board']['stack'] = 'onion'
override['travis_packer_templates']['job_board']['features'] = %w[
  basic
  jdk
  python_interpreter
]
override['travis_packer_templates']['job_board']['languages'] = %w[
  __freebsd_12__
  minimal
  sh
  shell
  ruby
  java
  python
]

override['travis_build_environment']['root_user'] = 'root'
override['travis_build_environment']['root_group'] = 'wheel'
