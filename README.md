## debugtrace-sh

[Japanese](README_ja.md)

*debugtrace-sh* is a library that outputs trace logs when debugging shell scripts.  
By embedding `debugtrace_enter` and `debugtrace_leave` at the start and end of functions, you can output the execution status of the shell script under development to the log.

### Features

* Automatically output the calling source file and line number.
* Automatically indent logs with function nesting.

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
```

_Output (Ubuntu/bash):_
```log
debugtrace-sh 1.0.0 on GNU bash, version 5.1.16(1)-release (x86_64-pc-linux-gnu)
2022-11-20 11:16:32+0900 Enter main (./readme_example1.sh:11)
2022-11-20 11:16:32+0900 | Enter foo (./readme_example1.sh:4)
2022-11-20 11:16:32+0900 | | bar = a value (./readme_example1.sh:6)
2022-11-20 11:16:32+0900 | Leave foo (./readme_example1.sh:7)
2022-11-20 11:16:32+0900 Leave main (./readme_example1.sh:13)
```

_Output (macOS/zsh):_
```log
debugtrace-sh 1.0.0 on zsh 5.8.1 (x86_64-apple-darwin21.0)
2022-11-20 11:25:27+0900 Enter main (./readme_example1.sh:11)
2022-11-20 11:25:27+0900 | Enter foo (./readme_example1.sh:4)
2022-11-20 11:25:27+0900 | | bar = a value (./readme_example1.sh:6)
2022-11-20 11:25:27+0900 | Leave foo (./readme_example1.sh:7)
2022-11-20 11:25:27+0900 Leave main (./readme_example1.sh:13)
```

_Output (macOS/tcsh):_
```log
debugtrace-sh 1.0.0 on tcsh 6.21.00 (Astron) 2019-05-08 (x86_64-apple-darwin) options wide,nls,dl,bye,al,kan,sm,rh,color,filec
2022-11-20 11:23:59+0900 Enter main (./readme_example1.sh:11)
2022-11-20 11:23:59+0900 | Enter foo (./readme_example1.sh:4)
2022-11-20 11:23:59+0900 | | bar = a value (./readme_example1.sh:6)
2022-11-20 11:23:59+0900 | Leave foo (./readme_example1.sh:7)
2022-11-20 11:23:59+0900 Leave main (./readme_example1.sh:13)
```

### Example of using `debugtrace_print` function

#### Output messages and line break
```shell
debugtrace_print "Hellow"
debugtrace_print
debugtrace_print 'World!'
```
```log
2021-06-20 09:21:09+0900 Hellow (./readme_example2.sh:5)
2021-06-20 09:21:09+0900 
2021-06-20 09:21:09+0900 World! (./readme_example2.sh:7)
```

#### Output all arguments of function
```shell
debugtrace_print '$@' $@ # ToDo: Remove after debugging
debugtrace_print '$*' $* # ToDo: Remove after debugging
```
```log
2021-06-20 09:21:09+0900 $@ = arg1 arg2 arg3 (./readme_example2.sh:10)
2021-06-20 09:21:09+0900 $* = arg1 arg2 arg3 (./readme_example2.sh:11)
```

#### Output the file contents 
```shell
local readonly file_name=./file_example.txt
debugtrace_print "$file_name" "`cat $file_name`" # ToDo: Remove after debugging
```
```log
2021-06-19 18:26:57+0900 ./file_example.txt = Foo
Bar
Baz (./readme_example2.sh:16)
```

### License
[MIT License (MIT)](LICENSE) 
