#!/bin/bash
#
# DebugTrace-bash is a library that outputs trace logs when debugging your bash scripts.
#
# (C) 2020 Masato Kokubo

# The start message
readonly debugtrace_start_message='DebugTrace=bash 1.0.0-alpha1'

# The format string of log output when entering functions
debugtrace_enter_format='Enter ${FUNCNAME[1]} ❪${BASH_SOURCE[1]}:$BASH_LINENO❫'

# The format string of log output when leaving functions
debugtrace_leave_format='Leave ${FUNCNAME[1]} ❪${BASH_SOURCE[1]}:$BASH_LINENO❫'

# The format string of print function suffix
debugtrace_print_surfix=' ❪${BASH_SOURCE[1]}:$BASH_LINENO❫'

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
function debugtrace:::start() {
  if ! "$debugtrace_started"; then
    echo $debugtrace_start_message
    debugtrace_started=true
  fi
}

# By calling this function when entering an execution block such as a function, outputs an entering log.
# Arguments: None
# Returns: None
function debugtrace::enter() {
  debugtrace:::start
  echo "`debugtrace::get_indent``eval echo $debugtrace_enter_format`"
  debugtrace_nest_level=$(($debugtrace_nest_level + 1))
  return 0
}

# By calling this function when leaving an execution block such as a function, outputs a leaving log.
# Arguments: None
# Returns: None
function debugtrace::leave() {
  debugtrace_nest_level=$(($debugtrace_nest_level - 1))
  echo "`debugtrace::get_indent``eval echo $debugtrace_leave_format`"
  return 0
}

# Outputs the name and value if $2 is specified.
# Outputs the message if $2 is not specified.
# Arguments:
#   $1: The name (The message if $2 is not specified)
#   $2: The value
# Returns: None
function debugtrace::print() {
  if [ "$2" = "" ]; then
    echo "`debugtrace::get_indent`$1 `eval echo $debugtrace_print_surfix`"
  else
    echo "`debugtrace::get_indent`$1$debugtrace_varname_value_separator$2 `eval echo $debugtrace_print_surfix`"
  fi
  return 0
}

# Returns an indent string for the current nesting level.
# Arguments: None
# Returns: An indent string for the current nesting level
function debugtrace::get_indent() {
  local indent=""
  for ((index=0; index<$debugtrace_nest_level; ++index)); do
    indent="$indent$debugtrace_indent_string"
  done
  echo "$indent"
  return 0
}
