# debugtrace-sh is a library that outputs trace logs to stderr when debugging your shell scripts.
#
# (C) 2020 Masato Kokubo

# The start message
declare -r debugtrace_start_message='debugtrace-sh 1.3.0'

# The string of log output when entering functions
declare debugtrace_enter_string='Enter '

# The format string of log output when entering functions (DO NOT CHANGE)
declare _debugtrace_enter_string

# The format string of log output when leaving functions
declare debugtrace_leave_string='Leave '

# The format string of log output when leaving functions (DO NOT CHANGE)
declare _debugtrace_leave_string

# The date format string
declare debugtrace_datetime_format='%Y-%m-%d %H:%M:%S%z'

# The format string of print suffix
declare debugtrace_print_surfix=' \(${BASH_SOURCE[1]}:$BASH_LINENO\)'

# The indentation string for one nest
declare debugtrace_indent_string='| '

# The separator string between the variable name and value
declare debugtrace_varname_value_separator=' = '

# The array element delimiter
declare debugtrace_elements_delimiter=', '

# The output destination
declare debugtrace_output_destination=/dev/stderr

# The current nesint level (DO NOT CHANGE)
declare -i _debugtrace_nest_level=0

# Becomes true after start (DO NOT CHANGE)
declare _debugtrace_started=false

# Outputs the start message only the first time.
# Arguments: None
debugtrace_start() {
  if ! "$_debugtrace_started"; then
    if [ -f "$debugtrace_output_destination" ]; then
      rm "$debugtrace_output_destination"
    fi
    _debugtrace_enter_string=$debugtrace_enter_string'${FUNCNAME[1]}'$debugtrace_print_surfix
    _debugtrace_leave_string=$debugtrace_leave_string'${FUNCNAME[1]}'$debugtrace_print_surfix
    echo "$debugtrace_start_message on $($SHELL --version | head -n 1)" >>"$debugtrace_output_destination"
    _debugtrace_started=true
  fi
}

# By calling this when entering an execution block such as a function, outputs an entering log.
# Arguments: None
debugtrace_enter() {
  debugtrace_start
  echo "$(debugtrace_datetime_indent)$(eval echo $_debugtrace_enter_string)" >>"$debugtrace_output_destination"
  _debugtrace_nest_level=$(($_debugtrace_nest_level + 1))
}

# By calling this when leaving an execution block such as a function, outputs a leaving log.
# Arguments: the return value
#   $1: The return value (optional)
# Return: $1 if specified, 0 otherwise
debugtrace_leave() {
  debugtrace_start
  _debugtrace_nest_level=$(($_debugtrace_nest_level - 1))
  echo "$(debugtrace_datetime_indent)$(eval echo $_debugtrace_leave_string)" >>"$debugtrace_output_destination"
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
  declare message="$(debugtrace_datetime_indent)"
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
        declare -i index
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
    message="$message $(eval echo $debugtrace_print_surfix)"
  fi
  echo "$message" >>"$debugtrace_output_destination"
}

# Outputs current datetime and the indent string for the current nesting level.
# Arguments: None
debugtrace_datetime_indent() {
  declare datetime_indent="$(date "+$debugtrace_datetime_format") "
  declare -i index
  for ((index=0; index<$_debugtrace_nest_level; ++index)); do
    datetime_indent="$datetime_indent$debugtrace_indent_string"
  done
  echo "$datetime_indent"
}
