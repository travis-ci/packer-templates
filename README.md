# packer-templates

Collection of Packer templates used for various infrastructure layers.

## How to build stuff

Like so:

``` bash
packer build -only=docker <(bin/yml2json < ci-minimal.yml)
```

## env config bits

Most of the templates in here require some env vars.  Take a look at
[`.example.env`](./.example.env) for an example.  Use of
[autoenv](https://github.com/kennethreitz/autoenv) is encouraged but not
required.
