#!/bin/bash
set -o nounset -o pipefail
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh
source $SCRIPT_DIR/debugtrace_option.sh

function func1() {
    debugtrace_enter
    debugtrace_print 'I am func1.'
    func2
    debugtrace_leave $?
}

function func2() {
    debugtrace_enter
    debugtrace_print 'I am func2.'

    declare foo=123
    debugtrace_print foo $foo
    debugtrace_print

    declare array=('a' 'b' 'c')
    debugtrace_print 'array[0]' ${array[0]}
    debugtrace_print 'array[1]' ${array[1]}
    debugtrace_print 'array[2]' ${array[2]}
    debugtrace_print

    declare FILE=$SCRIPT_DIR/../README.md
    debugtrace_print "FILE ($FILE)" "$(head -n 5 $FILE | tail -n 1)"
    debugtrace_leave $?
}

debugtrace_enter
func1
debugtrace_leave $?
