# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output. So make sure this doesn't display
# anything or bad things will happen!

umask 007

# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive. Be done now!
    return
fi

# Detect Platform
if [ "$(uname -s)" == "Darwin" ]; then
    OS_PLATFORM="Mac"
else
    # Default to Linux
    OS_PLATFORM="Linux"
fi

# Aliases
if [ "$OS_PLATFORM" == "Mac" ]; then
    # Color ls
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxBxegedabagacad
    # Color grep
    export GREP_OPTIONS="--color=always"
    export GREP_COLOR="1;35;40"

    # Prevent path_helper from messing up PATH in tmux
    if [ -n $TMUX ] && [ -f /etc/profile ]; then
        PATH=""
        source /etc/profile
    fi
else
    alias ls="ls --color=auto"
    alias grep="grep --color=auto"
fi

alias ll="ls -alhF"
alias sl="ls"
alias l="ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias tmux="tmux -2 -u"
alias tl="tmux ls"
alias ta="tmux attach -t"
alias gdiff="git diff --no-index --"

# git quick commands
alias s="git status"
alias ga="git add -p"
alias com="git commit -m"
alias ch="git checkout"
alias push="git push"
alias pull="git pull"
alias gsui="git submodule update --init"
alias lg="git log --all --decorate --oneline --graph"

# Shell options
# Automatically enter directories
shopt -s autocd
# Correct spelling errors during cd
shopt -s cdspell
# Combine multi-line commands in history
shopt -s cmdhist
# Print timestamps in history
HISTTIMEFORMAT="%F %T "

# Terminal prompt
export PS1="\[\033[1;32m\]\u@\h \[\033[38;5;12m\]\w $\[\033[0m\] "

# Autocomplete settings
complete -d cd
complete -f vim
source $HOME/.completions/git-completion.bash

# cddir: if the argument is a file, cd to its directory.
# If directory, cd there directly.
function cddir() {
    TARGET=$1
    if [ -d "$TARGET" ]; then
        cd $TARGET
    elif [ -e "$TARGET" ]; then
        cd $(dirname $TARGET)
    else
        echo "$TARGET is not a file or directory."
    fi
}

# search:
# first argument is search pattern
# second arg (optional) is directory
function search() {
    grep -rn ${2:-.} -e "$1"
}

# keep repeats a task every 5 seconds
function keep() {
    "$@"
    while sleep 5; do
        "$@"
    done
}

# prettyjson pretty-prints a json file
function jsonprettify() {
    python -m json.tool $1 | pygmentize -l javascript
}

# Shortcut for python's built-in webserver
function webserve() {
    python -m http.server --bind localhost ${1:-8888}
}

# Build and serve sphinx documentation
function sphinxserve() {
    make html || return 1
    trap "cd ../.." RETURN
    cd _build/html && webserve ${1:-8888}
}

# Prevent git commits that don't adhere to flake8
function flake8hook() {
    flake8 --install-hook git
    git config --bool flake8.strict true
}

# ==========
# PATH SETUP
# ==========

# Include .local/bin in front of PATH
if [[ ! ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    export PATH=$HOME/.local/bin:$PATH
fi

# conda PATH setup
if [ -d $HOME/miniconda3/bin ]; then
    export CONDA_PATH="$HOME/miniconda3"
    if [[ ! ":$PATH:" == *":${CONDA_PATH}/bin:"* ]]; then
        export PATH="${CONDA_PATH}/bin:$PATH"
    fi
elif [ -d $HOME/anaconda3/bin ]; then
    export CONDA_PATH="$HOME/anaconda3"
    if [[ ! ":$PATH:" == *":${CONDA_PATH}/bin:"* ]]; then
        export PATH="${CONDA_PATH}/bin:$PATH"
    fi
fi

# deconda removes all conda paths from PATH
if [ -d $CONDA_PATH ]; then
    alias deconda='conda deactivate; PATH=$(echo $PATH | sed -e "s|${CONDA_PATH}/bin:||")'
fi

# yarn setup
if [ -d $HOME/.yarn/bin ] && [[ ! ":$PATH:" == *":$HOME/.yarn/bin:"* ]]; then
    export PATH="$HOME/.yarn/bin:$PATH"
fi

# Auto-activate conda environment
if [ -d "${CONDA_PATH}/envs/glotzer" ]; then
    source activate glotzer
fi

# Jupyter shortcuts
alias jn="jupyter notebook --port=8675 --no-browser"
alias jl="jupyter lab --port=8675 --no-browser"

# Code directory
if [ -d $HOME/code ]; then
    export CODE_DIR="$HOME/code"
else
    export CODE_DIR="$HOME"
fi

# bbclone, ghclone
if [ -d "$CODE_DIR" ]; then
    function ghclone() {
        if [ -d ${3:-"$CODE_DIR/${1}"} ]; then
            echo "${1} is already cloned."
        else
            git clone --recurse-submodules https://${USER}@github.com/${2:-"glotzerlab"}/${1}.git ${3:-"$CODE_DIR/${1}"}
        fi
    }

    function bbclone() {
        if [ -d ${3:-"$CODE_DIR/${1}"} ]; then
            echo "${1} is already cloned."
        else
            git clone --recurse-submodules https://${USER}@bitbucket.org/${2:-"glotzer"}/${1}.git ${3:-"$CODE_DIR/${1}"}
        fi
    }
fi

# Detect custom builds of HOOMD
if [ -d "$CODE_DIR/hoomd-blue/build/" ] && ! python -c "import hoomd" > /dev/null 2>&1 && [[ ! ":$PYTHONPATH:" == *":$CODE_DIR/hoomd-blue/build/:"* ]]; then
    export PYTHONPATH="$CODE_DIR/hoomd-blue/build/${PYTHONPATH:+":"}$PYTHONPATH"
fi

function whichpy() {
    python -c "import $1; print('File: ' + $1.__file__); print('Version: ' + $1.__version__)"
}

# Distro-specific setup
if [ -e /etc/os-release ]; then
    if [[ $(. /etc/os-release; printf '%s\n' "$NAME"; ) =~ (Ubuntu|Debian) ]]; then
        alias upg="sudo apt-get update && sudo apt-get upgrade"
    fi
fi

# Bash on Windows
if [ -e /proc/version ] && grep -q Microsoft /proc/version; then
    eval "$(dircolors -b $HOME/.dircolors)"
    export DISPLAY=:0.0
    export LIBGL_ALWAYS_INDIRECT=1
fi

# Mac specific configuration
if [ "$OS_PLATFORM" == "Mac" ]; then

    # Turns the sound to the minimum so my headphones are quiet
    alias quiet="osascript -e \"set Volume 0.001\""

    # Set brew prefix
    if [ -d "${HOME}/homebrew" ]; then
        BREW_PREFIX="${HOME}/homebrew"
    else
        BREW_PREFIX="/usr/local"
    fi

    if [ -e "${HOME}/.iterm2_shell_integration.bash" ]; then
        source "${HOME}/.iterm2_shell_integration.bash"
    fi

    # Use GNU coreutils instead of Mac equivalents
    if [ -d "${BREW_PREFIX}/opt/coreutils/libexec/gnubin" ]; then
        PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
        alias ls="ls --color=auto"
        alias grep="grep --color=auto"
    fi

    # Add a slash when tab-completing on symlink directories
    bind 'set mark-symlinked-directories on'

fi
