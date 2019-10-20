# packer-templates [![Build Status](https://travis-ci.org/travis-ci/packer-templates.svg?branch=master)](https://travis-ci.org/travis-ci/packer-templates)

Collection of Packer templates used for various infrastructure layers.

## How to build stuff

To build a given template, one may use the `make` implicit builder, like the
following for `ubuntu-18.04-minimal`:

``` bash
ARCH=arm64 BUILDER=lxd make ubuntu-18.04-minimal
```

or forget about the `Makefile` and run with `packer` directly:

``` bash
packer build <(bin/yml2json < ubuntu-18.04-minimal.yml)
```

## env config bits

Most of the templates in here require some env vars.  Take a look at
[`.example.env`](./.example.env) for an example.  Use of
[autoenv](https://github.com/kennethreitz/autoenv) is encouraged but not
required.
