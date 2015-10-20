include_attribute 'travis_build_environment'

override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

override['travis_phpenv']['prerequisite_recipes'] = []

override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_php']['multi']['versions'] = []
override['travis_php']['multi']['extensions'] = []
override['travis_php']['multi']['prerequisite_recipes'] = %w(
  bison
  travis_phpbuild
  travis_phpenv
)
override['travis_php']['multi']['postrequisite_recipes'] = %w(
  composer
  phpunit
)
override['travis_php']['multi']['binaries'] = []

override['composer']['github_oauth_token'] = \
  '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

rubies = %w(
  1.9.3-p551
  2.2.3
)

override['rvm']['group_users'] = %w(travis)
override['rvm']['install_rubies'] = false
override['rvm']['rubies'] = []
override['rvm']['installs']['travis'] = {}.tap do |travis|
  travis['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
  travis['global_gems'] = %w(bundler nokogiri rake).map { |gem| { name: gem } }
  travis['rubies'] = rubies
  travis['rvmrc_env'] = {}.tap do |rvmrc_env|
    rvmrc_env['rvm_autoupdate_flag'] = '0'
    rvmrc_env['rvm_binary_flag'] = '1'
    rvmrc_env['rvm_fuzzy_flag'] = '1'
    rvmrc_env['rvm_remote_flag'] = '1'
    rvmrc_env['rvm_gem_options'] = '--no-ri --no-rdoc'
    rvmrc_env['rvm_max_time_flag'] = '5'
    rvmrc_env['rvm_path'] = "#{node['travis_build_environment']['home']}/.rvm"
    rvmrc_env['rvm_project_rvmrc'] = '0'
    rvmrc_env['rvm_remote_server_type3'] = 'rubies'
    rvmrc_env['rvm_remote_server_url3'] = 'https://s3.amazonaws.com/travis-rubies/binaries'
    rvmrc_env['rvm_remote_server_verify_downloads3'] = '1'
    rvmrc_env['rvm_silence_path_mismatch_check_flag'] = '1'
    rvmrc_env['rvm_user_install_flag'] = '1'
    rvmrc_env['rvm_with_default_gems'] = 'rake bundler'
    rvmrc_env['rvm_without_gems'] = 'rubygems-bundler'
  end
end

override['gimme']['versions'] = []
override['gimme']['default_version'] = ''

override['travis_python']['pyenv']['pythons'] = []
override['travis_python']['pyenv']['aliases'] = {}
override['travis_python']['pip']['packages'] = {}
override['travis_python']['system']['pythons'] = []

override['nodejs']['default'] = ''
override['nodejs']['versions'] = []
override['nodejs']['aliases'] = {}
override['nodejs']['default_modules'] = []

override['system_info']['use_bundler'] = false
override['system_info']['commands_file'] = \
  '/var/tmp/minimal-system-info-commands.yml'

override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['update_hostname'] = false

override['travis_packer_templates']['job_board']['languages'] = %w(generic)
