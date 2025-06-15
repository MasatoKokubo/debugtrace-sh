* Added a variable to specify the output destination.  
    Example:  
    ```
    declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
    source $SCRIPT_DIR/../debugtrace.sh
    debugtrace_output_destination=/tmp/debugtrace.log
    ```

----
*Japanese*

* 出力先を指定する変数を追加しました。  
    例:  
    ```
    declare -r SCRIPT_DIR=$(cd $(dirname $0);pwd)
    source $SCRIPT_DIR/../debugtrace.sh
    debugtrace_output_destination=/tmp/debugtrace.log
    ```
