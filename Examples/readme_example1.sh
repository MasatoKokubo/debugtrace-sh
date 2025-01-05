source ../debugtrace.sh

foo() {
  debugtrace_enter
  declare bar='a value'
  debugtrace_print bar "$bar"
  debugtrace_leave
}

debugtrace_enter
foo
debugtrace_leave
