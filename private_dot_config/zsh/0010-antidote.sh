cache_file="$ZSH_CACHE_DIR/antidote_prefix"

if [[ -z ${ANTIDOTE_PREFIX:-} && -s $cache_file ]]; then
	ANTIDOTE_PREFIX=$(<"$cache_file")
fi

if [[ -z ${ANTIDOTE_PREFIX:-} ]]; then
	ANTIDOTE_PREFIX=$(brew --prefix antidote 2>/dev/null)
	if [[ -n $ANTIDOTE_PREFIX ]]; then
		printf '%s' "$ANTIDOTE_PREFIX" >| "$cache_file"
	fi
fi

if [[ -n ${ANTIDOTE_PREFIX:-} ]]; then
	# shellcheck source=/dev/null
	source "$ANTIDOTE_PREFIX/share/antidote/antidote.zsh"
fi
