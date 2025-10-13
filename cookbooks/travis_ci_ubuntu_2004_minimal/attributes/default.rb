# frozen_string_literal: true

override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

override['travis_phpenv']['prerequisite_recipes'] = []
override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

go_versions = %w[
  1.23
]

override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

override['travis_build_environment']['system_python']['pythons'] = %w[3.8] # apt packages
override['travis_build_environment']['python_aliases'] = {
  '3.12.4' => %w[3.12],
  '3.9.18' => %w[3.9],
  '3.8.18' => %w[3.8],
  '3.7.17' => %w[3.7],
  'pypy2.7-7.3.1' => %w[pypy],
  'pypy3.8-7.3.9' => %w[pypy3]
}
# packages build by Cpython + our repo
pythons = %w[
  3.7.17
  3.8.18
  3.9.18
  3.12.4
]

%w[3].each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

override['travis_build_environment']['pythons'] = pythons
override['travis_build_environment']['pip']['packages'] = {}

override['travis_build_environment']['nodejs_default'] = ''
override['travis_build_environment']['nodejs_versions'] = []
override['travis_build_environment']['nodejs_aliases'] = {}
override['travis_build_environment']['nodejs_default_modules'] = []

override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2004-minimal-system-info-commands.yml'

rubies = %w[
  2.7.0
]
# override['travis_build_environment']['rubies'] = %w[2.4.6 2.5.5 2.6.3]
override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
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
override['travis_build_environment']['mercurial_version'] = '7.0.3'
override['travis_packer_templates']['job_board']['stack'] = 'ubuntu-2004-minimal'
override['travis_packer_templates']['job_board']['features'] = %w[
  basic
  disabled-ipv6
  docker
  docker-compose
  go-toolchain
  perl_interpreter
  perlbrew
  python_interpreter
  ruby_interpreter
]
override['travis_packer_templates']['job_board']['languages'] = %w[
  __ubuntu_2004_minimal__
  minimal
  bash
  shell
  sh
]
