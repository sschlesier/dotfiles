---
name: invoke-worktree
description: Create a git worktree, copy dependencies, and launch Claude in a new kitty tab to work on requirements from an md file.
user_invocable: true
---

# Invoke Worktree

Launch a new worktree with Claude working on a requirements file in a separate kitty tab.

**Usage:** `/invoke-worktree <path-to-requirements.md>`

## 1. Validate Input

The user must provide a path to a markdown file as an argument. If no argument is provided, use `AskUserQuestion` to ask for the path.

Verify the file exists using `Read`. If it doesn't exist, report the error and stop.

## 2. Derive Branch Name

Extract a branch name from the requirements filename:

- Strip the `.md` extension and any leading path
- Convert to kebab-case (lowercase, spaces/underscores to hyphens)
- Prefix with `feat/` (e.g., `plans/dark-mode.md` → `feat/dark-mode`)

Show the derived branch name to the user. If they want a different name, they can provide one via `AskUserQuestion`.

## 3. Create Worktree with gtr

```bash
git gtr new <branch-name> --no-copy
```

The `--no-copy` flag is used because we handle file copying ourselves in the next step.

Capture the worktree path from the output. If the command fails (e.g., branch already exists), report the error and stop.

Get the worktree path:

```bash
git gtr go <branch-name>
```

Store this path as `$WORKTREE_PATH`.

## 4. Copy node_modules and Requirements

Copy `node_modules` into the worktree using hard links to save disk space and time:

```bash
cp -al node_modules "$WORKTREE_PATH/node_modules"
```

If `cp -al` fails (e.g., on a filesystem that doesn't support hard links), fall back to:

```bash
pnpm install --dir "$WORKTREE_PATH"
```

Copy the requirements markdown file into the worktree root:

```bash
cp <path-to-requirements.md> "$WORKTREE_PATH/"
```

## 5. Open Kitty Tab and Invoke Claude

The sandbox prevents access to kitty so put the needed command on the clipboard via pbcopy

```bash
cd "$WORKTREE_PATH"; claude --resume "Read $(basename <requirements-file>) and implement everything described in it. Run pnpm verify when done. After verification passes, commit all changes with a conventional commit message."
```

The `--resume` flag is used so Claude starts a new persistent session that can be resumed later.

## 6. Report

Tell the user:

- The worktree was created at `$WORKTREE_PATH` on branch `<branch-name>`
- Claude is working in a new kitty tab
- They can switch to that tab to monitor progress
- When done, they can remove the worktree with `git gtr rm <branch-name>`
