# Defined in /var/folders/jx/qdy_9r656ygc0bv56wdgn6r00000gn/T//fish.8paJ4U/ls.fish @ line 1
function ls --description 'List contents of directory'
	exa --color-scale --icons --group-directories-first $argv
end
