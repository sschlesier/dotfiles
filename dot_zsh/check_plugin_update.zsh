#! /usr/bin/evn zsh

zmodload zsh/datetime

daysTillUpdate=7
update_file="$ZSH_CACHE_DIR/plugins_updated"

let "targetTime = $EPOCHSECONDS - (60 * 60 * 24 * $daysTillUpdate)"

if [[ -f "$update_file" ]]; then
  lastUpdated=$(date -r $update_file +%s)
  if [[ $lastUpdated < $targetTime ]]; then
    read "REPLY?Would you like to update all plugins? "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      update_all_plugins
      touch "$update_file"
    fi
  fi
else
  touch "$update_file"
fi
