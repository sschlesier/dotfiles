#! /usr/bin/evn zsh

fileName=plugins_updated
updateFile="$ZSH_CACHE_DIR/$fileName"

foundFile=$(find $ZSH_CACHE_DIR -maxdepth 1 -name $fileName -mtime +1w -print -quit)

if [[ -n "$foundFile" ]]; then
  read "REPLY?Would you like to update all plugins? "
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    update_all_plugins
    touch "$updateFile"
  fi
elif [[ ! -f $updateFile ]]; then
  touch "$updateFile"
fi
