default['travis_worker_wrapper']['local_docker'] = false

override['travis_go_worker']['environment']['TRAVIS_WORKER_SELF_IMAGE'] = 'quay.io/travisci/worker:v2.3.1-61-g76a687b'
