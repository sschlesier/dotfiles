#user for theme to know when to display alternate username
export "DEFAULT_USER=$(whoami)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [ -f "$ZDOTDIR/.p10k.zsh" ]; then
    # shellcheck source=/dev/null
	. "$ZDOTDIR/.p10k.zsh"
fi

