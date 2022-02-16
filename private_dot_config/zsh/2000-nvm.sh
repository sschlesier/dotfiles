export NVM_DIR="$HOME/.nvm"
[ ! -d "$NVM_DIR" ] && mkdir -p "$NVM_DIR"
# lazynvm adapted from
# https://til-engineering.nulogy.com/Slow-Terminal-Startup-Tip-Lazy-Load-NVM/

lazynvm() {
  unset -f nvm node npm npx
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
  if [ -f "$HOMEBREW_PREFIX/opt/nvm/bash_completion" ]; then
    [ -s "$HOMEBREW_PREFIX/opt/nvm/bash_completion" ] && \. "$HOMEBREW_PREFIX/opt/nvm/bash_completion" # This loads nvm bash_completion
  fi
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}

npx() {
  lazynvm
  npx $@
}
