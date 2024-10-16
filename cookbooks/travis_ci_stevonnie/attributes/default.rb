# frozen_string_literal: true

override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

override['travis_phpenv']['prerequisite_recipes'] = []
override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

go_versions = %w[
  1.18.4
]

override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

override['travis_jdk']['versions'] = %w[
  openjdk8
]
override['travis_jdk']['default'] = 'openjdk8'

override['travis_build_environment']['pythons'] = []
override['travis_build_environment']['python_aliases'] = {}
override['travis_build_environment']['pip']['packages'] = {}
override['travis_build_environment']['system_python']['pythons'] = []

override['travis_build_environment']['nodejs_default'] = ''
override['travis_build_environment']['nodejs_versions'] = []
override['travis_build_environment']['nodejs_aliases'] = {}
override['travis_build_environment']['nodejs_default_modules'] = []

pythons = %w[
  3.7.17
  3.8.13
]

# Reorder pythons so that default python2 and python3 come first
# as this affects the ordering in $PATH.
%w[3].each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

def python_aliases(full_name)
  nodash = full_name.split('-').first
  return [nodash] unless nodash.include?('.')

  [nodash[0, 3]]
end

override['travis_build_environment']['pythons'] = pythons
pythons.each do |full_name|
  override['travis_build_environment']['python_aliases'][full_name] = \
    python_aliases(full_name)
end

override['travis_system_info']['commands_file'] = \
  '/var/tmp/stevonnie-system-info-commands.yml'

rubies = %w[
  2.7.6
  3.0.4
  3.1.2
]

override['travis_build_environment']['default_ruby'] = '2.7.6'
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
override['travis_build_environment']['mercurial_version'] = '5.9.3'

override['travis_packer_templates']['job_board']['stack'] = 'stevonnie'
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
  __stevonnie__
  bash
  minimal
  sh
  shell
]

override['travis_docker']['version'] = '5:20.10.7~3-0~ubuntu-xenial'
override['travis_docker']['binary']['version'] = '20.10.7'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'f3f10cf3dbb8107e9ba2ea5f23c1d2159ff7321d16f0a23051d68d8e2547b323'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz'
override['travis_docker']['binary']['checksum'] = '34ad50146fce29b28e5115a1e8510dd5232459c9a4a9f28f65909f92cca314d9'
