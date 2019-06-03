#!/bin/sh

# Enable tab-completion for git commands (like checking out branches)

COMPLETIONS="$HOME/.completions"

if [ ! -d $COMPLETIONS ]; then
    echo "Creating $COMPLETIONS"
    mkdir -p $COMPLETIONS
fi

if [ ! -f $COMPLETIONS/git-completion.bash ]; then
    echo "Fetching https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
    cd $COMPLETIONS
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    cd -
fi
