#!/bin/bash
source ./debugtrace.sh
# debugtrace_enter_string='┌ '
# debugtrace_leave_string='└ '
# debugtrace_indent_string='│ '

function func1() {
    debugtrace::enter
    debugtrace::print 'I am func1.'
    func2
    debugtrace::leave
}

function func2() {
    debugtrace::enter
    debugtrace::print 'I am func2.'

    local foo="123"
    debugtrace::print foo "$foo"
    debugtrace::print

    local array=("a" "b" "c")
    debugtrace::print 'array[0]' "${array[0]}"
    debugtrace::print 'array[1]' "${array[1]}"
    debugtrace::print 'array[2]' "${array[2]}"
    debugtrace::print

    local FILE="./README.md"
    debugtrace::print "FILE ($FILE)" "`head $FILE`"

    debugtrace::leave
}

debugtrace::enter
func1
debugtrace::leave
