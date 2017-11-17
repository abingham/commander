#!/bin/bash

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/cyber_dojo_helpers.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_START_POINT_LS() { :; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___success() { :; }

test_____help_arg_prints_use()
{
  local readonly expected_stdout="
Use: cyber-dojo start-point [OPTIONS] ls

Lists the name, type, and source of all cyber-dojo start-points

  --quiet     Only display start-point names"
  assertStartPointLs --help
  assertStdoutEquals "${expected_stdout}"
  assertNoStderr
}

test_____no_args_prints_nothing_when_no_volumes()
{
  assertStartPointLs
  assertNoStdout
  assertNoStderr
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____quiet_arg_prints_nothing_when_no_volumes()
{
  assertStartPointLs --quiet
  assertNoStdout
  assertNoStderr
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____quiet_arg_prints_just_names_when_volumes_exist()
{
  local readonly name=jj
  local readonly url="${github_cyber_dojo}/start-points-exercises.git"
  assertStartPointCreate ${name} --git=${url}
  assertStartPointLs --quiet
  assertStdoutEquals 'jj'
  assertNoStderr

  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____no_arg_prints_heading_and_names_types_sources()
{
  local readonly name=jj
  local readonly url="${github_cyber_dojo}/start-points-exercises.git"
  assertStartPointCreate ${name} --git=${url}
  assertStartPointLs
  assertStdoutIncludes 'NAME   TYPE        SRC'
  # TODO: fix this. SRC is missing
  assertStdoutIncludes 'jj     exercises'
  #assertStdoutIncludes 'jj     exercises   https://github.com/cyber-dojo/start-points-exercises.git'
  assertNoStderr

  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___failure() { :; }

test_____unknown_arg()
{
  local readonly arg=salmo
  refuteStartPointLs ${arg}
  assertNoStdout
  assertStderrEquals "FAILED: unknown argument [${arg}]"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____unknown_args()
{
  local readonly arg1=salmon
  local readonly arg2=spey
  refuteStartPointLs ${arg1} ${arg2}
  assertNoStdout
  assertStderrIncludes "FAILED: unknown argument [${arg1}]"
  assertStderrIncludes "FAILED: unknown argument [${arg2}]"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ${MY_DIR}/shunit2_helpers.sh
. ${MY_DIR}/shunit2
