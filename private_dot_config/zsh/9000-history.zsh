#add'l options on top of omz history settings via anitbody
#omit l and git status from history
HISTIGNORE='l:gst: '
setopt HIST_IGNORE_ALL_DUPS  #never duplicate a history command
setopt HIST_SAVE_NO_DUPS     #never save duplicate commands
setopt SHARE_HISTORY         #share history between shells
setopt HIST_VERIFY           #show history substitution before executing

