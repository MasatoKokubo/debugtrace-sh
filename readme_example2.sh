source ./debugtrace.sh # ToDo: Remove after debugging

function foo() {
  debugtrace_print "Hellow" # ToDo: Remove after debugging
  debugtrace_print # ToDo: Remove after debugging
  debugtrace_print 'World!' # ToDo: Remove after debugging

  debugtrace_print '$#' $# # ToDo: Remove after debugging
  debugtrace_print '$@' $@ # ToDo: Remove after debugging
  debugtrace_print '$*' $* # ToDo: Remove after debugging
  

  local readonly file_name=./file_example.txt
  debugtrace_print "$file_name" "`cat $file_name`" # ToDo: Remove after debugging
  return 0
}

foo "arg1*" "" "arg2?" '' "arg3<" ""
