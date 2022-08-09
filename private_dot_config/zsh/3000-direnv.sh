# to support use node
export NODE_VERSIONS=~/.nvm/versions/node
export NODE_VERSION_PREFIX=v

if type direnv > /dev/null; then
	eval "$(direnv hook zsh)"
fi
