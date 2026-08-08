#!/usr/bin/env bash
# Claude Code WorktreeRemove hook — the counterpart to worktree-create.sh.
#
# Claude calls this when cleaning up a hook-created worktree (ExitWorktree with
# removal, or declining to keep one at session end). Without it, Claude cannot
# clean up worktrees it created through the WorktreeCreate hook.
#
# stdin : JSON with .worktree_path (absolute path to the worktree)
# exit 0: removed; any other code reports stderr to the user only
#
# The branch is deliberately left in place — the worktree is removed, the work
# is not. Removing a merged branch stays a manual step.

set -euo pipefail

input=$(cat)
path=$(printf '%s' "$input" | jq -r '.worktree_path // empty')

if [ -z "$path" ]; then
  echo "WorktreeRemove: no worktree_path supplied" >&2
  exit 1
fi

# Already gone — nothing to do.
[ -d "$path" ] || exit 0

branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
main_root=$(git -C "$path" worktree list --porcelain 2>/dev/null |
  awk '/^worktree /{print substr($0, 10); exit}')

if command -v gtr >/dev/null 2>&1 && [ -n "$branch" ] && [ -d "${main_root:-}" ]; then
  if (cd "$main_root" && gtr rm "$branch" --force --yes </dev/null >&2); then
    exit 0
  fi
  echo "WorktreeRemove: gtr rm failed, falling back to git worktree remove" >&2
fi

git -C "${main_root:-$path}" worktree remove --force "$path" >&2
