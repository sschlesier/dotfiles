---
name: create-workspace
description: Use when the user wants to save the current plan and repo scope as a reusable Claude workspace. Creates a TOML workspace file and a markdown plan file in ~/src/.workspaces/.
allowed-tools: Write
---

The user wants to capture the current plan and repo scope as a reusable workspace. Generate two files.

## Step 1: Gather information

If not already clear from context, determine:
- A short kebab-case name for this workspace (e.g. `billing-refactor`)
- The src root where repos live (default: `~/src`)
- Which repos are involved and their roles:
  - `primary`: the repo Claude launches from; owns the change
  - `active`: repos that will be written to
  - `reference`: repos needed for context only, not modified
- Any environment variables needed for this work

Ask the user to clarify anything that is ambiguous before writing files.

## Step 2: Write the plan file

Write to `~/src/.workspaces/{name}-plan.md`.

Include:
- Problem statement
- Approach and key decisions
- Repos involved and why each one
- Open questions or risks
- Any cross-repo sequencing (what needs to happen in what order)

## Step 3: Write the workspace file

Write to `~/src/.workspaces/{name}.toml`.

Use this schema exactly:

```toml
name = "{name}"
plan = "./{name}-plan.md"
src = "~/src"   # absolute path to the directory containing all repos

# context is for durable operational notes, not the plan.
# omit if empty.
# context = ""

[[repos]]
path = "payments-service"   # dirname within src, not a full path
role = "primary"            # primary | active | reference
alias = "payments"          # optional, omit if dirname is already clear

[env]
# KEY = "value"  — omit entire section if no env vars needed
```

All repo paths are dirnames relative to `src`, not filesystem paths. The
launcher resolves them. This keeps workspace files portable across machines.

## Step 4: Confirm

Tell the user:
- Where the two files were written
- The command they will be able to run to launch this workspace once the launcher is built: `cw {name}`
- Any assumptions you made about roles or paths
