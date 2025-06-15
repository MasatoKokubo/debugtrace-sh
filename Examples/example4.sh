#!/bin/bash
set -o nounset -o pipefail
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh
source $SCRIPT_DIR/debugtrace_option.sh

not_error() {
  debugtrace_enter
  head -n 1 $SCRIPT_DIR/../LICENSE
  debugtrace_leave $?
}

no_such_file() {
  debugtrace_enter
  head -n 1 $SCRIPT_DIR/../_LICENSE_
  debugtrace_leave $?
}

no_such_command() {
  debugtrace_enter
  _head_ -n 1 $SCRIPT_DIR/../LICENSE
  debugtrace_leave $?
}

debugtrace_print '----------------'
not_error
debugtrace_print 'not_error $?' $?
debugtrace_print '----------------'

no_such_file
debugtrace_print 'no_such_file $?' $?
debugtrace_print '----------------'

no_such_command
debugtrace_print 'no_such_command $?' $?
debugtrace_print '----------------'
