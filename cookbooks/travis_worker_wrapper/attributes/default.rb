default['travis_worker_wrapper']['install_type'] = 'docker'

override['travis_worker']['environment']['TRAVIS_WORKER_SELF_IMAGE'] = 'quay.io/travisci/worker:v2.3.1-61-g76a687b'
