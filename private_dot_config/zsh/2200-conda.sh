# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOMEBREW_PREFIX/Caskroom/miniforge/base/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="$HOMEBREW_PREFIX/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

