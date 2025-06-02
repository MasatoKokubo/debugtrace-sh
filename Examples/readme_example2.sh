#!/bin/bash
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh

foo() {
  # Output all arguments of the function
  debugtrace_print '$@' "$@"
  debugtrace_print '$*' "$*"
}

# Output messages and line break
debugtrace_print "Hellow"
debugtrace_print
debugtrace_print 'World!'

foo arg1 arg2 arg3

# Output a file contents
declare -r file_name=$SCRIPT_DIR/file_example.txt
debugtrace_print "$file_name" "`cat $file_name`"

# Output an array
declare -a array=(1 B 3 D 5)
debugtrace_print array ${array[@]}
