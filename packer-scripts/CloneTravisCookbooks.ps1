mkdir c:/windows/temp/chef-stuff
cd c:/windows/temp/chef-stuff

if ($env:TRAVIS_COOKBOOKS_BRANCH -eq '') {
  $env:TRAVIS_COOKBOOKS_BRANCH = $env:$TRAVIS_COOKBOOKS_EDGE_BRANCH
}

if ($env:TRAVIS_COOKBOOKS_BRANCH -eq '') {
  $env:TRAVIS_COOKBOOKS_BRANCH = 'master'
}

if ($env:TRAVIS_COOKBOOKS_URL -eq '') {
  $env:TRAVIS_COOKBOOKS_URL = 'https://github.com/travis-ci/travis-cookbooks.git'
}

git clone --depth=10 --branch $env:TRAVIS_COOKBOOKS_BRANCH $env:TRAVIS_COOKBOOKS_URL c:/windows/temp/chef-stuff/travis-cookbooks

if ($env:TRAVIS_COOKBOOKS_SHA -ne '') {
  cd travis-cookbooks
  git checkout -qf $env:TRAVIS_COOKBOOKS_SHA
  cd ..
}

cd travis-cookbooks
pwd >c:/.packer-env/TRAVIS_COOKBOOKS_DIR
git log -1 --format=%h >c:/.packer-env/TRAVIS_COOKBOOKS_SHA
