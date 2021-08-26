aliasdir() {
	if [[ -d "$2" ]]; then
		alias "$1"="tm \"$1\" \"$2\""
	fi
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

aliasdir cfg "$HOME/.config"
aliasdir cur "$HOME/current"
aliasdir de "$DESKTOP"
aliasdir dow "$HOME/Downloads"
aliasdir dow "$WIN_HOME/Downloads"
aliasdir dr "$HOME/Dropbox"
aliasdir dr "$WIN_HOME/Dropbox"
aliasdir src "$SRC"
aliasdir to "$WIN_HOME/tools"

#iq specific
aliasdir en "$HOME/current/entity-store-sub"
aliasdir od "$WIN_HOME/OneDrive"
aliasdir sa "$WIN_HOME/iQmetrix Software Development Corp/Security Architecture - Documents"
aliasdir sq "$WIN_HOME/OneDrive/sql-encrypted"

srcdir ams AssetMediaService
srcdir ap IQ.Auth.Packages
srcdir au Auth
srcdir av IQ.Platform.Availability
srcdir bsn BuildScripts.Net
srcdir ca Catalogs
srcdir cn CatalogNexus
srcdir es EntityStore
srcdir exp experiment
srcdir fm Foundation.Messaging
srcdir fo Foundation.Outbox
srcdir im IQ.Messaging
srcdir mg Monitoring.Graphite
srcdir pe product-excellence
srcdir pl ProductLibrary
srcdir rq RQ
srcdir sbm ServiceBusMonitor
srcdir ss shell-setup
srcdir sub ProductSubscriptions

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
