# goto.zsh

function makeLabel {
    printf "%s\t%s\n" $1 $PWD >> ~/.labels.tsv
}

function label {
    if [ $# -eq 0 ]
        then
            echo "Usage: $ label <name> [dir]"
            echo "    creates a label which goto can cd to"
    elif [ $2 ]
        then
            cd $2
            makeLabel $1
    else
        makeLabel $1
    fi
}

function goto {
    if [ $# -eq 0 ]
        then
            echo "Usage: $ goto <name>"
            echo "    jumps to a record set by label"
    elif [[ "$1" == "ls" ]]
        then
            cat ~/.labels.tsv | awk "{ print \$1 }"
    else
        dir=$(cat ~/.labels.tsv | grep -e "^$1" | tail -n 1 | sed s/"$1\t"//)
        if [ $dir ]
            then
                cd $dir
        else
            echo $1 " was not found!"
        fi
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


