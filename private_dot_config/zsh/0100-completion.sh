# shellcheck shell=bash
autoload -Uz compinit

# Cache completion setup
# Use zcompdump to cache completions for faster load times
# The cache is automatically used by compinit and regenerated if needed
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$HOST-$ZSH_VERSION"
[[ -n $ZSH_COMPDUMP ]] && [[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

_comp_options+=(globdots) # complete hidden files
compinit -d "$ZSH_COMPDUMP"
