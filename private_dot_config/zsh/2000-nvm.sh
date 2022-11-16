[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" --no-use
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# adapted from https://github.com/nvm-sh/nvm#zsh
autoload -U add-zsh-hook
loadnvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd loadnvmrc

# adapted from https://github.com/nvm-sh/nvm/issues/539#issuecomment-245791291
#startup nvm when needed
alias node='unalias node ; unalias npm ; unalias yarn ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; unalias yarn ; nvm use default ; npm $@'
alias yarn='unalias node ; unalias npm ; unalias yarn ; nvm use default ; yarn $@'
