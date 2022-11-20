## debugtrace-sh

[English](README.md)

*debugtrace-sh* は、シェルスクリプトのデバッグ時にトレースログを出力するライブラリです。  
関数の開始と終了箇所に`debugtrace_enter`と`debugtrace_leave`を埋め込む事で、開発中のスクリプロの実行状況を出力する事ができます。

### 特徴

* 呼び出し元のソースファイルおよび行番号を自動的に出力。
* 関数のネストで、ログを自動的にインデント。

### 使用方法

* [Releases](https://github.com/MasatoKokubo/debugtrace-bash/releases) から最新版の`zip`または`tar.gz`をクリックし、ダウンロードしたファイルから`debugtrace.sh`を取り出す。
* `debugtrace.sh`をデバッグ対象のShell Scriptと同じディレクトリもしくは任意の場所に置く。
* デバッグログを出力したいスクリプトに以下を挿入する。
  1. 先頭に`source <ディレクトリ>/debugtrace.sh`
  1. スクリプトおよび関数の先頭に`debugtrace_enter`
  1. スクリプトおよび関数の最後に`debugtrace_leave`
  1. `return`および`exit`直前に`debugtrace_leave`
  1. 内容を表示したい変数への設定後に`debugtrace_print bar, "$bar"`

_使用例:_
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

_出力例 (Ubuntu/bash):_
```log
debugtrace-sh 1.0.0 on GNU bash, version 5.1.16(1)-release (x86_64-pc-linux-gnu)
2022-11-20 11:16:32+0900 Enter main (./readme_example1.sh:11)
2022-11-20 11:16:32+0900 | Enter foo (./readme_example1.sh:4)
2022-11-20 11:16:32+0900 | | bar = a value (./readme_example1.sh:6)
2022-11-20 11:16:32+0900 | Leave foo (./readme_example1.sh:7)
2022-11-20 11:16:32+0900 Leave main (./readme_example1.sh:13)
```

_出力例 (macOS/zsh):_
```log
debugtrace-sh 1.0.0 on zsh 5.8.1 (x86_64-apple-darwin21.0)
2022-11-20 11:25:27+0900 Enter main (./readme_example1.sh:11)
2022-11-20 11:25:27+0900 | Enter foo (./readme_example1.sh:4)
2022-11-20 11:25:27+0900 | | bar = a value (./readme_example1.sh:6)
2022-11-20 11:25:27+0900 | Leave foo (./readme_example1.sh:7)
2022-11-20 11:25:27+0900 Leave main (./readme_example1.sh:13)
```

_出力例 (macOS/tcsh):_
```log
debugtrace-sh 1.0.0 on tcsh 6.21.00 (Astron) 2019-05-08 (x86_64-apple-darwin) options wide,nls,dl,bye,al,kan,sm,rh,color,filec
2022-11-20 11:23:59+0900 Enter main (./readme_example1.sh:11)
2022-11-20 11:23:59+0900 | Enter foo (./readme_example1.sh:4)
2022-11-20 11:23:59+0900 | | bar = a value (./readme_example1.sh:6)
2022-11-20 11:23:59+0900 | Leave foo (./readme_example1.sh:7)
2022-11-20 11:23:59+0900 Leave main (./readme_example1.sh:13)
```

### `debugtrace_print`関数の使用例

#### メッセージの出力, 改行
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

#### 関数の引数をすべて出力する
```shell
debugtrace_print '$@' $@ # ToDo: Remove after debugging
debugtrace_print '$*' $* # ToDo: Remove after debugging
```
```log
2021-06-20 09:21:09+0900 $@ = arg1 arg2 arg3 (./readme_example2.sh:10)
2021-06-20 09:21:09+0900 $* = arg1 arg2 arg3 (./readme_example2.sh:11)
```

#### ファイル内容を出力する
```shell
local readonly file_name=./file_example.txt
debugtrace_print "$file_name" "`cat $file_name`" # ToDo: Remove after debugging
```
```log
2021-06-20 09:21:09+0900 ./file_example.txt = Foo
Bar
Baz (./readme_example2.sh:15)
```

### ライセンス
[MIT ライセンス(MIT)](LICENSE)
