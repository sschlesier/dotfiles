# Where is fzf installed
if [[ -d /usr/share/fzf ]]; then
  export FZF_HOME=/usr/share/fzf
elif [[ -d /usr/local/opt/fzf ]]; then
  export FZF_HOME=/usr/local/opt/fzf
elif [[ -d $HOME/.fzf ]]; then
  export FZF_HOME=$HOME/.fzf
else
  echo Can\'t find fzf
  return
fi

# Setup fzf
# ---------
if [[ ! "$PATH" == *$FZF_HOME/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$FZF_HOME/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_HOME/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$FZF_HOME/shell/key-bindings.zsh"
