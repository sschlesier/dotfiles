# shellcheck shell=bash
autoload -Uz compinit

#preload async
async_init=$(echo mafredri/zsh-async | antibody bundle)
eval "$async_init"

autoload -Uz async && async

function load_completion() {
    _comp_options+=(globdots) # complete hidden files
    compinit

    #omz requires compdef to be defined
    plugins_file="$ZSH_CACHE_DIR/omz-plugins.zsh"
    plugins_src="$ZDOTDIR/omz-plugins.txt"
    if [[ ! -e $plugins_file || $plugins_file -ot $plugins_src ]]; then
        antibody bundle < "$plugins_src" > "$ZSH_CACHE_DIR/omz-plugins.zsh"
    fi
    # shellcheck source=/dev/null
    source "$plugins_file"
}

# Initialize worker
async_start_worker comp_worker -n
async_register_callback comp_worker load_completion
async_job comp_worker :
