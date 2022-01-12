# expand command via C-Alt-a
expand-aliases() {
unset 'functions[_expand-aliases]'
functions[_expand-aliases]=$BUFFER
(($+functions[_expand-aliases])) &&
	BUFFER=${functions[_expand-aliases]#$'\t'} &&
	CURSOR=$#BUFFER
}

#turn alias into full command at prompt
zle -N expand-aliases
bindkey '\e^A' expand-aliases

#autoload everything in functions directory
fpath=( "$ZSH_INIT/functions" "${fpath[@]}" )
autoload -Uz "$ZSH_INIT/functions"/*(.:t)