#!/bin/bash

. ./cyber_dojo_helpers.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_START_POINT_CREATE_DIR() { :; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___SUCCESS_exits_zero() { :; }

test_____good_dir_with_new_name_creates_start_point_prints_nothing()
{
  local name=good
  local good_dir=./../rb/example_start_points/custom
  assertStartPointCreate ${name} --dir=${good_dir}
  assertNoStdout
  assertNoStderr
  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___FAILURE_prints_msg_to_stderr_and_exits_non_zero() { :; }

test_____good_dir_but_name_already_exists()
{
  local name=good
  local good_dir=./../rb/example_start_points/custom
  assertStartPointCreate ${name} --dir=${good_dir}
  refuteStartPointCreate ${name} --dir=${good_dir}
  assertNoStdout
  assertEqualsStderr "FAILED: a start-point called ${name} already exists"
  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____bad_dir_content()
{
  local name=bad
  local bad_dir=./../rb/example_start_points/bad_custom
  refuteStartPointExists ${name}
  refuteStartPointCreate ${name} --dir=${bad_dir}
  assertNoStdout
  assertStderrIncludes "FAILED..."
  assertStderrIncludes "Tennis/C#/manifest.json: Xdisplay_name: unknown key"
  assertStderrIncludes "Tennis/C#/manifest.json: display_name: missing"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ./shunit2_helpers.sh
. ./shunit2
