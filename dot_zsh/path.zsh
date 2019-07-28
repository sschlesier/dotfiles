#only define paths once
if [[ -n $PATHS_DEFINED ]]; then
	return
else
	export PATHS_DEFINED=1
fi

#define paths for windows file system access
if [[ -d /mnt/c ]]; then
	export C_ROOT=/mnt/c
	if [[ -d $C_ROOT/Users/Scott.Schlesier ]]; then
		export WIN_HOME=$C_ROOT/Users/Scott.Schlesier
	fi
	if [[ -d $C_ROOT/Program\ Files ]]; then
		export PRG_FILES=$C_ROOT/Program\ Files
	fi
fi

if [[ -n $C_ROOT ]]; then
	#remove windows folders
	PATH=$(echo $PATH | tr ':' '\n' | grep -v $C_ROOT | tr '\n' ':')
	#restore system32
	PATH+=$C_ROOT/Windows/System32
fi

#include /bin on path
PATH+=:"$HOME/bin"

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

#add golang to path
if type go > /dev/null; then
	export GOPATH=$HOME/go
	PATH+=:"$GOPATH/bin"
fi

#de-duplicate path
typeset -aU path
