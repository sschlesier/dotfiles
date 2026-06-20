---
name: gtr
description: Set up a gtr-managed git worktree before starting non-trivial work. Run this before editing any files when the change is non-trivial.
allowed-tools: Bash, Read, Edit, Write
---

You are setting up a git worktree using gtr so that all subsequent work happens in isolation from the main checkout. Follow these steps in order.

## Step 1: Verify prerequisites

Run these in parallel:
- `git rev-parse --git-dir 2>/dev/null` — confirm you are inside a git repo. If not, stop: "This skill only applies inside git repositories."
- `gtr --version 2>/dev/null` — confirm gtr is installed. If not, stop: "gtr is not installed. Install it with: `brew install coderabbitai/tap/gtr`"

Then check whether gtr has been configured for this repo:
```
git gtr config list --local 2>/dev/null
```

If the output is empty or the command errors, gtr has not been set up for this repo. Invoke `/gtr-setup` before continuing. Once it completes successfully, proceed to Step 2.

## Step 2: Check if already in a worktree

Run `git worktree list` and check whether the current directory (`git rev-parse --show-toplevel`) appears as a linked worktree (not the first/main entry). If you are already inside a non-main worktree, say so and skip to Step 5 — no new worktree is needed.

## Step 3: Choose a branch name

Derive a branch name from the task at hand:
- Use kebab-case, e.g. `fix-login-redirect` or `add-export-button`
- Keep it short (3-5 words max)
- Do not include a ticket number unless the user mentioned one

If the task is ambiguous, ask the user for a branch name before proceeding.

## Step 4: Create the worktree

Run:
```
gtr new <branch-name>
```

If it fails (e.g. branch already exists, gtr not configured for this repo), show the error and stop. Do not attempt to recover silently — ask the user how to proceed.

After it succeeds, find the worktree path:
```
git worktree list | grep <branch-name>
```

The path is the first field on that line. Confirm it exists with `ls <path>`.

## Step 5: Switch the session into the worktree

Call `EnterWorktree` with `path` set to the worktree path found in Step 4. This switches the session's working directory so all subsequent file reads, writes, edits, and git commands automatically operate from the worktree — no path prefixes needed.

Confirm the switch by stating:

> Working in worktree: `<path>` on branch `<branch-name>`

## Step 6: Proceed with the task

Return to the original task. The session is now rooted in the worktree. Use normal file tools and git commands — they will operate on the worktree automatically.

When you finish and commit, tell the user the branch name so they can open a PR:
```
gh pr create --head <branch-name>
```

Do NOT call `ExitWorktree` or remove the worktree — that happens after the PR is merged. If the user wants to return to the main checkout mid-session, they can ask; use `ExitWorktree action: "keep"` which returns the CWD without touching the worktree or its branch.

## Notes

- If `gtr new` prompts interactively, it likely needs one-time config. Tell the user to run `/gtr-setup` in this repo first, then retry.
- `EnterWorktree path` accepts any worktree registered in `git worktree list` — gtr-created worktrees qualify even though they are not in `.claude/worktrees/`.
- Never nest worktrees. If Step 2 finds you are already in a non-main worktree, skip to Step 6.
