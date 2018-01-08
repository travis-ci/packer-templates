# frozen_string_literal: true

default['travis_tfw']['docker_environment']['TRAVIS_DOCKER_TFW'] = 'oooOOOoooo'
default['travis_tfw']['docker_volume_device'] = '/dev/xvdc'
default['travis_tfw']['docker_volume_metadata_size'] = '2G'
default['travis_tfw']['docker_dm_basesize'] = '12G'
default['travis_tfw']['docker_dm_fs'] = 'xfs'
default['travis_tfw']['docker_dir'] = '/mnt/docker'

default['travis_tfw']['linux_kernel_package'] = 'linux-image-4.13.0-24-generic'
default['travis_tfw']['linux_kernel_version'] = '4.13.0-24.28~16.04.1'
