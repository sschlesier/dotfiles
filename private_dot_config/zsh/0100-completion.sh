# shellcheck shell=bash
autoload -Uz compinit

# Make custom completions visible before compinit builds or loads zcompdump.
fpath=( "$ZDOTDIR/completions" "${fpath[@]}" )

# Cache completion setup
# Use zcompdump to cache completions for faster load times
# The cache is automatically used by compinit and regenerated if needed
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$HOST-$ZSH_VERSION"
[[ -n $ZSH_COMPDUMP ]] && [[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

_comp_options+=(globdots) # complete hidden files

# compaudit (security scan of fpath) is the slow part of compinit, and is
# separate from compinit's own check of whether fpath/zsh version changed
# (which should always run so the dump stays in sync with installed
# completions). Skip the real audit here — plugin files haven't changed at
# this point in the load order, so auditing now would just check stale
# state. update_all_plugins (functions/update_all_plugins) runs the real
# compaudit itself once plugins are actually updated, whether that's
# triggered by the weekly cadence or run manually. compinit re-autoloads
# the real compaudit internally before returning, so it's back to normal
# for manual use afterward.
compaudit() { return 0 }
compinit -d "$ZSH_COMPDUMP"
