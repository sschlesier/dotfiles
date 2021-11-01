#launch tmux or attach to existing session
if [[ $LAUNCH_TMUX -eq 1 ]] && [[ -z "$TMUX" ]] && type tmux >/dev/null; then
  tmux attach 2>/dev/null || exec tmux new -s misc -c "$HOME"
fi

