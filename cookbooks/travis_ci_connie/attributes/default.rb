override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

override['travis_phpenv']['prerequisite_recipes'] = []
override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

gimme_versions = %w(
  1.6.3
)

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

override['travis_python']['pyenv']['pythons'] = []
override['travis_python']['pyenv']['aliases'] = {}
override['travis_python']['pip']['packages'] = {}
override['travis_python']['system']['pythons'] = []

override['nodejs']['default'] = ''
override['nodejs']['versions'] = []
override['nodejs']['aliases'] = {}
override['nodejs']['default_modules'] = []

override['travis_system_info']['commands_file'] = \
  '/var/tmp/connie-system-info-commands.yml'

rubies = %w(
  2.2.5
  2.3.1
)

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

override['travis_packer_templates']['job_board']['codename'] = 'connie'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  docker
  docker-compose
  go-toolchain
  perl_interpreter
  perlbrew
  python_interpreter
  ruby_interpreter
)
override['travis_packer_templates']['job_board']['languages'] = %w(
  __connie__
  bash
  generic
  minimal
  sh
  shell
)
