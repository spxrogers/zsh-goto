# goto.zsh

$GOTO_FILE=~/.labels.tsv

function label {
    function makeLabel {
         printf "%s\t%s\n" $1 $2 >> $GOTO_FILE
    }

    if [ $# -eq 0 ]
    then
        echo "Usage: $ label <name> [dir]"
        echo "    creates a label which goto can cd to"
    if [ -d "$2" ]
    then
        makeLabel $1 $2
    else
        makeLabel $1 $PWD
    fi
}

function goto {
    if [ $# -eq 0 ]
    then
        echo "Usage: $ goto <name>"
        echo "    jumps to a record set by label"
    elif [[ "$1" == "ls" ]]
    then
        awk "{ print \$1 }" $GOTO_FILE
    else
        if [ -d "$(awk "/^$1/ {print \$2;}" $GOTO_FILE)" ]
        then
            cd $(awk "/^$1/ {print \$2;}" $GOTO_FILE)
        else
            echo $1 " was not found!"
        fi
    fi
}

function _goto {
    for label in $(awk '{print $1}' $GOTO_FILE)
    do
        compadd "$@" $label
    done
}

compdef _goto goto
