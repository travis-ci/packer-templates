default['travis_worker_wrapper']['install_type'] = 'docker'

override['travis_worker']['environment']['TRAVIS_WORKER_SELF_IMAGE'] = 'quay.io/travisci/worker:v2.4.0-5-g2c09c0c'
