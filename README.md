## debugtrace-sh

[Japanese](README_ja.md)

*debugtrace-sh* is a shell script library that outputs trace logs to `stderr` when debugging shell scripts.  
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
  3. `debugtrace_leave` at the end of scripts and functions
  4. `debugtrace_leave` just before `return` or `exit` 

_Example:_
```shell
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
```

_Output (Linux/bash):_
```log
debugtrace-sh 1.1.0 on GNU bash, version 5.2.21(1)-release (x86_64-pc-linux-gnu)
2025-01-05 11:44:33+0900 Enter main (./readme_example1.sh:10)
2025-01-05 11:44:33+0900 | Enter foo (./readme_example1.sh:4)
2025-01-05 11:44:33+0900 | | bar = 'a value' (./readme_example1.sh:6)
2025-01-05 11:44:33+0900 | Leave foo (./readme_example1.sh:7)
2025-01-05 11:44:33+0900 Leave main (./readme_example1.sh:12)
```

_Output (macOS/zsh):_
```log
debugtrace-sh 1.1.0 on zsh 5.9 (arm64-apple-darwin24.0)
2025-01-05 11:46:06+0900 Enter main (./readme_example1.sh:10)
2025-01-05 11:46:06+0900 | Enter foo (./readme_example1.sh:4)
2025-01-05 11:46:06+0900 | | bar = 'a value' (./readme_example1.sh:6)
2025-01-05 11:46:06+0900 | Leave foo (./readme_example1.sh:7)
2025-01-05 11:46:06+0900 Leave main (./readme_example1.sh:12)
```

_Output (macOS/tcsh):_
```log
debugtrace-sh 1.1.0 on tcsh 6.21.00 (Astron) 2019-05-08 (unknown-apple-darwin) options wide,nls,dl,bye,al,kan,sm,rh,color,filec
2025-01-05 11:46:57+0900 Enter main (./readme_example1.sh:10)
2025-01-05 11:46:57+0900 | Enter foo (./readme_example1.sh:4)
2025-01-05 11:46:57+0900 | | bar = 'a value' (./readme_example1.sh:6)
2025-01-05 11:46:57+0900 | Leave foo (./readme_example1.sh:7)
2025-01-05 11:46:57+0900 Leave main (./readme_example1.sh:12)
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
</table>

### License
[MIT License (MIT)](LICENSE) 
