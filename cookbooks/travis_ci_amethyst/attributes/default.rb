default['travis_ci_amethyst']['prerequisite_packages'] = %w(
  cron
  curl
  git
  sudo
  wget
)

override['travis_system_info']['commands_file'] = \
  '/var/tmp/amethyst-system-info-commands.yml'

override['travis_perlbrew']['perls'] = [
  { name: '5.22', version: 'perl-5.22.0' },
  { name: '5.22-extras', version: 'perl-5.22.0',
    arguments: '-Duseshrplib -Duseithreads', alias: '5.22-shrplib' },
  { name: '5.24', version: 'perl-5.24.0' },
  { name: '5.24-extras', version: 'perl-5.24.0',
    arguments: '-Duseshrplib -Duseithreads', alias: '5.24-shrplib' }
]
override['travis_perlbrew']['modules'] = %w(
  Dist::Zilla
  Dist::Zilla::Plugin::Bootstrap::lib
  ExtUtils::MakeMaker
  LWP
  Module::Install
  Moose
  Test::Exception
  Test::Most
  Test::Pod
  Test::Pod::Coverage
)
override['travis_perlbrew']['prerequisite_packages'] = []

override['gimme']['versions'] = []
override['gimme']['default_version'] = ''

node_versions = %w(
  4.4.7
)

override['nodejs']['versions'] = node_versions
override['nodejs']['default'] = node_versions.max
override['nodejs']['default_modules'] = [
  {
    'module' => 'grunt-cli'
  }
]

override['travis_python']['pyenv']['pythons'] = []

rubies = %w(
  2.3.1
)

override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w(
  19.0
  18.3
)
elixirs = %w(
  1.3.2
  1.2.6
)
override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_sphinxsearch']['ppas'] = %w(
  ppa:builds/sphinxsearch-rel22
)

override['travis_packer_templates']['job_board']['codename'] = 'amethyst'
override['travis_packer_templates']['job_board']['features'] = %w(
  memcached
  postgresql
  redis
  sqlite
  xserver
)
override['travis_packer_templates']['job_board']['languages'] = %w(
  __amethyst__
  crystal
  csharp
  d
  dart
  elixir
  erlang
  haxe
  julia
  perl
  r
  rust
)
