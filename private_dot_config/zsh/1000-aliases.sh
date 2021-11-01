if type nvim > /dev/null; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi
export LESS=-RFMX
alias v=$EDITOR
alias lg=lazygit
alias xdg-open='open_command'

