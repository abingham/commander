#!/bin/bash

# Some of these tests will fail
#   o) if you do not have a network connection
#   o) if github is down

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/cyber_dojo_helpers.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_START_POINT_CREATE_LIST() { :; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___success() { :; }

test_____new_name_list_from_path_creates_start_point_prints_each_url()
{
  local readonly name=jj
  local readonly url=`absPath ${MY_DIR}/../rb/example_start_points/languages_list`
  assertStartPointCreate ${name} --list=${url}
  assertStdoutIncludes 'https://github.com/cyber-dojo-languages/elm-test'
  assertStdoutIncludes 'https://github.com/cyber-dojo-languages/haskell-hunit'
  assertNoStderr
  assertStartPointExists ${name}
  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____new_name_list_from_file_url_creates_start_point_prints_each_url()
{
  local readonly name=jj
  local readonly url=`absPath ${MY_DIR}/../rb/example_start_points/languages_list`
  assertStartPointCreate ${name} --list=file://${url}
  assertStdoutIncludes 'https://github.com/cyber-dojo-languages/elm-test'
  assertStdoutIncludes 'https://github.com/cyber-dojo-languages/haskell-hunit'
  assertNoStderr
  assertStartPointExists ${name}
  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____new_name_list_from_network_url_creates_start_point_prints_each_url()
{
  local readonly name=jj
  local readonly url=https://raw.githubusercontent.com/cyber-dojo/start-points-languages/master/languages_list_test
  assertStartPointCreate ${name} --list=${url}
  assertStdoutIncludes 'https://github.com/cyber-dojo-languages/elm-test'
  assertStdoutIncludes 'https://github.com/cyber-dojo-languages/haskell-hunit'
  assertNoStderr
  assertStartPointExists ${name}
  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___failure() { :; }

test_____pathed_file_does_not_exist()
{
  local readonly name=jj
  local readonly file=/does/not/exist
  refuteStartPointCreate ${name} --list=${file}
  assertNoStdout
  assertStderrEquals "FAILED: ${file} does not exist"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____file_url_does_not_exist()
{
  local readonly name=jj
  local readonly file=file:///does/not/exist
  refuteStartPointCreate ${name} --list=${file}
  assertNoStdout
  assertStderrEquals "FAILED: ${file} does not exist"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____network_url_does_not_exist()
{
  local readonly name=jj
  local readonly file=https://raw.githubusercontent.com/cyber-dojo/start-points-languages/master/does_not_exist
  refuteStartPointCreate ${name} --list=${file}
  assertNoStdout
  assertStderrEquals "FAILED: ${file} does not exist"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____name_already_exists()
{
  local readonly name=jj
  local readonly url="${github_cyber_dojo}/start-points-exercises.git"
  assertStartPointCreate ${name} --git=${url}
  refuteStartPointCreate ${name} --list=${url}
  assertNoStdout
  assertStderrEquals "FAILED: a start-point called ${name} already exists"
  assertStartPointExists ${name}
  assertStartPointRm ${name}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ${MY_DIR}/shunit2_helpers.sh
. ${MY_DIR}/shunit2
