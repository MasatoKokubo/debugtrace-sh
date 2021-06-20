## debugtrace-bash

[Japanese](README_ja.md)

*DebugTrace-bash* is a library that outputs trace logs when debugging Bash scripts.  
By embedding `debugtrace::enter` and `debugtrace::leave` at the start and end of functions, you can output the execution status of the shell script under development to the log.

### Features

* Automatically output the calling source file and line number.
* Automatically indent logs with function nesting.

### How to use

* Get the `debugtrace.sh` file with one of the following: 
  * Select `[↓ Code ▼]` -> `Download ZIP` and extract from the downloaded zip file. 
  * Click the latest version of the Assets zip file from [Releases](https://github.com/MasatoKokubo/debugtrace-bash/releases) and extract it from the downloaded zip file.
  * Place `debugtrace.sh` in the same directory as the shell scripts to be debugged or in any location.
  * Insert the following into the script for which you want to output the debug log.
    1. `source <directory>/debugtrace.sh` at the beginning of script
    1. `Debugtrace::enter` at the beginning of scripts and functions
    1. `debugtrace::leave` at the end of scripts and functions
    1. `debugtrace::leave` just before `return` and `exit` 

  _Example:_
  ```bash
  #!/bin/bash
  source ./debugtrace.sh # ToDo: Remove after debugging

  function foo() {
    debugtrace::enter # ToDo: Remove after debugging
    bar="a value"
    debugtrace::print bar "$bar"
    debugtrace::leave # ToDo: Remove after debugging
    return 0
  }

  debugtrace::enter # ToDo: Remove after debugging
  foo
  debugtrace::leave # ToDo: Remove after debugging
  ```
  _Output:_
  ```log
  DebugTrace-bash 1.0.0 beta1
  2021-06-20 09:20:01+0900 Enter main (./readme_example1.sh:12)
  2021-06-20 09:20:01+0900 | Enter foo (./readme_example1.sh:5)
  2021-06-20 09:20:01+0900 | | bar = a value (./readme_example1.sh:7)
  2021-06-20 09:20:01+0900 | Leave foo (./readme_example1.sh:8)
  2021-06-20 09:20:01+0900 Leave main (./readme_example1.sh:14)
  ```

### Example of using `debugtrace::print` function

#### Output messages and line break
```bash
debugtrace::print "Hellow"
debugtrace::print
debugtrace::print 'World!'
```
```log
2021-06-20 09:21:09+0900 Hellow (./readme_example2.sh:5)
2021-06-20 09:21:09+0900 
2021-06-20 09:21:09+0900 World! (./readme_example2.sh:7)
```

#### Output all arguments of function
```bash
debugtrace::print '$@' $@ # ToDo: Remove after debugging
debugtrace::print '$*' $* # ToDo: Remove after debugging
```
```log
2021-06-20 09:21:09+0900 $@ = arg1 arg2 arg3 (./readme_example2.sh:10)
2021-06-20 09:21:09+0900 $* = arg1 arg2 arg3 (./readme_example2.sh:11)
```

#### Output the file contents 
```bash
local readonly file_name=./file_example.txt
debugtrace::print "$file_name" "`cat $file_name`" # ToDo: Remove after debugging
```
```log
2021-06-19 18:26:57+0900 ./file_example.txt = Foo
Bar
Baz (./readme_example2.sh:16)
```

### License
[MIT License (MIT)](LICENSE) 
