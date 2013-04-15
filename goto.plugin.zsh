# goto.zsh

function makeLabel {
    printf "%s\t%s\n" $1 $2 >> ~/.labels.tsv
}

function label {
    if [ $# -eq 0 ]
        then
            echo "Usage: $ label <name> [dir]"
            echo "    creates a label which goto can cd to"
    elif [ $2 ]
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
            awk "{ print \$1 }" ~/.labels.tsv
    else
        cd $(awk "/^$1/ {print \$2}" ~/.labels.tsv)
    fi
}
alias gt="goto"

function _goto {
    for label in $(awk '{print $1}' ~/.labels.tsv)
    do
        compadd "$@" $label
    done
}

compdef _goto goto
