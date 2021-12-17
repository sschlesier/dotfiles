aliasdir() {
	if [[ -d "$2" ]]; then
		alias "$1"="cd \"$2\""
	fi
}

sessiondir() {
	if [[ -d "$2" ]]; then
		alias "$1"="tm \"$1\" \"$2\""
	fi
}

gosrcdir() {
	sessiondir "$1" "$GOPATH/src/github.com/sschlesier/$2"
}

srcdir() {
	if [[ -n $ALTSRC ]]; then
		sessiondir "$1" "$ALTSRC"/"$2"
	fi
	#let main $SRC override alt if they both exist
	sessiondir "$1" "$SRC"/"$2"
}

setsrcdirs() {
	if [[ -z $SRC ]] && [[ -d $1 ]]; then
		export SRC="$1"
	elif [[ -z $ALTSRC ]] && [[ -d $1 ]] && [[ $SRC != $1 ]]; then
		export ALTSRC="$1"
	fi
}

setsrcdirs "$C_ROOT"/src
setsrcdirs "$HOME"/src

#cdpath
cdpath=("$SRC" "$HOME")
if [[ -n $WIN_HOME ]]; then
	cdpath+=("$WIN_HOME")
fi
if [[ -n $ALTSRC ]]; then
	cdpath+=("$ALTSRC")
fi

zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %B%d%b

aliasdir cur "$HOME/current"
aliasdir de "$DESKTOP"
aliasdir dow "$HOME/Downloads"
aliasdir gs "$GOPATH/src/github.com/sschlesier"
aliasdir src "$SRC"
aliasdir cz "$HOME/.config/zsh"

srcdir ah arthana
srcdir pr practice
srcdir pe product-excellence
srcdir ss shell-setup

gosrcdir got golang-tour

# List directory contents
if type exa &> /dev/null; then
	alias ls='exa --color-scale --icons --group-directories-first'
	alias l='ls -l'
	alias la='ls -la'
	alias lt='ls -T'
else
	alias l='ls -lh'
	alias la='ls -lah'
fi

# change directories
alias -- -='cd -'
alias ..='cd ../'
alias ,=cd-gitroot

#Windows Home dir
if [[ -n $WIN_HOME ]]; then
	alias wh="cd $WIN_HOME"
fi

#list files in ~/bin
function llb () {
	pushd -q ~/bin
	if [ -t 1 ]; then
		fd --type executable | column
	else
		fd --type executable
	fi
	popd -q
}
