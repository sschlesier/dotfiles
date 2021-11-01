# WSL specific config
if [[ -n $WSL ]]; then
  export LANG=en_US.UTF-8

  # launch cron if not already running
  if type crond >/dev/null && [[ -z $(pgrep crond) ]]; then
    sudo crond
  fi

  # start Alpine if mounts are missing
  if [[ -d ~/current ]] && [[ ! -e ~/current/.exists ]]; then
    echo starting Alpine
    wsl.exe -d Alpine --exec logout
  fi
fi


