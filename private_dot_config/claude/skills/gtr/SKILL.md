---
name: gtr
description: Set up a git worktree before starting non-trivial work. Run this before editing any files when the change is non-trivial.
allowed-tools: Bash, Read, Edit, Write
---

You are setting up a git worktree so that all subsequent work happens in isolation from the main
checkout. Follow these steps in order.

Worktree placement is handled by a `WorktreeCreate` hook (`~/.config/claude/hooks/worktree-create.sh`),
not by you. It runs `gtr` and lands worktrees at `~/src/worktrees/<reponame>/<branch>`, setting the
per-repo `gtr.worktrees.prefix` on first use. Do not run `gtr new` yourself — creating the worktree
through `EnterWorktree` is what avoids an approval prompt, because Claude Code prompts before
entering any *pre-existing* worktree outside `<repo>/.claude/worktrees/`.

## Step 1: Check if already in a worktree

Run `git worktree list` and check whether the current directory (`git rev-parse --show-toplevel`)
appears as a linked worktree rather than the first (main) entry. If you are already inside a
non-main worktree, say so and skip to Step 4 — no new worktree is needed.

## Step 2: Choose a branch name

Derive a branch name from the task at hand:

- Use kebab-case, e.g. `fix-login-redirect` or `add-export-button`
- Keep it short (3-5 words max)
- Do not include a ticket number unless the user mentioned one

If the task is ambiguous, ask the user for a branch name before proceeding.

## Step 3: Create the worktree and switch into it

Call `EnterWorktree` with `name` set to the branch name from Step 2 — and **not** `path`. The two
are mutually exclusive, and `name` is the form that runs the hook and skips the approval prompt.

This creates the worktree and switches the session's working directory into it, so all subsequent
file reads, writes, edits, and git commands operate from the worktree with no path prefixes.

Report the worktree path from the tool result:

> Working in worktree: `<path>` on branch `<branch-name>`

If it fails, show the error and stop — do not fall back to `gtr new` plus `EnterWorktree path`, and
do not attempt to recover silently. Ask the user how to proceed.

## Step 4: Proceed with the task

Return to the original task. Use normal file tools and git commands — they operate on the worktree
automatically.

When you finish and commit, tell the user the branch name so they can open a PR:

```
gh pr create --head <branch-name>
```

Do NOT call `ExitWorktree` or remove the worktree — that happens after the PR is merged. If the user
wants to return to the main checkout mid-session, they can ask; use `ExitWorktree action: "keep"`,
which returns the CWD without touching the worktree or its branch.

## Notes

- Never nest worktrees. If Step 1 finds you are already in a non-main worktree, skip to Step 4.
- `EnterWorktree path` is only for switching into a worktree that already exists. It prompts for
  approval unless the target is under `<repo>/.claude/worktrees/`, and no setting suppresses that —
  the check is `classifierApprovable: false`. Worktrees created before this hook existed still live
  under `.claude/worktrees/` and enter without a prompt.
- If worktrees start appearing in `<repo>/.claude/worktrees/` again, the hook is falling back
  because `gtr` is not on PATH (`brew install coderabbitai/tap/gtr`).
