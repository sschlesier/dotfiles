#define paths for windows file system access
if [[ -d /mnt/c ]]; then
  export C_ROOT=/mnt/c
  if [[ -d $C_ROOT/Users/Scott.Schlesier ]]; then
    export WIN_HOME=$C_ROOT/Users/Scott.Schlesier
    alias wh="cd $WIN_HOME"
  fi
  if [[ -d $C_ROOT/Program\ Files ]]; then
    export PRG_FILES=$C_ROOT/Program\ Files
  fi
fi

#include /winbin on path
if [[ -d "$HOME/winbin" ]]; then
  PATH+=:"$HOME/winbin"
  alias llw="ls -l $HOME/winbin"
fi

#include /bin on path
PATH+=:"$HOME/bin"
alias llb="ls -l $HOME/bin"

#include .cargo/bin on path
if [[ -d "$HOME/.cargo/bin" ]]; then
  PATH+=:"$HOME/.cargo/bin"
fi

#add gems to path
gempath="$ZSH_CACHE_DIR/gempath"
#write path into a file
if [[ ! -f $gempath ]]; then
  echo updating gempath
  if [[ -n $(type gem) ]]; then
    gem environment gempath > "$gempath"
  else
    #no gems here so blank the file
    touch "$gempath"
  fi
fi
if [[ -s $gempath ]]; then
  PATH+=:$(cat "$gempath")
fi

if [[ -n $C_ROOT ]]; then
  #remove windows folders
  PATH=$(echo $PATH | tr ':' '\n' | grep -v $C_ROOT | tr '\n' ':')
  #strip trailing :
  PATH=${PATH%:}
  export PATH
fi

#de-duplicate path
typeset -aU path
