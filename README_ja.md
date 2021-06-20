## debugtrace-bash

[English](README.md)

*DebugTrace-bash* は、Bashスクリプトのデバッグ時にトレースログを出力するライブラリです。  
関数の開始と終了箇所に`debugtrace::enter`と`debugtrace::leave`を埋め込む事で、開発中のスクリプロの実行状況を出力する事ができます。

### 特徴

* 呼び出し元のソースファイルおよび行番号を自動的に出力。
* 関数のネストで、ログを自動的にインデント。

### 使用方法

* 以下のいずれかで`debugtrace.sh`ファイルを取得します。
  * `[↓ Code ▼]` -> `Download ZIP`を選択し、ダウンロードしたzipファイルから取り出す。
  * [Releases](https://github.com/MasatoKokubo/debugtrace-bash/releases) から最新版のAssetsのzipファイルクリックし、ダウンロードしたzipファイルから取り出す。
* `debugtrace.sh`をデバッグ対象のShell Scriptと同じディレクトリもしくは任意の場所に置きます。
* デバッグログを出力したいスクリプトに以下挿入します。
  1. 先頭に`source <ディレクトリ>/debugtrace.sh`
  1. スクリプトおよび関数の先頭に`debugtrace::enter`
  1. スクリプトおよび関数の最後に`debugtrace::leave`
  1. `return`および`exit`直前に`debugtrace::leave`
  1. 内容を表示したい変数への設定後に`debugtrace::print bar, "$bar"`

  _使用例:_
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

  _出力例:_
  ```log
  DebugTrace-bash 1.0.0 beta1
  2021-06-20 09:20:01+0900 Enter main (./readme_example1.sh:12)
  2021-06-20 09:20:01+0900 | Enter foo (./readme_example1.sh:5)
  2021-06-20 09:20:01+0900 | | bar = a value (./readme_example1.sh:7)
  2021-06-20 09:20:01+0900 | Leave foo (./readme_example1.sh:8)
  2021-06-20 09:20:01+0900 Leave main (./readme_example1.sh:14)
  ```


### `debugtrace::print`関数の使用例

#### メッセージの出力, 改行
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

#### 関数の引数をすべて出力する
```bash
debugtrace::print '$@' $@ # ToDo: Remove after debugging
debugtrace::print '$*' $* # ToDo: Remove after debugging
```
```log
2021-06-20 09:21:09+0900 $# = 3 (./readme_example2.sh:9)
2021-06-20 09:21:09+0900 $@ = arg1 arg2 arg3 (./readme_example2.sh:10)
2021-06-20 09:21:09+0900 $* = arg1 arg2 arg3 (./readme_example2.sh:11)
```

#### ファイル内容を出力する
```bash
local readonly file_name=./file_example.txt
debugtrace::print "$file_name" "`cat $file_name`" # ToDo: Remove after debugging
```
```log
2021-06-20 09:21:09+0900 ./file_example.txt = Foo
Bar
Baz (./readme_example2.sh:15)
```

### ライセンス
[MIT ライセンス(MIT)](LICENSE)
