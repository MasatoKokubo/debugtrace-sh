source ../debugtrace.sh
debugtrace_enter_string='┌ '
debugtrace_leave_string='└ '
debugtrace_indent_string='│ '

foo() {
  debugtrace_enter
  debugtrace_print 'Hellow'
  debugtrace_print
  debugtrace_print 'World!'

  debugtrace_print '$#' $#
  debugtrace_print '$@' "$@"
  debugtrace_print '$*' "$*"
  

  declare -r file_name=file_example.txt
  debugtrace_print $file_name "`cat $file_name`"
  debugtrace_leave
}

foo "arg1*" "" "arg2?" '' "arg3<" ""
