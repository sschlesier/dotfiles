#setup fuzzy finder
# fd follow links always exclude .git
FD_OPTIONS="--follow --exclude .git"

# Change behavior of fzf dialogue
export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

# Change find backend
# Use 'git ls-files' when inside GIT repo, or fd otherwise
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"

# Find commands for "Ctrl+T" and "Opt+C" shortcuts
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

if [[ -z $FZF_SCRIPT_HOME ]]; then
	# Where are fzf scripts
	# fedora, freebsd, debian
	script_opts=( "/usr/share/fzf/shell" "/usr/local/share/examples/fzf/shell" "/usr/share/doc/fzf/examples" )

	if [[ -n $HOMEBREW_PREFIX ]]; then
		script_opts=( "$HOMEBREW_PREFIX/opt/fzf/shell" "$script_opts" )
	fi

	for dir in ${script_opts[@]};
	do
		if [[ -d $dir ]]; then
			export FZF_SCRIPT_HOME="$dir"
			break
		fi
	done
fi

if [[ -n $FZF_SCRIPT_HOME ]]; then
	file="$FZF_SCRIPT_HOME/completion.zsh" && [[ -e "$file" ]] && source "$file"
	file="$FZF_SCRIPT_HOME/key-bindings.zsh" && [[ -e "$file" ]] && source "$file"
fi
