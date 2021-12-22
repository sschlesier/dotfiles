#make directory and cd to it
mcd() {
	if [[ -z $1 ]]; then
		echo No directory specified
		return
	fi
	mkdir -p "$1"
	cd "$1"
}
export mcd

#make directory w/ current date
mdd() {
	mcd $(date '+%Y-%m-%d')
}
export mdd

#open the current folder in explorer
b() {
	open_command .
}
export b

## super user alias
alias _='sudo'

# expand command via C-Alt-a
expand-aliases() {
unset 'functions[_expand-aliases]'
functions[_expand-aliases]=$BUFFER
(($+functions[_expand-aliases])) &&
	BUFFER=${functions[_expand-aliases]#$'\t'} &&
	CURSOR=$#BUFFER
}

#turn alias into full command at prompt
zle -N expand-aliases
bindkey '\e^A' expand-aliases

darkmode() {
	it2prof gruvbox-dark
}

lightmode() {
	it2prof papercolor-light
}

# Change iterm2 profile. Usage it2prof ProfileName (case sensitive)
it2prof() {
	echo -e "\033]50;SetProfile=$1\a"
	export ITERM_PROFILE=$1
}

#update tmux environment from current server state
tmux-update-env() {
source <(tmux show-environment -s)
}

#ensure files are unix line endings before staging them in git
gle() {
	dos2unix --keep-bom $(git status --short | awk --field-separator ' ' '{print $2}')
}

# make a new BIA on desktop
newbia() {

	local name="$DESKTOP/$1 - Business Impact Assessment.xlsx"
	cp "$(wslpath "C:\Users\Scott.Schlesier\iQmetrix Software Development Corp\Security Architecture - Documents\Shared Folder\Public Documents\Public Templates\Business Impact Assessment Template.xlsx")" "$name"

	open_command "$name"
}

# switch to specified tmux session optional default dir
tm() {
    if [ -z "$TMUX" ]; then
      tmux new-session -As "${1:-misc}" -c "$2"
    else
        if [ -z "$1" ]; then
            tmux switch-client -l
        else
          if ! tmux has-session -t "$1" 2>/dev/null; then
            tmux new-session -d -s "$1" -c "$2"
          fi

          curSession=$(tmux display-message -p "#{session_name}")
          if [ "$curSession" = "$1" ]; then
              cd "$2" || exit
          else
              tmux switch-client -t "$1"
          fi
        fi
    fi
}

# create new session $1 and optional dir $2
# move current window into that session
tmw() {
  if [ -z "$1" ]; then
    echo Please pass a session name
    exit 1
  fi

  winSrc=$(tmux display-message -p "#{session_name}:#{window_index}")

  if ! tmux has-session -t "$1" 2>/dev/null; then
    newSess=1
    tmux new-session -d -s "$1" -c "$2"
  fi

  tmux switch-client -t "$1"
  tmux move-window -s "$winSrc" -t "$1"
  if [ "$newSess" -eq "1" ]; then
    tmux kill-window -a
  fi
}

# update nvm
nvm-update() {
    if [[ -z $1 ]]; then
        echo Please specify a version to update
        nvm ls
    fi

    nvm install "$1" --reinstall-packages-from="$1"
}
