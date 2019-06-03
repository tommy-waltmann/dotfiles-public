#!/bin/bash

function sync_file() {
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    FILENAME=$SCRIPT_DIR/$1
    REPLACE_PATH=$2/$1
    if [ -e $FILENAME ]; then
        if [ -e "${REPLACE_PATH}" ]; then
            DIFF=$(diff $FILENAME ${REPLACE_PATH})
            if [ "$DIFF" != "" ]; then
                echo -e "\033[38;5;226mFile $FILENAME is different:\033[0m"
                diff $FILENAME ${REPLACE_PATH}
                while true; do
                    read -p "Replace file ${REPLACE_PATH}? " yn
                    case $yn in
                        [Yy]* ) cp -v $FILENAME ${REPLACE_PATH}; break;;
                        [Nn]* ) break;;
                        * ) echo "Please answer yes or no.";;
                    esac
                done
            fi
        else
            echo "Copying $FILENAME to ${REPLACE_PATH} since it doesn't exist."
            mkdir -p $(dirname ${REPLACE_PATH})
            cp -v $FILENAME ${REPLACE_PATH}
        fi
    else
        echo "File $FILENAME does not exist."
    fi
}

read -r -d '' SYNC_LIST <<'EOF'
.gitconfig
.gitexcludes
.bashrc
.bash_profile
.dircolors
.tmux.conf
.vimrc
.vim/colors/monokai.vim
.completions/git-completion.bash
.gemrc
EOF

for i in ${SYNC_LIST}; do
    sync_file $i $HOME
done

sync_file repo-updater.sh $HOME

echo -e "\033[38;5;82mDone. Synced.\033[0m"
