alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gbr='git branch --remote'
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
# alias gccd= function
alias gd='git diff'
alias gdss='git difftool --tool difft' # diff side-by-side
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gmt='git mergetool'
alias gp='git push'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpr='git pull --rebase'
alias gr='git remote'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gre='git recent'
alias grhh='git reset --hard'
alias gst='git status'
# \033?7l disables automargin like tput rmam (reset mode auto margin) but works in tmux
# \033?7h enables automargin like tput smam (set mode auto margin) but works in tmux
alias gt='printf "\033[?7l$(git tree --color=always | head -n$(($LINES - 4)))\033[?7h\n"'
alias gta='git tree --all'
alias gv='git view'

#git hub commands
alias prc='gh pr checkout'
alias prl='gh pr list'
alias prv='gh pr view -w'

