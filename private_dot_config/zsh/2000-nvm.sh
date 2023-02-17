# shellcheck shell=bash

# adapted from https://github.com/nvm-sh/nvm/issues/539#issuecomment-403661578
if [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
    autoload -Uz async && async
    function load_nvm() {
        #shellcheck source=/dev/null
        [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
        #shellcheck source=/dev/null
        [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
    }

    # Initialize worker
    async_start_worker nvm_worker -n
    async_register_callback nvm_worker load_nvm
    async_job nvm_worker sleep 0.1

    # adapted from https://github.com/nvm-sh/nvm#zsh
    autoload -U add-zsh-hook
    loadnvmrc() {
      nvmrc_path="$(nvm_find_nvmrc)"

      if [ -n "$nvmrc_path" ]; then
        nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

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
fi
