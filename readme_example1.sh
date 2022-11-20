source ./debugtrace.sh # ToDo: Remove after debugging

function foo() {
  debugtrace_enter # ToDo: Remove after debugging
  bar="a value"
  debugtrace_print bar "$bar" # ToDo: Remove after debugging
  debugtrace_leave # ToDo: Remove after debugging
  return 0
}

debugtrace_enter # ToDo: Remove after debugging
foo
debugtrace_leave # ToDo: Remove after debugging
