override['rvm']['default'] = '2.1.6'
override['rvm']['rubies'] = [{ 'name' => '2.1.6' }]
override['rvm']['gems'] = ['nokogiri']

override['travis_build_environment']['apt']['retries'] = 2
override['travis_build_environment']['apt']['timeout'] = 10
override['travis_build_environment']['arch'] = 'x86_64'
override['travis_build_environment']['builds_volume_size'] = '350m'
override['travis_build_environment']['group'] = 'travis'
override['travis_build_environment']['home'] = '/home/travis'
override['travis_build_environment']['hosts'] = {}
override['travis_build_environment']['installation_suffix'] = 'org'
override['travis_build_environment']['update_hosts'] = true
override['travis_build_environment']['update_hosts_atomically'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['user'] = 'travis'
