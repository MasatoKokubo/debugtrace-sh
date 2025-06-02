#!/bin/bash
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh

foo() {
  debugtrace_enter
  declare string=' AAA | BBB '
  debugtrace_print string "$string"

  declare integer=123456789123456789
  debugtrace_print integer $integer

  declare -a array=(1 B -3 D 5 E -6)
  debugtrace_print array ${array[@]}
  debugtrace_leave
}

foo
