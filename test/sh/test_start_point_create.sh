#!/bin/bash

# Some of these tests will fail
#   o) if you do not have a network connection
#   o) if github is down

. ./cyber_dojo_helpers.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_START_POINT_CREATE() { :; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___success() { :; }

test_____help_arg_prints_use()
{
  local expected_stdout="
Use: cyber-dojo start-point create NAME --list=FILE
Creates a start-point named NAME from the URLs listed in FILE

Use: cyber-dojo start-point create NAME --git=URL
Creates a start-point named NAME from a git clone of URL

Use: cyber-dojo start-point create NAME --dir=DIR
Creates a start-point named NAME from a copy of DIR

NAME's first letter must be [a-zA-Z0-9]
NAME's remaining letters must be [a-zA-Z0-9_.-]
NAME must be at least two letters long"

  assertStartPointCreate
  assertStdoutEquals "${expected_stdout}"
  assertNoStderr

  assertStartPointCreate --help
  assertStdoutEquals "${expected_stdout}"
  assertNoStderr
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test___failure() { :; }

test_____illegal_name_first_letter()
{
  refuteStartPointCreate +bad
  assertNoStdout
  assertStderrEquals 'FAILED: +bad is an illegal NAME'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____illegal_name_second_letter()
{
  refuteStartPointCreate b+ad
  assertNoStdout
  assertStderrEquals 'FAILED: b+ad is an illegal NAME'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____illegal_name_one_letter_name()
{
  refuteStartPointCreate b
  assertNoStdout
  assertStderrEquals 'FAILED: b is an illegal NAME'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____unknown_arg()
{
  refuteStartPointCreate jj --where=tay
  assertNoStdout
  assertStderrEquals 'FAILED: unknown argument [--where]'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____unknown_args()
{
  refuteStartPointCreate jj --where=tay --there=x
  assertNoStdout
  assertStderrIncludes 'FAILED: unknown argument [--where]'
  assertStderrIncludes 'FAILED: unknown argument [--there]'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_____dir_and_git_args()
{
  refuteStartPointCreate jj --dir=where --git=url
  assertNoStdout
  assertStderrEquals 'FAILED: specify ONE of --git= / --dir= / --list='
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ./shunit2_helpers.sh
. ./shunit2
