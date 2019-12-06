#setup fuzzy finder
# fd follow links always exclude .git
FD_OPTIONS="--follow --exclude .git"

# Change behavior of fzf dialogue
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info"

# Change find backend
# Use 'git ls-files' when inside GIT repo, or fd otherwise
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"

# Find commands for "Ctrl+T" and "Opt+C" shortcuts
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

export FZF_TMUX=0
export FZF_TMUX_HEIGHT=33%

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
# if interactive shell
if [[ $- == *i* ]]; then
	[[ -e "$FZF_HOME/shell/completion.zsh" ]] && source "$FZF_HOME/shell/completion.zsh" 2> /dev/null
	[[ -e /usr/share/zsh/site-functions/fzf ]] && source /usr/share/zsh/site-functions/fzf 2> /dev/null
fi

# Key bindings
# ------------
source "$FZF_HOME/shell/key-bindings.zsh"
