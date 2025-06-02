# debugtrace-sh is a library that outputs trace logs to stderr when debugging your shell scripts.
#
# (C) 2020 Masato Kokubo

# The start message
declare -gr debugtrace_start_message='debugtrace-sh 1.2.0'

# The string of log output when entering functions
declare -g debugtrace_enter_string='Enter '

# The format string of log output when entering functions (DO NOT CHANGE)
declare -g _debugtrace_enter_string

# The format string of log output when leaving functions
declare -g debugtrace_leave_string='Leave '

# The format string of log output when leaving functions (DO NOT CHANGE)
declare -g _debugtrace_leave_string

# The date format string
declare -g debugtrace_datetime_format='%Y-%m-%d %H:%M:%S%z'

# The format string of print suffix
declare -g debugtrace_print_surfix=' \(${BASH_SOURCE[1]}:$BASH_LINENO\)'

# The indentation string for one nest
declare -g debugtrace_indent_string='| '

# The separator string between the variable name and value
declare -g debugtrace_varname_value_separator=' = '

# The array element delimiter
declare -g debugtrace_elements_delimiter=', '

# The current nesint level (DO NOT CHANGE)
declare -g _debugtrace_nest_level=0

# Becomes true after start (DO NOT CHANGE)
declare -g _debugtrace_started=false

# Outputs the start message only the first time.
# Arguments: None
# Returns: None
debugtrace_start() {
  if ! "$_debugtrace_started"; then
    _debugtrace_enter_string=$debugtrace_enter_string'${FUNCNAME[1]}'$debugtrace_print_surfix
    _debugtrace_leave_string=$debugtrace_leave_string'${FUNCNAME[1]}'$debugtrace_print_surfix
    echo $debugtrace_start_message on `$SHELL --version | head -n 1` >&2
    _debugtrace_started=true
  fi
}

# By calling this when entering an execution block such as a function, outputs an entering log.
# Arguments: None
debugtrace_enter() {
  debugtrace_start
  echo "`debugtrace_print_current_datetime` `debugtrace_print_indent``eval echo $_debugtrace_enter_string`" >&2
  _debugtrace_nest_level=$(($_debugtrace_nest_level + 1))
}

# By calling this when leaving an execution block such as a function, outputs a leaving log.
# Arguments: the return value
#   $1: The return value (optional)
# Return: $1 if specified, 0 otherwise
debugtrace_leave() {
  debugtrace_start
  _debugtrace_nest_level=$(($_debugtrace_nest_level - 1))
  echo "`debugtrace_print_current_datetime` `debugtrace_print_indent``eval echo $_debugtrace_leave_string`" >&2
  if [[ $# -ge 1 ]]; then
    return $1
  fi
}

# Outputs the name and value if $2 is specified.
# Arguments:
#   $1: A messgae or the name of the value (optional)
#   $2: A value (optional)
debugtrace_print() {
  debugtrace_start
  declare message="`debugtrace_print_current_datetime` `debugtrace_print_indent`"
  if [[ $# -ge 1 ]]; then
    message=$message$1
    if [[ $# -ge 2 ]]; then
      # name = value
      shift
      if [[ $# == 1 ]]; then
        # the value is not an array
        message=$message$debugtrace_varname_value_separator
        [ "$1" -eq 0 ] 2>/dev/null
        if [ $? -ge 2 ]; then
          # the value is not an integer
          message=$message\'$1\'
        else 
          # the value is an integer
          message=$message$1
        fi
      else
        # the value is an array
        declare -a array=("$@")
        declare delimiter=''
        declare index
        message="$message$debugtrace_varname_value_separator["
        for ((index=0; index<${#array[@]}; ++index)); do
          message=$message$delimiter
          [ "${array[$index]}" -eq 0 ] 2>/dev/null
          if [ $? -ge 2 ]; then
            # the element value is not an integer
            message=$message\'${array[$index]}\'
          else
            # the element value is an integer
            message=$message${array[$index]}
          fi
          delimiter=$debugtrace_elements_delimiter
        done
        message=$message"]"
      fi
    fi
    message="$message `eval echo $debugtrace_print_surfix`"
  fi
  echo "$message" >&2
}

# Outputs the current date and time.
# Arguments: None
debugtrace_print_current_datetime() {
  echo `date "+$debugtrace_datetime_format"`
}

# Outputs an indent string for the current nesting level.
# Arguments: None
debugtrace_print_indent() {
  declare indent=''
  declare index
  for ((index=0; index<$_debugtrace_nest_level; ++index)); do
    indent="$indent$debugtrace_indent_string"
  done
  echo "$indent"
}
