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
aliasdir bsn "$SRC/BuildScripts.Net"
aliasdir ca "$SRC/Catalogs"
aliasdir cn "$SRC/CatalogNexus"
aliasdir de "$HOME/Desktop"
aliasdir de "$WIN_HOME/Desktop"
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
aliasdir pe "$SRC/product-excellence"
aliasdir pl "$SRC/ProductLibrary"
aliasdir sbm "$SRC/ServiceBusMonitor"
aliasdir src "$SRC"
aliasdir ss "$SRC/shell-setup"
aliasdir sub "$SRC/ProductSubscriptions"

# List directory contents
if type exa &> /dev/null; then
  alias ls='exa --color-scale --icons'
  alias lg='l --git'
  alias l='ls -l'
  alias la='ls -la'
else
  alias ls='ls --color=tty'
  alias l='ls -lh'
  alias la='ls -lah'
fi

# change directories
alias -- -='cd -'
alias ..='cd ../'
