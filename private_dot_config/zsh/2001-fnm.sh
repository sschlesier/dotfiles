# shellcheck shell=bash

eval "$(fnm env --use-on-cd --shell zsh)"

# wrap fnm's chpwd hook with timing
if (( $+functions[_fnm_autoload_hook] )); then
  functions[_fnm_autoload_hook_orig]=$functions[_fnm_autoload_hook]
  _fnm_autoload_hook() {
    local t=$EPOCHREALTIME
    _fnm_autoload_hook_orig "$@"
    local d=$(echo "$EPOCHREALTIME - $t" | bc)
    printf 'fnm hook: %.6f seconds\n' "$d"
  }
fi
