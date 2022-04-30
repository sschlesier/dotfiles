_comp_options+=(globdots) # complete hidden files
autoload -Uz compinit && compinit

#update plugins when out of date
plugins_file="$ZSH_CACHE_DIR/plugins.zsh"
plugins_src="$ZDOTDIR/plugins.txt"
if [[ ! -e $plugins_file || $plugins_file -ot "$plugins_src" ]] && type antibody >/dev/null; then
  echo updating "$plugins_file" ...
  antibody bundle < "$plugins_src" > $plugins_file
fi
source $plugins_file
