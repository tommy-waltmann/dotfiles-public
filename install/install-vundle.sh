#!/bin/bash

# Installs Vundle (vim plugin manager)

if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginUpdate +qall
else
    echo "It appears Vundle is already installed."
fi
