#!/bin/bash

# Persist .claude.json in the volume so login state survives container restarts
mkdir -p ~/.claude
[ ! -s ~/.claude/.claude.json ] && echo '{}' > ~/.claude/.claude.json
ln -sf ~/.claude/.claude.json ~/.claude.json

# Sync config from host ~/.claude into the volume
# Only copies known config items — leaves credentials and .claude.json untouched
HOST=/tmp/.claude-host
if [ -d "$HOST" ]; then
  for item in CLAUDE.md settings.json commands skills plugins; do
    [ -e "$HOST/$item" ] && cp -r "$HOST/$item" ~/.claude/
  done
fi

exec "$@"
