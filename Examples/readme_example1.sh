#!/bin/bash
set -o nounset -o pipefail
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh
source $SCRIPT_DIR/debugtrace_option.sh

foo() {
  debugtrace_enter
  bar='a value'
  debugtrace_print bar "$bar"
  debugtrace_leave $?
}

debugtrace_enter
foo
debugtrace_leave
