# frozen_string_literal: true

default['travis_tfw']['docker_environment']['TRAVIS_DOCKER_TFW'] = 'oooOOOoooo'
default['travis_tfw']['docker_volume_device'] = '/dev/xvdx'
default['travis_tfw']['docker_volume_metadata_size'] = '2G'
default['travis_tfw']['docker_dm_basesize'] = '12G'
default['travis_tfw']['docker_dm_fs'] = 'overlay2'
default['travis_tfw']['docker_dir'] = '/mnt/docker'
