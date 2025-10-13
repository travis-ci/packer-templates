# frozen_string_literal: true

override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

override['travis_phpenv']['prerequisite_recipes'] = []
override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

# GO version must be without the minor version
go_versions = %w[
  1.24
]

override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

override['travis_build_environment']['python_aliases'] = {
  '3.13.1' => %w[3.13],
  '3.12.8' => %w[3.12],
  'pypy3.10-7.3.17' => %w[pypy3]
}
pythons = %w[
  3.12.8
  3.13.1
]

%w[3].each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

override['travis_build_environment']['pythons'] = pythons
override['travis_build_environment']['pip']['packages'] = {}
override['travis_build_environment']['system_python']['pythons'] = %w[3.12]

override['travis_build_environment']['nodejs_default'] = ''
override['travis_build_environment']['nodejs_versions'] = []
override['travis_build_environment']['nodejs_aliases'] = {}
override['travis_build_environment']['nodejs_default_modules'] = []

override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2404-minimal-system-info-commands.yml'

rubies = %w[
  3.1.2
]
override['travis_docker']['update_grub'] = false
override['travis_build_environment']['default_ruby'] = '3.1.2'
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
override['travis_build_environment']['mercurial_install_type'] = 'apt'
override['travis_build_environment']['mercurial_version'] = ''
override['travis_packer_templates']['job_board']['stack'] = 'ubuntu-2404-minimal'
override['travis_packer_templates']['job_board']['features'] = %w[
  basic
  disabled-ipv6
  docker
  go-toolchain
  perl_interpreter
  perlbrew
  python_interpreter
  ruby_interpreter
]
override['travis_packer_templates']['job_board']['languages'] = %w[
  __ubuntu_2404_minimal__
  minimal
  bash
  shell
  sh
]
