override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

override['travis_phpenv']['prerequisite_recipes'] = []

override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_php']['multi']['versions'] = []
override['travis_php']['multi']['extensions'] = []
override['travis_php']['multi']['binaries'] = []

override['composer']['github_oauth_token'] = \
  '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

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

override['travis_system_info']['commands_file'] = \
  '/var/tmp/connie-system-info-commands.yml'

rubies = %w(
  1.9.3-p551
  2.2.3
)

override['travis_build_environment']['default_ruby'] = rubies.max
override['travis_build_environment']['rubies'] = rubies
override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['install_gometalinter_tools'] = false

override['travis_packer_templates']['job_board']['codename'] = 'connie'
override['travis_packer_templates']['job_board']['languages'] = %w(
  __connie__
  bash
  generic
  minimal
  sh
  shell
)
