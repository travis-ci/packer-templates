# packer-templates

Collection of Packer templates used for various infrastructure layers.

## How to build stuff

To build a given template, one may use the `make` implicit builder, like the
following for `ci-connie`:

``` bash
make ci-connie
```

or, with a specific builder:

``` bash
make ci-connie BUILDER=docker
```

or forget about the `Makefile` and run with `packer` directly:

``` bash
packer build -only=docker <(bin/yml2json < ci-connie.yml)
```

## env config bits

Most of the templates in here require some env vars.  Take a look at
[`.example.env`](./.example.env) for an example.  Use of
[autoenv](https://github.com/kennethreitz/autoenv) is encouraged but not
required.

## packer template types

There are two primary types of templates present at the top level: those
intended for use as execution environment for jobs flowing through Travis CI,
and those used for various backend fun in the Travis CI infrastructure.  The
former type all have the prefix `ci-`, described in more detail below:

### ci templates

There are two primary types of CI templates: those targeting Ubuntu 12.04
(precise), primarily authored to replicate the legacy Blue Box and Docker images
that were mastered via the `travis-images` process, and those targeting Ubuntu
14.04 (trusty) that run on GCE and (someday) Docker.

Take a peek at what's what:

``` bash
make langs-precise
```

``` bash
make langs-trusty
```

The primary difference between the precise and trusty images is which branch of
[travis-cookbooks](https://github.com/travis-ci/travis-cookbooks) is used by the
given template's Chef provisioner.  Images targeting precise default to the
`precise-stable` branch, while those targeting trusty default to the `master`
branch.

There may be some subtle variations, but for the most part each CI template is
built via the following steps.

#### git metadata file input

The generated files in `./tmp/git-meta/` are copied onto the provisioned machine
at `/var/tmp/git-meta/` for later use by the `./packer-scripts/packer-env-dump`
script.

#### purge file input

A git-tracked file in `./packer-assets` is copied onto the provisioned machine
at `/var/tmp/purge.txt` for later use by the `./packer-scripts/purge` script.

#### packages file input

A git-tracked file in `./packer-assets` is copied onto the provisioned machine
at `/var/tmp/packages.txt` for later use by both the
`travis_packer_templates::default` recipe and the serverspec suites via
`./cookbooks/lib/support.rb`.

#### write packer and travis env vars

The script at `./packer-scripts/packer-env-dump` creates a directory on the
provisioned machine at `/.packer-env` which is intended to be in the [envdir
format](https://cr.yp.to/daemontools/envdir.html).  Any environment variables
that match `^(PACKER|TRAVIS)`, and (if present) the files previously written to
`/var/tmp/git-meta/` are copied or written into `/.packer-env/`.

#### remove default users

The script at `./packer-scripts/remove-default-users` will perform a best-effort
removal of users defined in `${DEFAULT_USERS}` (default `vagrant ubuntu`).  The
primary reasons for this are general tidyness and to try to free up uid 1000.

#### pre-chef bootstrapping

The script at `./packer-scripts/pre-chef-bootstrap` is responsible for ensuring
the provisioned machine has all necessary packages and users for the Chef
provisioning process.  The steps executed include:

- remove the "partner" APT source list file
- remove all cached APT list files
- install APT packages needed by Chef
- ensure `/var/run/sshd` dir exists
- ensure `sshd: ALL: ALLOW` exists in `/etc/hosts.allow`
- ensure there is a `travis` user
- change the `travis` user password to `travis`
- ensure `#includedir /etc/sudoers.d` exists in `/etc/sudoers`
- ensure the `/etc/sudoers.d` dir exists
- ensure the `/etc/sudoers.d/travis` file exists with specific permissions
- ensure the `/home/travis/.ssh` dir exists
- ensure the `/home/travis/.ssh/authorized_keys` file exists
- add `/var/tmp/*_rsa.pub` to `/home/travis/.ssh/authorized_keys`
- ensure `/home/travis/.ssh/authorized_keys` perms are `0600`

#### cloning travis-cookbooks

The script at `./packer-scripts/clone-travis-cookbooks` is responsible for `git
clone`'ing [travis-cookbooks][https://github.com/travis-ci/travis-cookbooks]
into `/tmp/chef-stuff` on the provisioned machine.  Optional env vars supported
by this script include:

- `${TRAVIS_COOKBOOKS_BRANCH}` - the branch specified during `git clone`
- `${TRAVIS_COOKBOOKS_EDGE_BRANCH}` - the default branch used if
  `${TRAVIS_COOKBOOKS_BRANCH}` is not defined
- `${TRAVIS_COOKBOOKS_URL}` - the git clone remote (default
  `https://github.com/travis-ci/travis-cookbooks.git`)
- `${TRAVIS_COOKBOOKS_SHA}` - a git tree-ish to which the clone will be checked
  out if defined (default not set)

Once the clone is complete, the clone directory is written to
`/.packer-env/TRAVIS_COOKBOOKS_DIR` and the head sha is written to
`/.packer-env/TRAVIS_COOKBOOKS_SHA`.

#### chef provisioning

The `chef-solo` provisioner will typically have *no json data*, but instead will
leave all attribute and effective run list definition to a single wrapper
cookbook located in `./cookbooks/`.

##### chef wrapper cookbook layout

**TODO**

#### travis user double check

**TODO**

#### purging undesirable packages

**TODO**

#### disabling apparmor

**TODO**

#### running server specs

**TODO**

#### removing undesirable files

**TODO**

#### registering the image with job-board

**TODO**

#### minimizing image size

**TODO**
