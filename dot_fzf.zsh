# Where is fzf installed
if [[ -d /usr/share/fzf ]]; then
  prefix=/usr/share/fzf
elif [[ -d /usr/local/opt/fzf ]]; then
  prefix=/usr/local/opt/fzf
else
  exit
fi

# Setup fzf
# ---------
if [[ ! "$PATH" == *$prefix/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$prefix/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$prefix/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$prefix/shell/key-bindings.zsh"
