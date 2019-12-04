aliasdir() {
	if [[ -d "$2" ]]; then
		alias "$1"="cd $2"
	fi
}

if [[ -d "$C_ROOT"/src ]]; then
	export SRC="$C_ROOT"/src
elif [[ -d "$HOME"/src ]]; then
	export SRC="$HOME"/src
fi

#cdpath
cdpath=("$SRC" "$HOME")
if [[ -n $WIN_HOME ]]; then
	cdpath+=("$WIN_HOME")
fi
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %B%d%b

aliasdir ams "$SRC/AssetMediaService"
aliasdir ap "$SRC/IQ.Auth.Packages"
aliasdir api "$SRC/Azure.APIManagement"
aliasdir au "$SRC/Auth"
aliasdir av "$SRC/IQ.Platform.Availability"
aliasdir bsn "$SRC/BuildScripts.Net"
aliasdir ca "$SRC/Catalogs"
aliasdir cc "$SRC/CodingChallenge1"
aliasdir cn "$SRC/CatalogNexus"
aliasdir cost "$SRC/IQ.Platform.Cost"
aliasdir de "$HOME/Desktop"
aliasdir de "$Desktop"
aliasdir dow "$HOME/Downloads"
aliasdir dow "$WIN_HOME/Downloads"
aliasdir dr "$HOME/Dropbox"
aliasdir dr "$WIN_HOME/Dropbox"
aliasdir es "$SRC/EntityStore"
aliasdir exp "$SRC/experiment"
aliasdir fl "$SRC/Foundation.Logging"
aliasdir fm "$SRC/Foundation.Messaging"
aliasdir fo "$SRC/Foundation.Outbox"
aliasdir fw "$SRC/Foundation.WebApi"
aliasdir im "$SRC/IQ.Messaging"
aliasdir mg "$SRC/Monitoring.Graphite"
aliasdir od "$WIN_HOME/OneDrive"
aliasdir pe "$SRC/product-excellence"
aliasdir pl "$SRC/ProductLibrary"
aliasdir sbm "$SRC/ServiceBusMonitor"
aliasdir src "$SRC"
aliasdir ss "$SRC/shell-setup"
aliasdir sub "$SRC/ProductSubscriptions"
aliasdir to "$WIN_HOME/tools"

# List directory contents
if type exa &> /dev/null; then
	alias ls='exa --color-scale --icons'
	alias lg='l --git'
	alias l='ls -l'
	alias la='ls -la'
	alias lt='ls -T'
else
	alias ls='ls --color=tty'
	alias l='ls -lh'
	alias la='ls -lah'
fi

# change directories
alias -- -='cd -'
alias ..='cd ../'

#Windows Home dir
if [[ -n $WIN_HOME ]]; then
	alias wh="cd $WIN_HOME"
fi

#list files in ~/bin
alias llb="ls -l $HOME/bin"
