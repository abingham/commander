#!/bin/bash

. ./cyber_dojo_helpers.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_CYBER_DOJO_START_POINT_CREATE_DIR()
{
  :
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

startPointCreateDir()
{
  local name=$1
  local dir=$2
  ${exe} start-point create ${name} --dir=${dir} >${stdoutF} 2>${stderrF}
}

test_from_good_dir_with_new_name_creates_start_point_prints_nothing_and_exits_zero()
{
  local name=good
  local good_dir=./../rb/example_start_points/custom

  refuteStartPointExists ${name}
  startPointCreateDir ${name} ${good_dir}
  assertTrue $?
  assertNoStdout
  assertNoStderr
  assertStartPointExists ${name}

  startPointRm ${name}
  refuteStartPointExists ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_from_good_dir_but_name_exists_prints_msg_to_stderr_and_exits_non_zero()
{
  local name=good
  local good_dir=./../rb/example_start_points/custom

  refuteStartPointExists ${name}
  startPointCreateDir ${name} ${good_dir}
  assertStartPointExists ${name}

  local expected_stderr="FAILED: a start-point called ${name} already exists"

  startPointCreateDir ${name} ${good_dir}
  assertFalse $?
  assertNoStdout
  assertEqualsStderr "${expected_stderr}"
  assertStartPointExists ${name}

  startPointRm ${name}
  refuteStartPointExists ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_from_bad_dir_prints_msg_to_stderr_and_exits_non_zero()
{
  local expected_stderr="FAILED...
/data/Tennis/C#/manifest.json: Xfilename_extension: unknown key"
  # TODO: lose /data/ from output?
  # TODO: secretly pass host path to commander?

  local name=bad
  local bad_dir=./../rb/example_start_points/bad_custom

  refuteStartPointExists ${name}
  startPointCreateDir ${name} ${bad_dir}
  assertFalse $?
  assertNoStdout
  assertEqualsStderr "${expected_stderr}"
  refuteStartPointExists ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ./shunit2_helpers.sh
. ./shunit2
