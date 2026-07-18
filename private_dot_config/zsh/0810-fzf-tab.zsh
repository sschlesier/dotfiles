# fzf-tab config (plugin: Aloxaf/fzf-tab, see plugins.txt)
# https://github.com/Aloxaf/fzf-tab

# disable the default completion menu so fzf-tab takes over
zstyle ':completion:*' menu no

# colorize file completions using the same LS_COLORS eza/ls would use
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# don't sort when completing `git checkout`/`git switch`, keep branch order
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-switch:*' sort false

# switch between completion groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

if type eza > /dev/null; then
	# preview directory contents when completing cd
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
fi

if type bat > /dev/null; then
	# preview file contents when completing commands that take a file
	zstyle ':fzf-tab:complete:(nvim|vim|v|cat|bat):*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null'
fi
