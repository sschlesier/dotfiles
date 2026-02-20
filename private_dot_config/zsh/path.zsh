#only define paths once
if [[ -n $PATHS_DEFINED ]]; then
	return
else
	export PATHS_DEFINED=1
fi

zlog_dir=${TMPDIR:-/tmp}
zlog_dir=${zlog_dir%/}
[[ -n $zlog_dir ]] || zlog_dir=/tmp
zlog_file="$zlog_dir/zsh-startup-$(date +%Y-%m-%d).log"
path_script="${(%):-%N}"
[[ $path_script == path.zsh ]] && path_script="$ZDOTDIR/path.zsh"

if [[ ! -d $zlog_dir ]]; then
	command mkdir -p -- "$zlog_dir" 2>/dev/null
fi

if [[ ! -s $zlog_file ]]; then
	printf 'start_time\tend_time\tduration_seconds\tscript\n' >> "$zlog_file"
fi

zmodload zsh/datetime 2>/dev/null
path_start_time=${EPOCHREALTIME:-0}

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

#include ~/bin and all bins under that folder on path (cache to avoid repeated find)
home_bin_cache="$ZSH_CACHE_DIR/home_bin_paths"
if [[ -d "$HOME/bin" ]]; then
	if [[ ! -s $home_bin_cache || "$HOME/bin" -nt $home_bin_cache ]]; then
		find "$HOME/bin" -type d >| "$home_bin_cache"
	fi
	while IFS= read -r binpath
	do
		PATH+=:"$binpath"
	done < "$home_bin_cache"
fi

#include .local/bin on path
if [[ -d "$HOME/.local/bin" ]]; then
	PATH+=:"$HOME/.local/bin"
fi

#include .cargo/bin on path
if [[ -d "$HOME/.cargo/bin" ]]; then
	PATH+=:"$HOME/.cargo/bin"
fi

# setup homebrew (cache shellenv output to avoid rerunning brew)
brew_shellenv_cache="$ZSH_CACHE_DIR/brew_shellenv"
brewpaths=( "/home/linuxbrew/.linuxbrew/bin/brew" \
	"/usr/local/bin/brew" \
	"/opt/homebrew/bin/brew" )

if [[ -s $brew_shellenv_cache ]]; then
	eval "$(<"$brew_shellenv_cache")"
else
	for pth in "${brewpaths[@]}";
	do
		if [[ -x "$pth" ]]; then
			brew_env="$("$pth" shellenv)"
			printf '%s\n' "$brew_env" >| "$brew_shellenv_cache"
			eval "$brew_env"
			break
		fi
	done
fi

#add gems to path (use cached bins; refresh lazily via gem-refresh-path)
gem_bins_cache="$ZSH_CACHE_DIR/gem_bins"

if [[ -s $gem_bins_cache ]]; then
	while IFS= read -r gem_bin
	do
		PATH+=:"$gem_bin"
	done < "$gem_bins_cache"
fi

# refresh gem bin paths on demand (avoids spawning ruby on every shell startup)
gem-refresh-path() {
	local gem_sources_cache="$ZSH_CACHE_DIR/gem_sources"
	local gem_bins_cache="$ZSH_CACHE_DIR/gem_bins"
	local current_gem_sources
	current_gem_sources=$(gem env gempath 2>/dev/null | tr -d '\r')
	if [[ -n $current_gem_sources ]]; then
		printf '%s' "$current_gem_sources" >| "$gem_sources_cache"
		printf '%s\n' "$current_gem_sources" | tr ':' '\n' | sed 's@$@/bin@' >| "$gem_bins_cache"
		echo "gem bin paths updated — restart shell or source path.zsh to pick up changes"
	else
		echo "gem env gempath returned nothing"
	fi
}

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

if [[ ${path_start_time:-0} != 0 ]]; then
	zmodload zsh/datetime 2>/dev/null
	path_end_time=$EPOCHREALTIME
	path_duration=$(echo "$path_end_time - $path_start_time" | bc)
	printf '%s\t%s\t%.6f\t%s\n' "$path_start_time" "$path_end_time" "$path_duration" "$path_script" >> "$zlog_file"
	# export so .zshrc can display it
	export _path_zsh_duration=$path_duration
fi
