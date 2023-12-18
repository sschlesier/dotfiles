# shellcheck shell=bash
autoload -Uz compinit

#preload async
async_init=$(echo mafredri/zsh-async | antidote bundle)
eval "$async_init"

autoload -Uz async && async

function load_completion() {
    _comp_options+=(globdots) # complete hidden files
    compinit
}

# Initialize worker
async_start_worker comp_worker -n
async_register_callback comp_worker load_completion
async_job comp_worker :
