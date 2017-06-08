# frozen_string_literal: true

default['travis_worker_wrapper']['install_type'] = 'docker'

override['travis_worker']['environment']['TRAVIS_WORKER_SELF_IMAGE'] = 'quay.io/travisci/worker:v2.5.0-8-g19ea9c2'
