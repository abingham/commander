#!/bin/bash

. ./cyber_dojo_helpers.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_UPDATE() { :; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___SUCCESS_exits_zero() { :; }

test_____help_arg_prints_use_to_stdout()
{
  local expected_stdout="
Use: cyber-dojo update

Updates all cyber-dojo docker images and the cyber-dojo script file"
  assertUpdate --help
  assertStdoutEquals "${expected_stdout}"
  assertNoStderr
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

x_test_____pull_latest_image_for_all_services()
{
  # This test turned off.
  # If it runs then the update will [docker pull] the commander
  # image from dockerhub which will overwrite the one created by
  # build.sh and the travis script will repush the old image!
  ${exe} update-images >${stdoutF} 2>${stderrF}
  assertStdoutIncludes 'latest: Pulling from cyberdojo/collector'
  assertStdoutIncludes 'latest: Pulling from cyberdojo/commander'
  assertStdoutIncludes 'latest: Pulling from cyberdojo/differ'
  assertStdoutIncludes 'latest: Pulling from cyberdojo/nginx'
  assertStdoutIncludes 'latest: Pulling from cyberdojo/runner'
  assertStdoutIncludes 'latest: Pulling from cyberdojo/storer'
  assertStdoutIncludes 'latest: Pulling from cyberdojo/web'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___FAILURE_prints_msg_to_stderr_and_exits_non_zero() { :; }

test_____unknown_arg()
{
  local arg=salmon
  refuteUpdate ${arg}
  assertNoStdout
  assertStderrEquals "FAILED: unknown argument [${arg}]"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____update_images_is_private_function()
{
  # update-images is only callable indirectly via
  # ./cyber-dojo update
  # after the command line arguments have been checked
  ${exe} update-images >${stdoutF} 2>${stderrF}
  assertFalse $?
  assertNoStdout
  assertStderrEquals 'FAILED: unknown argument [update-images]'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ./shunit2_helpers.sh
. ./shunit2
