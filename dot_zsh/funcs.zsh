#make directory and cd to it
mcd() {
	if [[ -z $1 ]]; then
		echo No directory specified
		return
	fi
	mkdir -p "$1"
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

#ensure files are unix line endings before staging them in git
gle() {
	dos2unix --keep-bom $(git status --short | awk --field-separator ' ' '{print $2}')
}

# make a new BIA on desktop
newbia() {

	local name="$DESKTOP/$1 - Business Impact Assessment.xlsx"
	cp "$(wslpath "C:\Users\Scott.Schlesier\iQmetrix Software Development Corp\Security Architecture - Documents\Shared Folder\Public Documents\Public Templates\Business Impact Assessment Template.xlsx")" "$name"

	open_command "$name"
}
