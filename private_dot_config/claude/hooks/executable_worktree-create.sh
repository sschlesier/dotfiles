#!/usr/bin/env bash
# Claude Code WorktreeCreate hook.
#
# When this hook is configured, Claude Code delegates ALL worktree creation to
# it instead of running `git worktree add` into <repo>/.claude/worktrees/.
# That is the only supported way to relocate Claude-managed worktrees: the
# built-in location is hardcoded, and EnterWorktree prompts for approval on any
# path outside it. Creation via this hook is never prompted.
#
# stdin : JSON with .name (suggested worktree slug) and .cwd
# stdout: absolute path to the worktree (Claude reads the last non-empty line)
# exit 0: success; any other code fails worktree creation
#
# The emitted path must be absolute and free of "." / ".." segments, or Claude
# rejects it (its symlink screen cannot verify a dotted spelling).

set -euo pipefail

input=$(cat)
name=$(printf '%s' "$input" | jq -r '.name // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

if [ -z "$name" ]; then
  echo "WorktreeCreate: no worktree name supplied" >&2
  exit 1
fi

cd "${cwd:-$PWD}"

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "WorktreeCreate: ${cwd:-$PWD} is not a git repository" >&2
  exit 1
}

# Fall back to Claude's built-in layout when gtr is absent, so worktree
# isolation still works rather than failing outright.
if ! command -v gtr >/dev/null 2>&1; then
  dest="$repo_root/.claude/worktrees/$name"
  if [ ! -d "$dest" ]; then
    git worktree add -b "$name" "$dest" >&2
  fi
  (cd "$dest" && pwd -P)
  exit 0
fi

# Group worktrees per project as ~/src/worktrees/<repo>/<branch>. gtr builds
# paths as <gtr.worktrees.dir>/<prefix><branch>, so the trailing slash is what
# creates the subdirectory.
if [ -z "$(git config --local --get gtr.worktrees.prefix || true)" ]; then
  git config --local gtr.worktrees.prefix "$(basename "$repo_root")/"
fi

# gtr branches from <remote>/<default-branch>, which does not resolve in a repo
# with no remote (or one whose refs have never been fetched) -- it dies with
# "fatal: invalid reference: origin/main". Base off the current HEAD instead so
# worktrees still work in local-only repos.
remote=$(git config --get gtr.defaultRemote 2>/dev/null || echo origin)
base_args=()
if ! git remote get-url "$remote" >/dev/null 2>&1 ||
  [ -z "$(git for-each-ref --count=1 "refs/remotes/$remote")" ]; then
  base_args=(--from-current --no-fetch)
fi

# Reuse an existing worktree for this branch if there is one.
if ! path=$(gtr go "$name" 2>/dev/null) || [ ! -d "$path" ]; then
  gtr new "$name" ${base_args[@]+"${base_args[@]}"} </dev/null >&2
  path=$(gtr go "$name")
fi

(cd "$path" && pwd -P)
