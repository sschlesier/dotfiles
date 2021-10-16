#only define paths once
if [[ -n $PATHS_DEFINED ]]; then
	return
else
	export PATHS_DEFINED=1
fi

#define paths for windows file system access
if [[ -n $WSL ]]; then
	export C_ROOT=$(wslpath "$(wslvar --sys SystemDrive)\\")
	export WIN_HOME=$(wslpath "$(wslvar --sys USERPROFILE)")
	export PRG_FILES=$(wslpath "$(wslvar --sys PROGRAMFILES)")
	export DESKTOP=$(wslpath "$(wslvar --shell Desktop)")
	if [[ -d $WIN_HOME/Downloads ]]; then
		export DOWNLOADS="$WIN_HOME/Downloads"
	fi
fi

#set Desktop for non-windows
if [[ -z $DESKTOP ]]; then
	export DESKTOP="$HOME/Desktop"
fi

#set downloads for non-windows
if [[ -z $DOWNLOADS && -d $HOME/Downloads ]]; then
	export DOWNLOADS="$HOME/Downloads"
fi

if [[ -n $C_ROOT ]]; then
	#remove windows folders
	PATH=$(echo $PATH | tr ':' '\n' | grep -v $C_ROOT | tr '\n' ':')
	#restore system32
	PATH+=$C_ROOT/Windows/System32
fi

#include ~/bin and all bins under that folder on path
while read -r binpath
do
	PATH+=:"$binpath"
done < <(find "$HOME/bin" -type d -name bin)

#include .local/bin on path
if [[ -d "$HOME/.local/bin" ]]; then
	PATH+=:"$HOME/.local/bin"
fi

#include .cargo/bin on path
if [[ -d "$HOME/.cargo/bin" ]]; then
	PATH+=:"$HOME/.cargo/bin"
fi

# setup homebrew
brewpaths=( "/home/linuxbrew/.linuxbrew/bin/brew" \
	"/usr/local/bin/brew" \
	"/opt/homebrew/bin/brew" )

for pth in "${brewpaths[@]}";
do
	if [[ -x "$pth" ]]; then
		eval $("$pth" shellenv)
		break
	fi
done

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
