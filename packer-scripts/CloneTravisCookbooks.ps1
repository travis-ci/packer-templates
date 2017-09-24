mkdir c:\packertmp\chef-stuff
cd c:\packertmp\chef-stuff

git clone --depth=10 --branch $env:TRAVIS_COOKBOOKS_BRANCH $env:TRAVIS_COOKBOOKS_URL

if ($env:TRAVIS_COOKBOOKS_SHA -ne '') {
  cd travis-cookbooks
  git checkout -qf $env:TRAVIS_COOKBOOKS_SHA
  cd ..
}

cd travis-cookbooks
pwd >c:\.packer-env\TRAVIS_COOKBOOKS_DIR
git log -1 --format=%h >c:\.packer-env\TRAVIS_COOKBOOKS_SHA
