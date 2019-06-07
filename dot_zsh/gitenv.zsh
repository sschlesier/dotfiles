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
