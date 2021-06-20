#!/bin/bash
source ./debugtrace.sh # ToDo: Remove after debugging

function foo() {
  debugtrace::print "Hellow"
  debugtrace::print
  debugtrace::print 'World!'

  debugtrace::print '$#' $# # ToDo: Remove after debugging
  debugtrace::print '$@' $@ # ToDo: Remove after debugging
  debugtrace::print '$*' $* # ToDo: Remove after debugging
  

  local readonly file_name=./file_example.txt
  debugtrace::print "$file_name" "`cat $file_name`" # ToDo: Remove after debugging
  return 0
}

foo "arg1" "arg2" "arg3"
