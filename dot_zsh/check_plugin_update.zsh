#! /usr/bin/evn zsh

lastUpdatedFileName=plugins_updated
lastUpdatedPath="$ZSH_CACHE_DIR/$lastUpdatedFileName"

foundFile=$(find $ZSH_CACHE_DIR -maxdepth 1 -name $lastUpdatedFileName -mtime +1w -print -quit)

if [[ -n "$foundFile" ]]; then
  read "CONFIRM?Would you like to update all plugins? "
  if [[ $CONFIRM =~ ^[Yy]$ ]]; then
    update_all_plugins
    touch "$lastUpdatedPath"
  fi
elif [[ ! -f $lastUpdatedPath ]]; then
  touch "$lastUpdatedPath"
fi
