# packer-templates

Collection of Packer templates used for various infrastructure layers.

## YML to JSON 

Each Packer template JSON file is generated from a corresponding ERB-filtered
YAML file.  The primary reason for this is YAML's support for comments,
references, and generally more flexible data structures.  That being said, the
structure of the single YAML document is analogous to the JSON structure
expected by packer, and no further magic or indirection is expected or
supported.

Editing a given JSON file directly is *doing it wrong* :no_entry_sign:.
Instead, edit the YAML file and then run `make`, or alternatively use inline fd
docs for a slightly faster feedback loop, e.g.:

``` bash
packer build -only=docker <(bin/yml2json < ci-minimal.yml)
```

## env config bits

Most of the templates in here require some env vars.  Take a look at
[`.example.env`](./.example.env) for an example.  Use of
[autoenv](https://github.com/kennethreitz/autoenv) is encouraged but not
required.
