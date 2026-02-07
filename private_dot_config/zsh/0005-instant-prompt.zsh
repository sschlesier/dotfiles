# register early so it fires before p10k's precmd
autoload -Uz add-zsh-hook
_prompt_render_start() {
  _prt_start=$EPOCHREALTIME
}
add-zsh-hook precmd _prompt_render_start

# if doing a script update skip instant prompt this time
semaphorePath="$ZSH_CACHE_DIR/do_update"

if [[ -e $semaphorePath ]]
then
    echo "skipping instant prompt for update"
    return
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
