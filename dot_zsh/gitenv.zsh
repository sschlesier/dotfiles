#setup git environment specific bits
gitenv="$ZSH_CACHE_DIR/gitconfig-env"

if [[ ! -f $gitenv ]]; then
  echo setting up git include

cat <<EOF > "$HOME/.git-indirection"
[include]
  path = $gitenv
EOF

cat <<EOF > "$gitenv"
[user]
  email = $EMAIL
EOF

  if [[ -n $CRED_HELPER ]]; then

cat <<EOF >> "$gitenv"
[credential]
  helper = $CRED_HELPER
EOF

  fi
fi #[[ ! -f $gitenv ]];

#add'l git tools
# \033?7l disables automargin like tput rmam (reset mode auto margin) but works in tmux
# \033?7h enables automargin like tput smam (set mode auto margin) but works in tmux
alias gt='printf "\033[?7l$(git tree --color=always | head -n$(($LINES - 4)))\033[?7h\n"'
alias gta='git tree --all'
unalias grv #expose the git repo viewer tool
alias gh='gitit'

