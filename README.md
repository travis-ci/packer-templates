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

### stacks

There are two primary types of stacks: those targeting Ubuntu 12.04 (precise),
primarily authored to replicate the legacy Blue Box and Docker images that were
mastered via the `travis-images` process, and those targeting Ubuntu 14.04
(trusty) that run on GCE and (someday) Docker.

Take a peek at what's what:

``` bash
make stacks-precise
```

``` bash
make stacks-trusty
```

The primary difference between the precise and trusty stacks is which branch of
[travis-cookbooks](https://github.com/travis-ci/travis-cookbooks) is used by the
given template's Chef provisioner.  Stacks targeting precise default to the
`precise-stable` branch, while those targeting trusty default to the `master`
branch.

There may be some subtle variations, but for the most part each stack is built
via the following steps.

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
clone`'ing [travis-cookbooks](https://github.com/travis-ci/travis-cookbooks)
into `/tmp/chef-stuff` on the provisioned machine.  Optional env vars supported
by this script are:

- `TRAVIS_COOKBOOKS_BRANCH` - the branch specified during `git clone`
- `TRAVIS_COOKBOOKS_EDGE_BRANCH` - the default branch used if
  `TRAVIS_COOKBOOKS_BRANCH` is not defined
- `TRAVIS_COOKBOOKS_URL` - the git clone remote (default
  `https://github.com/travis-ci/travis-cookbooks.git`)
- `TRAVIS_COOKBOOKS_SHA` - a git tree-ish to which the clone will be checked
  out if defined (default not set)

Once the clone is complete, the clone directory is written to
`/.packer-env/TRAVIS_COOKBOOKS_DIR` and the head sha is written to
`/.packer-env/TRAVIS_COOKBOOKS_SHA`.

#### chef provisioning

The `chef-solo` provisioner will typically have *no json data*, but instead will
leave all attribute and effective run list definition to a single wrapper
cookbook located in `./cookbooks/`.

##### chef wrapper cookbook layout

Each wrapper cookbook must contain at least a `metadata.rb` and a
`recipes/default.rb`.  Typically, the `attributes/default.rb` is defined and
contains all override attribute settings.  The earliest version of Chef used by
either precise or trusty stacks is `12.9`, which means that *all* cookbook
dependencies must be declared in `metadata.rb`, a requirement that is also
enforced by the `foodcritic` checks.

For example, the minimal trusty image "ci-connie" has a wrapper cookbook at
`./cookbooks/travis-ci_connie` that looks like this:

```
cookbooks/travis_ci_connie
├── README.md
├── attributes
│   └── default.rb
├── metadata.rb
├── recipes
│   └── default.rb
└── spec
    ├── ...
```

#### travis user double check

The script at `./packer-scripts/ensure-travis-user` is responsible for ensuring
the existence of the `travis` user and its home directory permissions,
optionally setting the password to a random string.  The list of operations is:

- ensure the `travis` user exists
- set the `travis` user password
- ensure `/home/travis` exists
- ensure `/home/travis/.ssh/authorized_keys` and `/home/travis/.ssh/known_hosts`
  both exist and have permissions of `0600`
- blank out `/home/travis/.ssh/authorized_keys`
- ensure `/home/travis` is fully owned by `travis:travis`

Optional env vars supported by this script are:

- `TRAVIS_USER_PASSWORD` - a string (default "travis")
- `TRAVIS_OBFUSCATE_PASSWORD` - if non-empty, causes
  `TRAVIS_USER_PASSWORD` to be set to a random string

#### purging undesirable packages

The script at `./packer-scripts/purge` is responsible for purging packages that
are not desirable for the CI environment, such as the Chef that was installed
prior for the Chef provisioner.  Additionally, any package names present in
`/var/tmp/purge.txt` will be purged.  Optional env vars supported by this script
are:

- `APT_GET_UPGRADE_DURING_CLEANUP` - if non-empty, triggers an `apt-get -y
  upgrade` prior to package purging.
- `CLEAN_DEV_PACKAGES` - if non-empty, purges any packages matching `-dev$`

#### disabling apparmor

The script at `./packer-scripts/disable-apparmor` is responsible for disabling
apparmor if detected.  This is done primarily so that services such as
PostgreSQL and Docker may be used in the CI environment without first updating
apparmor configuration and restaring said services.

#### running server specs

The script at `./packer-scripts/run-serverspecs` is responsible for running the
serverspec suites via the rspec executable that is part of the `chefdk` package.
The list of operations is:

- install the `chefdk` package
- create a `sudo-bash` wrapper for use in some specs
- ensure all spec files are owned by `travis:travis`
- run each suite defined in `${SPEC_SUITES}`
- optionally remove the `chefdk` package

Optional env vars supported by this script are:

- `PACKER_CHEF_PREFIX` - directory in which to find packer chef stuff (default
  `/tmp`)
- `SPEC_RUNNER` - string used to wrap execution of rspec (default `sudo -u
  travis HOME=/home/travis -- bash -lc`)
- `SPEC_SUITES` - comma-delimited string of spec suites to run (default not set)
- `SKIP_CHEFDK_REMOVAL` - if non-empty do not remove the `chefdk` package and
  APT source

#### removing undesirable files

The script at `./packer-scripts/cleanup` is responsible for removing files and
directories that are unnecessary for the CI environment or otherwise add
unnecessary mass to the mastered image.  The list of operations is:

- recursively remove a bunch of files and directories
- conditionally remove `/var/lib/apt/lists/*`
- conditionally remove `/var/lib/man-db`
- conditionally remove `/home/travis/linux.iso` and `/home/travis/shutdown.sh`
- empty all files in `/var/log`

Optional env vars supported by this script are:

- `CLEANUP_APT_LISTS` - if non-empty, trigger removal of `/var/lib/apt/lists/*`
- `CLEANUP_MAN_DB` - if non-empty, trigger removal of `/var/lib/man-db`

#### minimizing image size

The script at `./packer-scripts/minimize` is responsible for reducing the size
of the provisioned image by squeezing out all of the empty space into a
contiguous area using the [same method as
bento](https://github.com/chef/bento/blob/0d78beb7df68b025a0354f8eee58d81102d192f1/scripts/common/minimize.sh).
The list of operations is:

- exit `0` if `$PACKER_BUILDER_TYPE` is either `googlecompute` or `amazon-ebs`,
  as minimizing like this is superfluous on those builders
- if `$PACKER_BUILDER_TYPE` is not `docker`, turn off swap and zero out the swap
  partition if available.
- write zeros to `/EMPTY` until the disk is out of space
- remove `/EMPTY` and run `sync`
- if the `vmware-toolbox-cmd` is available, run disk shrink operations for both
  `/` `/boot` paths.

#### registering the image with job-board

The script at `./bin/job-board-register` is responsible for "registering" the
mastered image in a post-processing step by making an HTTP request to the
[job-board](https://github.com/travis-ci/job-board) images API.  The list of
operations is:

- source any available env vars exported from the provisioned VM
- dump any env vars with prefixes `^(PACKER|TRAVIS|TAGS|IMAGE_NAME)`
- define a `TAGS` env var that will be used as the `tags` HTTP request param.
- define a URI-escaped query string from several env vars
- perform the HTTP request to job-board with `curl` and pipe the response
  through `jq`

Required env vars for this script are:

- `JOB_BOARD_IMAGES_URL` - the URL including `PATH_INFO` prefix to job-board
- `IMAGE_NAME` - the name of the image, typically the same as that used by the
  target infrastructure

Optional env vars supported by this script are:

- `PACKER_ENV_DIR` - path to the envdir containing packer-specific env vars,
  default `/.packer-env`
- `TAGS` - initial value for tags set during job-board registration
- `GROUP` - value used in `group` tag, default `edge` if edge conditions match,
  else `dev`
- `DIST` - value used in `dist` tag, default either Linux release codename or OS
  X product version
- `OS` - value used in `os` tag, default lowercase value of `uname`, mapped to
  `osx` on Darwin

For more info on the relationship between a given packer build artifact and
job-board, see [job-board details](#job-board-details) below.

###  job-board details

The [job-board](https://github.com/travis-ci/job-board) application is
responsible for tracking stack image metadata and presenting a queryable API
that is used by the [travis-worker API image
selector](https://github.com/travis-ci/worker/blob/master/image/api_selector.go).
As described above, each stack image is registered with job-board along with a
`group`, `os`, `dist`, and map of `tags`.  When travis-worker requests a stack
image identifier, it performs a series of queries with progressively lower
specificity.

Of the values assigned to each stack image, the `tags` map is perhaps most
mysterious, in part because it is so loosely defined.  This is intentional, as
the number of values that could be considered "tags" varies enough that
maintaining them all as individual columns would result in (opinions!) too much
overhead in the form of schema management and query complexity.

The implementation of the [job-board-register
script](./lib/job_board_registrar.rb) includes a process that converts the
`languages` and `features` arrays present in `/.job-board-register.yml`, written
from the values present in chef attributes at
`travis_packer_templates.job_board.{features,languages}`, into "sets"
represented as `{key} => true`.  For example, if a given wrapper cookbook
contains attributes like this:

``` ruby
override['travis_packer_templates']['job_board']['languages'] = %w(
  fribble
  snurp
  zzz
)
```

then the tags generated for registration with job-board would be equivalent to:

``` json
{
  "language_fribble": true,
  "language_snurp": true,
  "language_zzz": true
}
```

#### job-board tagsets

A "tagset" is the "set" (as in the type) of the "tags" applied during job-board
registration of a particular stack image, including `languages` and `features`.
At the time of this writing, both tagsets are used during serverspec runs, and
only the `languages` tagset is considered during selection via the job-board
API.

#### tagset relationships

Because the [travis-worker API image
selector](https://github.com/travis-ci/worker/blob/master/image/api_selector.go)
is querying job-board for stack images that match a particular language, it is
important for us to ensure reasonably consistent image selection by way of
asserting the `languages` values *do not* overlap between certain stacks (an
"exclusive" relationship).  Additionally, it is important that we ensure certain
stack `features` are subsets of others (an "inclusive" relationship).

Part of the CI process for *this* repository makes assertions about such
exclusive and inclusive relationships by way of the
[check-job-board-tags](./bin/check-job-board-tags) script.  The exact
relationships being enforced may be viewed like so:

``` bash
./bin/check-job-board-tags --list-only
```

##### exclusive relationships

An exclusive tagset relationship is equivalent to asserting that the set
intersection is the empty set, e.g.:

``` ruby
tagset_a = %w(a b c)
tagset_b = %w(d e f)
assert (tagset_a & tagset_b).empty?
```

##### inclusive relationships

An inclusive tagset relationship is equivalent to asserting that all members
of one tagset are present in another, or that a tagset's intersection with its
superset is equivalent to itself, e.g.:

``` ruby
tagset_a = %w(a b c d e f)
tagset_b = %w(f d b)
assert (tagset_a & tagset_b).sort == tagset_b.sort
```
