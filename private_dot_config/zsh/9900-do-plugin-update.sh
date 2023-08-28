# shellcheck shell=bash

#split the update process in two
#the prompt needs to be VERY early to take advantage of the instant prompt
#but the update is ideally left late so that all relevant config is loaded

semaphorePath="$ZSH_CACHE_DIR/do_update"

if [[ -e $semaphorePath ]]
then
  update_all_plugins
  rm "$semaphorePath"
fi
