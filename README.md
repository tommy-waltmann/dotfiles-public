# Dotfiles

The files in this repository are licensed MIT, unless otherwise stated in the file.

## Linux/Mac Setup
```bash
mkdir -p $HOME/code
cd $HOME/code
git clone --recurse-submodules https://github.com/bdice/dotfiles-public.git
cd dotfiles
bash bootstrap.sh
```

## Windows Setup
```batch
mkdir %USERPROFILE%\code
cd %USERPROFILE%\code
git clone --recurse-submodules https://github.com/bdice/dotfiles-public.git
cd dotfiles
bootstrap.bat
```
