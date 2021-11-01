#user for theme to know when to display alternate username
DEFAULT_USER=$(whoami)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [ -f "$HOME/.p10k.zsh" ]; then
	. "$HOME/.p10k.zsh"
fi

