# shellcheck shell=bash

#user for theme to know when to display alternate username
export "DEFAULT_USER=$(whoami)"

# if in vscode, use a simple prompt
if [[ $TERM_PROGRAM == "vscode" ]]; then
  printf "TERM_PROGRAM: %s\n" "$TERM_PROGRAM"
  PROMPT='%n@%m:%~%# '
elif [ -f "$ZDOTDIR/.p10k.zsh" ]; then
    # shellcheck source=/dev/null
	. "$ZDOTDIR/.p10k.zsh"
fi

# Configuration
THEME_FILE="$XDG_DATA_HOME/theme_mode"
LIGHT_THEME="Pencil Light"
DARK_THEME="VSCode_Dark"
BAT_LIGHT_THEME="OneHalfLight"
BAT_DARK_THEME="OneHalfDark"

# Initialize
mkdir -p "$(dirname "$THEME_FILE")"
[[ ! -f "$THEME_FILE" ]] && echo "dark" > "$THEME_FILE"

light() {
    echo "light" > "$THEME_FILE"
    kitty +kitten themes --reload-in=all "$LIGHT_THEME"
    echo "--theme=$BAT_LIGHT_THEME" > "$HOME/.config/bat/config"
    echo "Switched to light theme"
}

dark() {
    echo "dark" > "$THEME_FILE"
    kitty +kitten themes --reload-in=all "$DARK_THEME"
    echo "--theme=$BAT_DARK_THEME" > "$HOME/.config/bat/config"
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
