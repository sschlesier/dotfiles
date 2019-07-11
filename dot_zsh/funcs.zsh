#make directory and cd to it
mcd() {
	mkdir "$1"
	cd "$1"
}
export mcd

#make directory w/ current date
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

#turn alias into full command at prompt
zle -N expand-aliases
bindkey '\e^A' expand-aliases

darkmode() {
	it2prof gruvbox-dark
}

lightmode() {
	it2prof papercolor-light
}

# Change iterm2 profile. Usage it2prof ProfileName (case sensitive)
it2prof() {
	echo -e "\033]50;SetProfile=$1\a"
	export ITERM_PROFILE=$1
}

#update tmux environment from current server state
tmux-update-env() {
source <(tmux show-environment -s)
}
