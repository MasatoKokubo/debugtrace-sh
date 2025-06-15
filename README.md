## debugtrace-sh

[Japanese](README_ja.md)

*debugtrace-sh* is a bash script library that outputs trace logs to `stderr` when debugging shell scripts.  
By embedding `debugtrace_enter` and `debugtrace_leave` at the start and end of functions, you can output the execution status of the shell script under development to the log.

### Features

* Automatically output the calling source file and line number.
* Automatically indent logs with nesting.

### How to use

* Click the latest version of the `zip` or `tar.gz` from [Releases](https://github.com/MasatoKokubo/debugtrace-bash/releases) and extract `debugtrace.sh` from the downloaded file.
* Place `debugtrace.sh` in the same directory as the shell scripts to be debugged or in any location.
* Insert the following into the script for which you want to output the debug log.
  1. `source <directory>/debugtrace.sh` at the beginning of script
  2. `Debugtrace_enter` at the beginning of scripts and functions
  3. `debugtrace_leave $?` at the end of scripts and functions
  4. `debugtrace_leave` just before `return` or `exit` 

_Example:_
```shell
#!/bin/bash
set -o nounset -o pipefail
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh
source $SCRIPT_DIR/debugtrace_option.sh

foo() {
  debugtrace_enter
  bar='a value'
  debugtrace_print bar "$bar"
  debugtrace_leave $?
}

debugtrace_enter
foo
debugtrace_leave
```

_debugtrace_opition.sh_
```shell
#debugtrace_output_destination=/dev/stderr
#debugtrace_output_destination=/dev/stdout
debugtrace_output_destination=/tmp/debugtrace.log

debugtrace_enter_string='┌ '
debugtrace_leave_string='└ '
debugtrace_datetime_format='%Y-%m-%d %H:%M:%S.%N%z'
debugtrace_print_surfix=' \(${BASH_SOURCE[1]}:$BASH_LINENO\)'
debugtrace_indent_string='│ '
debugtrace_varname_value_separator=' = '
debugtrace_elements_delimiter=', '
```

_Output (/tmp/debugtrace.log)_
```log
debugtrace-sh 1.3.0 on GNU bash, version 5.1.8(1)-release (x86_64-redhat-linux-gnu)
2025-06-16 07:54:10.326222661+0900 ┌ main (Examples/readme_example1.sh:14)
2025-06-16 07:54:10.329924004+0900 │ ┌ foo (Examples/readme_example1.sh:8)
2025-06-16 07:54:10.332389876+0900 │ │ bar = 'a value' (Examples/readme_example1.sh:10)
2025-06-16 07:54:10.334506128+0900 │ └ foo (Examples/readme_example1.sh:11)
2025-06-16 07:54:10.337021584+0900 └ main (Examples/readme_example1.sh:16)
```

### Example of using `debugtrace_print` function

#### Output messages and line break
```shell
debugtrace_print "Hellow"
debugtrace_print
debugtrace_print 'World!'
```
```log
2025-01-05 12:03:46+0900 Hellow (./readme_example2.sh:10)
2025-01-05 12:03:46+0900 
2025-01-05 12:03:46+0900 World! (./readme_example2.sh:12)
```

#### Output all arguments of function
```shell
debugtrace_print '$@' "$@"
debugtrace_print '$*' "$*"
```
```log
2025-01-05 12:03:46+0900 $@ = ['arg1', 'arg2', 'arg3'] (./readme_example2.sh:5)
2025-01-05 12:03:46+0900 $* = arg1 arg2 arg3' (./readme_example2.sh:6)
```

#### Output a file contents 
```shell
declare -r file_name=file_example.txt
debugtrace_print "$file_name" "`cat $file_name`"
```
```log
2025-01-05 12:03:46+0900 file_example.txt = 'Foo
Bar
Baz' (./readme_example2.sh:18)
```

#### Output an array
```shell
declare -a array=(1 B 3 D 5)
debugtrace_print array ${array[@]}
```
```log
2025-01-05 12:03:46+0900 array = [1, 'B', 3, 'D', 5] (./readme_example2.sh:22)
```

### Customizing the outputs
After executing `source .../debugtrace.sh`, you can customize the log output by substituting the variables defined in `debugtrace.sh`. The customizable variables are as follows.
<table>
  <caption>Customizable Variables</caption>
  <thead>
    <tr><th>Variable Name</th><th>Contents</th><th>Initial Value</tr>
  </thead>
  <tr>
    <td><code>debugtrace_enter_string</code></td>
    <td>The start string to be output by the <code>debugtrace_enter</code> function</td>
    <td><code>'Enter '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_leave_string</code></td>
    <td>The start string to be output by the <code>debugtrace_leave</code> function</td>
    <td><code>'Leave '</td>
  </tr>
  <tr>
    <td><code>debugtrace_datetime_format</code></td>
    <td>Log date format</td>
    <td><code>'%Y-%m-%d %H:%M:%S%z'</td>
  </tr>
  <tr>
    <td><code>debugtrace_print_surfix</code></td>
    <td><code>The string to append to the end of log lines.</td>
    <td><code style="white-space:nowrap">' \(${BASH_SOURCE[1]}:$BASH_LINENO\)'</td>
  </tr>
  <tr>
    <td><code>debugtrace_indent_string</code></td>
    <td>String with one indent</td>
    <td><code>'| '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_varname_value_separator</code></td>
    <td>Separator string between variable name and value</td>
    <td><code>' = '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_elements_delimiter</code></td>
    <td>The string that separates array elements</td>
    <td><code>', '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_output_destination</code></td>
    <td>The output destination</td>
    <td><code>/dev/stderr</code></td>
  </tr>
</table>

### License
[MIT License (MIT)](LICENSE) 
