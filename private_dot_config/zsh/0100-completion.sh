# shellcheck shell=bash
autoload -Uz compinit

# Make custom completions visible before compinit builds or loads zcompdump.
fpath=( "$ZDOTDIR/completions" "${fpath[@]}" )

# Cache completion setup
# Use zcompdump to cache completions for faster load times
# Normal startup only loads an existing dump; refresh happens in the background.
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$HOST-$ZSH_VERSION"
[[ -n $ZSH_COMPDUMP ]] && [[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}
ZSH_COMPDUMP_REFRESHED="$ZSH_CACHE_DIR/zcompdump_refreshed"
ZSH_COMPDUMP_REFRESH_LOCK="$ZSH_CACHE_DIR/zcompdump-refresh.lock"
ZSH_COMPDUMP_REFRESH_LOG="$ZSH_CACHE_DIR/zcompdump-refresh.log"

_comp_options+=(globdots) # complete hidden files

_zsh_completion_refresh_due() {
	[[ ! -s $ZSH_COMPDUMP ]] && return 0
	[[ ! -e $ZSH_COMPDUMP_REFRESHED ]] && return 0

	local -a stale_refresh
	stale_refresh=( "$ZSH_COMPDUMP_REFRESHED"(Nm+60) )
	(( $#stale_refresh ))
}

_zsh_refresh_completions_async() {
	_zsh_completion_refresh_due || return 0
	mkdir "$ZSH_COMPDUMP_REFRESH_LOCK" 2>/dev/null || return 0
	setopt localoptions no_bg_nice

	(
		trap 'rmdir "$ZSH_COMPDUMP_REFRESH_LOCK"' EXIT INT TERM
		autoload -Uz compinit
		_comp_options+=(globdots)
		if compinit -i -d "$ZSH_COMPDUMP"; then
			touch "$ZSH_COMPDUMP_REFRESHED"
		fi
	) >>| "$ZSH_COMPDUMP_REFRESH_LOG" 2>&1 </dev/null &!
	return 0
}

if [[ -s $ZSH_COMPDUMP ]]; then
	compinit -C -d "$ZSH_COMPDUMP"
fi

_zsh_refresh_completions_async
