if [[ -n $TMUX ]]; then
  #checking for insecure completion folders is slow so disable it
  #in tmux sub-shells keep it at startup to notice bad folders
  export ZSH_DISABLE_COMPFIX=true
fi

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

#update plugins when out of date
plugins_file="$ZSH_CACHE_DIR/pre_compinit_plugins.zsh"
plugins_src="$ZSH_INIT/pre_compinit_plugins.txt"
if [[ ! -e $plugins_file || $plugins_file -ot "$plugins_src" ]] && type antibody >/dev/null; then
  echo updating "$plugins_file" ...
  antibody bundle < "$plugins_src" > $plugins_file
fi
source $plugins_file

autoload -Uz compinit && compinit

plugins_file="$ZSH_CACHE_DIR/post_compinit_plugins.zsh"
plugins_src="$ZSH_INIT/post_compinit_plugins.txt"
if [[ ! -e $plugins_file || $plugins_file -ot "$plugins_src" ]] && type antibody >/dev/null; then
  echo updating "$plugins_file" ...
  antibody bundle < "$plugins_src" > $plugins_file
fi
source $plugins_file

