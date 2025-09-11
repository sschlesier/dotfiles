# shellcheck shell=bash

#user for theme to know when to display alternate username
export "DEFAULT_USER=$(whoami)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [ -f "$ZDOTDIR/.p10k.zsh" ]; then
    # shellcheck source=/dev/null
	. "$ZDOTDIR/.p10k.zsh"
fi

# Configuration
THEME_FILE="$XDG_DATA_HOME/theme_mode"
LIGHT_THEME="Ayu Light"
DARK_THEME="Ayu"

# Initialize
mkdir -p "$(dirname "$THEME_FILE")"
[[ ! -f "$THEME_FILE" ]] && echo "dark" > "$THEME_FILE"

light() {
    echo "light" > "$THEME_FILE"
    kitty +kitten themes --reload-in=all "$LIGHT_THEME"
    echo "Switched to light theme"
}

dark() {
    echo "dark" > "$THEME_FILE"
    kitty +kitten themes --reload-in=all "$DARK_THEME"
    echo "Switched to dark theme"
}

toggle() {
    current=$(cat "$THEME_FILE")
    if [[ "$current" == "light" ]]; then
        dark
    else
        light
    fi
}
