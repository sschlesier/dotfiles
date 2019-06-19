#make directory and cd to it
mcd() {
  mkdir "$1"
  cd "$1"
}
export mcd

#make director w/ current date
mdd() {
  mcd $(date '+%Y-%m-%d')
}
export mdd

#open the current folder in explorer
b() {
	open_command .
}
export b

## super user alias
alias _='sudo'

# expand command via C-Alt-a
expand-aliases() {
  unset 'functions[_expand-aliases]'
  functions[_expand-aliases]=$BUFFER
  (($+functions[_expand-aliases])) &&
    BUFFER=${functions[_expand-aliases]#$'\t'} &&
    CURSOR=$#BUFFER
}

zle -N expand-aliases
bindkey '\e^A' expand-aliases

darkmode() {
  export LIGHT_MODE=0
}

lightmode() {
  export LIGHT_MODE=1
}
