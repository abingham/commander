
MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

readonly github_cyber_dojo=https://github.com/cyber-dojo
readonly raw_github_cd_org=https://raw.githubusercontent.com/cyber-dojo
readonly exe="${MY_DIR}/../../cyber-dojo"

# - - - - - - - - - - - - - - - - - - - - - - - - -

CD_DIR()
{
  echo "$( cd "${MY_DIR}" && cd ../../../../cyber-dojo && pwd )"
}

CDL_DIR()
{
  echo "$(cd "${MY_DIR}" && cd ../../../../cyber-dojo-languages && pwd )"
}


on_CI()
{
  [[ ! -z "${CIRCLE_SHA1}" ]] || [[ ! -z "${TRAVIS}" ]]
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

custom_urls()
{
  if on_CI; then
    echo -n "${github_cyber_dojo}/custom"
  else
    echo -n "file://$(CD_DIR)/custom"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

exercises_urls()
{
  if on_CI; then
    echo -n "${github_cyber_dojo}/exercises"
  else
    echo -n "file://$(CD_DIR)/exercises"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

languages_urls()
{
  if on_CI; then
    echo -n $(curl --silent "${raw_github_cd_org}/languages/master/url_list/small")
  else
    echo -n "file://$(CDL_DIR)/gcc-assert \
             file://$(CDL_DIR)/python-unittest \
             file://$(CDL_DIR)/ruby-minitest"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a service_names=(
  differ
  grafana
  mapper
  nginx
  prometheus
  ragger
  runner
  saver
  web
  zipper
)

# - - - - - - - - - - - - - - - - - - - - - - - - -

clean()             { ${exe} clean               $* >${stdoutF} 2>${stderrF}; }
down()              { ${exe} down                $* >${stdoutF} 2>${stderrF}; }
logs()              { ${exe} logs                $* >${stdoutF} 2>${stderrF}; }
sh()                { ${exe} sh                  $* >${stdoutF} 2>${stderrF}; }
startPoint()        { ${exe} start-point         $* >${stdoutF} 2>${stderrF}; }
startPointCreate()  { ${exe} start-point create  $* >${stdoutF} 2>${stderrF}; }
startPointInspect() { ${exe} start-point inspect $* >${stdoutF} 2>${stderrF}; }
startPointLs()      { ${exe} start-point ls      $* >${stdoutF} 2>${stderrF}; }
startPointRm()      { ${exe} start-point rm      $* >${stdoutF} 2>${stderrF}; }
startPointUpdate()  { ${exe} start-point update  $* >${stdoutF} 2>${stderrF}; }
up()                { ${exe} up                  $* >${stdoutF} 2>${stderrF}; }
update()            { ${exe} update              $* >${stdoutF} 2>${stderrF}; }

# - - - - - - - - - - - - - - - - - - - - - - - - -

assertStartPointCreate()  { startPointCreate  $*; assertTrue  $?; }
refuteStartPointCreate()  { startPointCreate  $*; assertFalse $?; }

assertStartPoint()        { startPoint        $*; assertTrue  $?; }
refuteStartPoint()        { startPoint        $*; assertFalse $?; }

assertStartPointInspect() { startPointInspect $*; assertTrue  $?; }
refuteStartPointInspect() { startPointInspect $*; assertFalse $?; }

assertStartPointLs()      { startPointLs      $*; assertTrue  $?; }
refuteStartPointLs()      { startPointLs      $*; assertFalse $?; }

assertStartPointRm()      { startPointRm      $*; assertTrue  $?; }
refuteStartPointRm()      { startPointRm      $*; assertFalse $?; }

assertStartPointUpdate()  { startPointUpdate  $*; assertTrue  $?; }
refuteStartPointUpdate()  { startPointUpdate  $*; assertFalse $?; }

assertStartPointExists()  { startPointExists  $1; assertTrue  $?; }
refuteStartPointExists()  { startPointExists  $1; assertFalse $?; }

# - - - - - - - - - - - - - - - - - - - - - - - - -

assertClean()  { clean  $*; assertTrue  $?; }
refuteClean()  { clean  $*; assertFalse $?; }

assertDown()   { down   $*; assertTrue  $?; }
refuteDown()   { down   $*; assertFalse $?; }

assertLogs()   { logs   $*; assertTrue  $?; }
refuteLogs()   { logs   $*; assertFalse $?; }

assertSh()     { sh     $*; assertTrue  $?; }
refuteSh()     { sh     $*; assertFalse $?; }

assertUp()     { up     $*; assertTrue  $?; }
refuteUp()     { up     $*; assertFalse $?; }

assertUpdate() { update $*; assertTrue  $?; }
refuteUpdate() { update $*; assertFalse $?; }

# - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - -

removeAllStartPoints()
{
  startPoints=(`${exe} start-point ls --quiet`)
  for startPoint in "${startPoints[@]}"
  do
    ${exe} start-point rm "${startPoint}"
  done
}

startPointExists()
{
  # don't match a substring
  local readonly start_of_line='^'
  local readonly name=$1
  local readonly end_of_line='$'
  docker image ls --format '{{.Repository}}:{{.Tag}}' \
    | grep "${start_of_line}${name}${end_of_line}" > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

assert()
{
  if [ "$1" == "0" ]; then
    echo "<stdout>"
    cat ${stdoutF}
    echo "</stdout>"
    echo "<stderr>"
    cat ${stderrF}
    echo "</stderr>"
    #TODO: print 'original' arguments
    assertTrue 1
  fi
}

refute()
{
  if [ "$1" == "0" ]; then
    echo "<stdout>"
    cat ${stdoutF}
    echo "</stdout>"
    echo "<stderr>"
    cat ${stderrF}
    echo "</stderr>"
    #TODO: print 'original' arguments
    assertFalse 0
  fi
}
