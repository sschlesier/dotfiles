if type nvim > /dev/null; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi
alias v='$EDITOR'

alias lg=lazygit
alias lzn=lazynpm
alias lzd=lazydocker
alias xdg-open='open_command'

alias ca='chezmoi apply'
alias cs='chezmoi status'
alias cr='chezmoi re-add'
alias cdf='chezmoi diff'
alias ccs='cd $(chezmoi source-path)'
alias cz='cd ~/.config/zsh'

## super user alias
alias _='sudo'

# put last command on clipboard
alias fcc="fc -ln -1 | tr -d '\n' | pbcopy"

# ssh kitten
alias s="kitty +kitten ssh"

# images in kitty kitten
alias icat="kitty +kitten icat"

# duckduckgo
alias ddg=ddgr

# ripgrep
alias rga="rg --no-ignore --hidden"

# fd all
alias fda="fd --hidden --no-ignore"

alias crsr="ide cursor"

alias mvdo='f() { mv "$HOME/Downloads/$1" "${2:-.}"; }; f'
