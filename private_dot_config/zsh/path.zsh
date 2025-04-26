#only define paths once
if [[ -n $PATHS_DEFINED ]]; then
	return
else
	export PATHS_DEFINED=1
fi

export DESKTOP="$HOME/Desktop"
if [[ -d $HOME/Downloads ]]; then
	export DOWNLOADS="$HOME/Downloads"
fi

#define paths for windows file system access
#override assumed non-windows paths
if [[ -n $WSL ]]; then
	export C_ROOT=$(wslpath "$(wslvar --sys SystemDrive)\\")
	export WIN_HOME=$(wslpath "$(wslvar --sys USERPROFILE)")
	export PRG_FILES=$(wslpath "$(wslvar --sys PROGRAMFILES)")
	export DESKTOP=$(wslpath "$(wslvar --shell Desktop)")
	if [[ -d $WIN_HOME/Downloads ]]; then
		export DOWNLOADS="$WIN_HOME/Downloads"
	fi
fi

if [[ -n $C_ROOT ]]; then
	#remove windows folders
	PATH=$(echo $PATH | tr ':' '\n' | grep -v $C_ROOT | tr '\n' ':')
	#restore system32
	PATH+=$C_ROOT/Windows/System32
fi

#iCloud
if [[ -d $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs ]]; then
	export ICLOUD=$HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs
fi

#include ~/bin and all bins under that folder on path
while read -r binpath
do
	PATH+=:"$binpath"
done < <(find "$HOME/bin" -type d)

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
gemfile="$ZSH_CACHE_DIR/gempath"
gempath="$(brew --prefix ruby)/bin/gem"
#write path into a file
if [[ ! -f $gemfile ]]; then
	echo updating gempath
	if [[ -x "$gempath" ]]; then
		$gempath env gempath | tr ':' '\n' | xargs -I {} find {} -maxdepth 1 -name bin -type d | tr '\n' ':' | sed 's/:$//' > "$gemfile"
		cat "$gemfile"
	else
		#no gems here so blank the file
		touch "$gemfile"
	fi
fi
if [[ -s $gemfile ]]; then
	PATH+=:$(cat "$gemfile")
fi

#add golang to path
if type go > /dev/null; then
	export GOPATH=$HOME/go
	PATH+=:"$GOPATH/bin"
fi

#add libpq (postgres client) to path
if [[ -e "$HOMEBREW_PREFIX/opt/libpq/bin" ]]; then
	PATH+=:"$HOMEBREW_PREFIX/opt/libpq/bin"
fi

# add dotnet CLI to path
if [[ -e "$HOME/.dotnet/dotnet" ]]; then
    PATH+=:"$HOME/.dotnet"
fi

# add dotnet tools to path
if [[ -e "$HOME/.dotnet/tools" ]]; then
    PATH+=:"$HOME/.dotnet/tools"
fi

#de-duplicate path
typeset -aU path

if [ -e $HOME/Library/Android/sdk ]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi
