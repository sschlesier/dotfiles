---
allowed-tools: Bash(git *), Bash(ls *), Bash(test *), Glob
---

# gtr-setup: Configure git-worktree-runner for this repo

Sets up `git gtr` config for the current repo by detecting the project type and applying the correct profile.

Usage:
- `/gtr-setup` — auto-detect project type
- `/gtr-setup npm` — force a specific profile

## Step 1: Verify prerequisites

Run these in parallel:

```bash
git rev-parse --git-dir
git gtr --version 2>/dev/null || echo "gtr-not-found"
```

- If `git rev-parse` fails → abort: "This command must be run inside a git repository."
- If gtr is not found → abort: "`git gtr` is not installed. Install git-worktree-runner first."

## Step 2: Determine profile

**If `$ARGUMENTS` is non-empty**, use it as the profile name. Validate it is one of the supported profiles listed below; if not, list them and abort.

**Otherwise auto-detect** by checking for the following files in the repo root (run checks in parallel):

| File / Pattern | Profile |
|---|---|
| `package.json` | `npm` |
| `build.gradle.kts` or `build.gradle` | `kotlin` |

- If exactly one profile matches → use it.
- If multiple match → tell the user which were found and ask them to specify a profile explicitly.
- If none match → list supported profiles and ask the user to specify one.

## Step 3: Read existing config

```bash
git gtr config list --local
```

Save this output. You will use it in Step 4 to avoid adding duplicate entries and to detect entries that must be removed.

## Step 4: Apply the profile

Find the matching profile section below. Follow its **Required**, **Forbidden**, and **Steps** subsections exactly.

For **multi-valued keys** (`gtr.copy.include`, `gtr.copy.exclude`, `gtr.copy.includeDirs`, `gtr.hook.postCreate`):
- Only `add` a value if it is not already present in the current config.
- Use `git gtr config add <key> <value>` to add.

For **forbidden entries**:
- Use `git gtr config unset <key> <value>` to remove each one that is currently present.
- If the key/value is not present, skip it silently (unset on a missing key errors harmlessly, but prefer to skip).

---

## Profile: npm

### Required entries

```
gtr.copy.include=.env
gtr.copy.include=.claude/settings.local.json
gtr.copy.include=.cursor/**
gtr.copy.exclude=**/.env.production*
gtr.copy.exclude=**/secrets.*
gtr.copy.exclude=**/*.log
gtr.hook.postcreate=npm install
```

### Forbidden entries (remove if present)

```
gtr.copy.includedirs=node_modules
gtr.copy.exclude=node_modules/.cache/**
gtr.copy.exclude=node_modules/**/.cache/**
gtr.copy.exclude=node_modules/.bin/**
```

### Why

`node_modules` is intentionally excluded from copying — the `npm install` post-create hook handles it instead. Copying `node_modules` between worktrees wastes disk space and can cause subtle issues with native binaries and cache state.

---

## Profile: kotlin

> **Note:** This profile is a placeholder. Fill in the required/forbidden entries when the Kotlin config is established.

### Required entries

*(to be defined)*

### Forbidden entries

*(to be defined)*

---

## Step 5: Verify

Run `git gtr config list --local` again and display the gtr entries. Confirm:

1. Every required entry for the applied profile is present (exactly once).
2. No forbidden entries are present.

If anything is wrong, fix it and re-verify. Once clean, report success with a brief summary of what was added/removed.
