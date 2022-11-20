# debugtrace-sh is a library that outputs trace logs when debugging your shell scripts.
#
# (C) 2020 Masato Kokubo

# The start message
readonly debugtrace_start_message='debugtrace-sh 1.0.0'

# The format string of log output when entering functions
debugtrace_enter_format='Enter ${FUNCNAME[1]} \(${BASH_SOURCE[1]}:$BASH_LINENO\)'

# The format string of log output when leaving functions
debugtrace_leave_format='Leave ${FUNCNAME[1]} \(${BASH_SOURCE[1]}:$BASH_LINENO\)'

# The date format string
debugtrace_datetime_format='%Y-%m-%d %H:%M:%S%z'

# The format string of print function suffix
debugtrace_print_surfix=' \(${BASH_SOURCE[1]}:$BASH_LINENO\)'

# The indentation string for one nest
debugtrace_indent_string='| '

# The separator string between the variable name and value
debugtrace_varname_value_separator=' = '

# The current nesint level
debugtrace_nest_level=0

# Becomes true after start
debugtrace_started=false

# Outputs the start message only the first time.
# Arguments: None
# Returns: None
function debugtrace_start() {
  if ! "$debugtrace_started"; then
    echo $debugtrace_start_message on `$SHELL --version | head -n 1`
    debugtrace_started=true
  fi
}

# By calling this function when entering an execution block such as a function, outputs an entering log.
# Arguments: None
# Returns: 0
function debugtrace_enter() {
  debugtrace_start
  echo "`debugtrace_print_current_datetime` `debugtrace_print_indent``eval echo $debugtrace_enter_format`"
  debugtrace_nest_level=$(($debugtrace_nest_level + 1))
  return 0
}

# By calling this function when leaving an execution block such as a function, outputs a leaving log.
# Arguments: None
# Returns: 0
function debugtrace_leave() {
  debugtrace_start
  debugtrace_nest_level=$(($debugtrace_nest_level - 1))
  echo "`debugtrace_print_current_datetime` `debugtrace_print_indent``eval echo $debugtrace_leave_format`"
  return 0
}

# Outputs the name and value if $2 is specified.
# Arguments:
#   $1: A messgae or name of the value (optional)
#   $2 A value (optional)
# Returns: 0
function debugtrace_print() {
  debugtrace_start
  local message="`debugtrace_print_current_datetime` `debugtrace_print_indent`"
  if [ $# -ge 1 ]; then
    message=$message$1
    if [ $# -ge 2 ]; then
      # name = value
      shift
      message="$message$debugtrace_varname_value_separator$*"
    fi
    message="$message `eval echo $debugtrace_print_surfix`"
  fi
  echo "$message"
  return 0
}

# Outputs the current date and time.
# Arguments: None
# Returns: 0
function debugtrace_print_current_datetime() {
  echo `date "+$debugtrace_datetime_format"`
  return 0
}

# Outputs an indent string for the current nesting level.
# Arguments: None
# Returns: 0
function debugtrace_print_indent() {
  local indent=""
  for ((index=0; index<$debugtrace_nest_level; ++index)); do
    indent="$indent$debugtrace_indent_string"
  done
  echo "$indent"
  return 0
}
