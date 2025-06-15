#!/bin/bash
set -o nounset -o pipefail
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh
source $SCRIPT_DIR/debugtrace_option.sh

foo() {
  debugtrace_enter
  debugtrace_print 'Hellow'
  debugtrace_print
  debugtrace_print 'World!'

  debugtrace_print '$#' $#
  debugtrace_print '$@' "$@"
  debugtrace_print '$*' "$*"

  declare -r file_name=$SCRIPT_DIR/file_example.txt
  debugtrace_print $file_name "$(cat $file_name)"
  debugtrace_leave $?
}

foo "arg1*" "" "arg2?" '' "arg3<" ""
