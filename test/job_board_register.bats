#!/usr/bin/env bats

setup() {
  export NOOP=1
  source "${PACKER_TEMPLATES_ROOT}/bin/job-board-register"
  mkdir -p test-envdir
  echo "${RANDOM}" > test-envdir/RANDOM_VALUE
  echo known-value > test-envdir/KNOWN_VALUE
  unset TAGS
  unset IMAGE_INFRA
  unset GROUP
  unset DIST
  unset OS
  unset TRAVIS_COOKBOOKS_BRANCH
  unset TRAVIS_COOKBOOKS_EDGE_BRANCH
  unset TRAVIS_COOKBOOKS_SHA
  unset PACKER_TEMPLATES_BRANCH
  unset PACKER_TEMPLATES_SHA
}

teardown() {
  rm -rf test-envdir
}

@test "job-board-register logging" {
  result="$(__log hello 2>&1)"
  [[ "${result}" =~ time=.*hello ]]
}

@test "job-board-register uri escaping" {
  result="$(__uri_esc 'do not!&weez the/juice???')"
  [ "${result}" = 'do%20not!%26weez%20the%2Fjuice%3F%3F%3F' ]
}

@test "job-board-register envdir loading" {
  __load_envdir test-envdir
  [ "${KNOWN_VALUE}" = known-value ]
  [ "${RANDOM_VALUE}" != "${RANDOM}" ]
}

@test "job-board-register uname" {
  [ "$(__uname)" ]
}

@test "job-board-register group" {
  [ "$(TRAVIS_COOKBOOKS_BRANCH=foo __group)" = dev ]
  [ "$(TRAVIS_COOKBOOKS_SHA=gfafafaf-dirty __group)" = dev ]
  [ "$(PACKER_TEMPLATES_BRANCH=floofluh __group)" = dev ]
  [ "$(PACKER_TEMPLATES_SHA=gfafafaf-dirty __group)" = dev ]

  result="$(
    TRAVIS_COOKBOOKS_BRANCH=master \
    TRAVIS_COOKBOOKS_EDGE_BRANCH=master \
    TRAVIS_COOKBOOKS_SHA=fafafaf \
    PACKER_TEMPLATES_BRANCH=master \
    PACKER_TEMPLATES_SHA=fafafaf __group
  )"
  echo "result: ${result} = edge"
  [ "${result}" = edge ]

  result="$(
    TRAVIS_COOKBOOKS_BRANCH=precise-stable \
    TRAVIS_COOKBOOKS_EDGE_BRANCH=precise-stable \
    TRAVIS_COOKBOOKS_SHA=fafafaf \
    PACKER_TEMPLATES_BRANCH=master \
    PACKER_TEMPLATES_SHA=fafafaf __group
  )"
  echo "result: ${result} = edge"
  [ "${result}" = edge ]
}

@test "job-board-register tag and infra definition" {
  __define_tags_and_infra
  echo "TAGS: ${TAGS}"
  echo "IMAGE_INFRA: ${IMAGE_INFRA}"
  [[ "${TAGS}" ]]
  [[ "${IMAGE_INFRA}" ]]
}
