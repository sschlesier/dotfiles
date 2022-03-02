if type nvim > /dev/null; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi
alias v=$EDITOR

alias lg=lazygit
alias xdg-open='open_command'

alias ca='chezmoi apply'
alias cs='chezmoi status'
alias cr='chezmoi re-add'
alias cdf='chezmoi diff'
alias ccs='cd $(chezmoi source-path)'

## super user alias
alias _='sudo'

# put last command on clipboard
alias fcc="fc -ln -1 | tr -d '\n' | pbcopy"
