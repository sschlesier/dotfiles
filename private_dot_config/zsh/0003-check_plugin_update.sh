# shellcheck shell=bash
lastUpdatedFileName=plugins_updated
lastUpdatedPath="$ZSH_CACHE_DIR/$lastUpdatedFileName"

#find is faster than fd for this purpose but Fedora doesn't seem to have find
if type find > /dev/null; then
  foundFile=$(find "$ZSH_CACHE_DIR" -maxdepth 1 -name "$lastUpdatedFileName" -mtime +7 -print -quit)
elif type fd > /dev/null; then
  foundFile=$(fd --max-depth=1 --change-older-than 1weeks "$lastUpdatedFileName" "$ZSH_CACHE_DIR")
else
  echo unable to refresh plugins add 'find' or 'fd' to your path
fi

if [[ -n "$foundFile" ]]; then
  read  -r -t 5 "CONFIRM?Would you like to update all plugins? "
  if [[ $CONFIRM =~ ^[Yy]$ ]]; then
    update_all_plugins
    touch "$lastUpdatedPath"
  fi
elif [[ ! -f $lastUpdatedPath ]]; then
  touch "$lastUpdatedPath"
fi
