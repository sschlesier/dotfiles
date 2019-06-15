#! /usr/bin/evn zsh

update_file="$ZSH_CACHE_DIR/plugins_updated"

if [[ -f "$update_file" ]]; then
  oldfile=$(find $ZSH_CACHE_DIR -maxdepth 1 -name "plugins_updated" -mtime +1w -print -quit)

  if [[ -n $oldfile ]]; then
    read "REPLY?Would you like to update all plugins? "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      update_all_plugins
      touch "$update_file"
    fi
  fi
else
  touch "$update_file"
fi
