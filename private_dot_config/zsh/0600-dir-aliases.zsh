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
		aliasdir "$1" "$ALTSRC"/"$2"
	fi
	#let main $SRC override alt if they both exist
	aliasdir "$1" "$SRC"/"$2"
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

aliasdir de "$DESKTOP"
aliasdir docs "$HOME/Documents"
aliasdir dow "$HOME/Downloads"
aliasdir gs "$GOPATH/src/github.com/sschlesier"
aliasdir ic "$ICLOUD"
aliasdir od "$HOME/OneDrive"

srcdir pr practice
srcdir ss shell-setup

# List directory contents
if type eza &> /dev/null; then
	alias ls='eza --color-scale=size --icons=auto --group-directories-first'
	alias l='ls --long'
	alias la='l --all'
	alias lt='ls --tree'
    alias ldo='l $DOWNLOADS'
    alias ldt='l --sort oldest'
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

