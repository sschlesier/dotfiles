#make directory and cd to it
mcd() {
  mkdir "$1"
  cd "$1"
}
export mcd

#make director w/ current date
mdd() {
  mcd $(date '+%Y-%m-%d')
}
export mdd

#open the current folder in explorer
b() {
	open_command .
}
export b

## super user alias
alias _='sudo'
