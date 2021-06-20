#!/bin/bash
source ./debugtrace.sh # ToDo: Remove after debugging

function foo() {
  debugtrace::enter # ToDo: Remove after debugging
  bar="a value"
  debugtrace::print bar "$bar"
  debugtrace::leave # ToDo: Remove after debugging
  return 0
}

debugtrace::enter # ToDo: Remove after debugging
foo
debugtrace::leave # ToDo: Remove after debugging
