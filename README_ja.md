## debugtrace-sh

[English](README.md)

*debugtrace-sh*は、シェルスクリプトのデバッグ時にトレースログを`stderr`に出力するシェルスクリプトライブラリです。  
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
  1. スクリプトおよび関数の最後に`debugtrace_leave $?`
  1. `return`および`exit`直前に`debugtrace_leave $?`
  1. 内容を表示したい変数への設定後に`debugtrace_print bar, "$bar"`

_使用例:_
```shell
#!/bin/bash
declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
source $SCRIPT_DIR/../debugtrace.sh

foo() {
  debugtrace_enter
  declare bar='a value'
  debugtrace_print bar "$bar"
  debugtrace_leave $?
}

debugtrace_enter
foo
debugtrace_leave
```

_出力例 (Linux/bash):_
```log
debugtrace-sh 1.2.0 on GNU bash, version 5.1.8(1)-release (x86_64-redhat-linux-gnu)
2025-06-02 21:24:42+0900 Enter main (Examples/readme_example1.sh:12)
2025-06-02 21:24:42+0900 | Enter foo (Examples/readme_example1.sh:6)
2025-06-02 21:24:42+0900 | | bar = 'a value' (Examples/readme_example1.sh:8)
2025-06-02 21:24:42+0900 | Leave foo (Examples/readme_example1.sh:9)
2025-06-02 21:24:42+0900 Leave main (Examples/readme_example1.sh:14)
```

### `debugtrace_print`関数の使用例

#### メッセージの出力, 改行
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

#### 関数の引数をすべて出力する
```shell
debugtrace_print '$@' "$@"
debugtrace_print '$*' "$*"
```
```log
2025-01-05 12:03:46+0900 $@ = ['arg1', 'arg2', 'arg3'] (./readme_example2.sh:5)
2025-01-05 12:03:46+0900 $* = 'arg1 arg2 arg3' (./readme_example2.sh:6)
```

#### ファイル内容を出力する
```shell
declare -r file_name=file_example.txt
debugtrace_print "$file_name" "`cat $file_name`"
```
```log
2025-01-05 12:03:46+0900 file_example.txt = 'Foo
Bar
Baz' (./readme_example2.sh:18)
```

#### 配列の内容を出力する
```shell
declare -a array=(1 B 3 D 5)
debugtrace_print array ${array[@]}
```
```log
2025-01-05 12:03:46+0900 array = [1, 'B', 3, 'D', 5] (./readme_example2.sh:22)
```

### 出力のカスタマイズ
`source .../debugtrace.sh`を実行後に`debugtrace.sh`で定義された変数に代入することでログの出力をカスタマイズできます。カスタマイズ可能な変数は以下があります。
<table>
  <caption>カスタマイズ可能な変数</caption>
  <thead>
    <tr><th>変数名</th><th>内容</th><th>初期値</tr>
  </thead>
  <tr>
    <td><code>debugtrace_enter_string</code></td>
    <td><code>debugtrace_enter</code>関数で出力する開始文字列</td>
    <td><code>'Enter '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_leave_string</code></td>
    <td><code>debugtrace_leave</code>関数で出力する開始文字列</td>
    <td><code>'Leave '</td>
  </tr>
  <tr>
    <td><code>debugtrace_datetime_format</code></td>
    <td>ログの日付フォーマット</td>
    <td><code>'%Y-%m-%d %H:%M:%S%z'</td>
  </tr>
  <tr>
    <td><code>debugtrace_print_surfix</code></td>
    <td><code>ログの行末に追加する文字列</td>
    <td><code style="white-space:nowrap">' \(${BASH_SOURCE[1]}:$BASH_LINENO\)'</td>
  </tr>
  <tr>
    <td><code>debugtrace_indent_string</code></td>
    <td>インデント1個分の文字列</td>
    <td><code>'| '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_varname_value_separator</code></td>
    <td>変数名と値のセパレータ文字列</td>
    <td><code>' = '</code></td>
  </tr>
  <tr>
    <td><code>debugtrace_elements_delimiter</code></td>
    <td>配列要素を区切る文字列</td>
    <td><code>', '</code></td>
  </tr>
</table>

### ライセンス
[MIT ライセンス(MIT)](LICENSE)
