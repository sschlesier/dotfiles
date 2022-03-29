#enable and configure vi mode
bindkey -v

# use v to edit in $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

export KEYTIMEOUT=1	#wait 10ms when switching to vi-mode

