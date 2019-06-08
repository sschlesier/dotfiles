#customise POWERLEVEL_10K Theme
#stole the basics from .purepower by the p10k guy
typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
dir_writable dir vcs)

typeset -ga POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
status command_execution_time background_jobs context)

local ins='❯'
local cmd='❮'
if (( ${PURE_POWER_USE_P10K_EXTENSIONS:-1} )); then
local p="\${\${\${KEYMAP:-0}:#vicmd}:+${${ins//\\/\\\\}//\}/\\\}}}"
p+="\${\${\$((!\${#\${KEYMAP:-0}:#vicmd})):#0}:+${${cmd//\\/\\\\}//\}/\\\}}}"
else
p=$ins
fi
local ok="%F{076}${p}%f"
local err="%F{196}${p}%f"

typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%(?.$ok.$err) "

DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

#set ls colors
if [[ $(uname -s) = "Linux" ]]; then
  eval "$(dircolors $HOME/.dircolors.256dark)"
fi
export CLICOLOR=1
