#!/usr/bin/env bats

setup() {
  export NOOP=1
  source "${PACKER_TEMPLATES_ROOT}/bin/job-board-register"
  mkdir -p test-envdir
  echo "${RANDOM}" > test-envdir/RANDOM_VALUE
  echo known-value > test-envdir/KNOWN_VALUE
}

teardown() {
  rm -rf test-envdir
}

@test "job-board-register logging" {
  result="$(__log hello)"
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
