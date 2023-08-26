set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
execute pathogen#infect()
source ~/.vimrc
