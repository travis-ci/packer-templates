travis_ci_garnet Cookbook
=======================

A wrapper cookbook for the "garnet" CI image.

## local testing

The `.kitchen.yml` provisioner section for `chef_solo` includes a cookbook path
entry of `./cookbooks`, which is *not tracked in git*.  Symlinking the
`cookbooks` and `community-cookbooks` directories from [the travis-cookbooks
repo](https://github.com/travis-ci/travis-cookbooks) will do the trick.
