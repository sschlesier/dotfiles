# \033?7l disables automargin like tput rmam (reset mode auto margin) but works in tmux
# \033?7h enables automargin like tput smam (set mode auto margin) but works in tmux
alias gt='printf "\033[?7l$(git tree --color=always | head -n$(($LINES - 4)))\033[?7h\n"'
alias gta='git tree --all'
alias gv='git view'

function gi() {
   curl -sLw '' https://www.toptal.com/developers/gitignore/api/$@ ;
}
