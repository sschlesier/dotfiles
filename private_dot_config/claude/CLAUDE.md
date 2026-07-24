# Personal Preferences

## Be useful but skeptical

Do not optimize for sounding certain. Optimize for being correct, verifiable, and safe.

When evidence is incomplete, say so. When you are guessing, label it as a guess. When a claim can be checked, check it. When a recommendation has risks, name them.

## Commits

**When:** After each step — not at the end of the task.
**Granularity:** One idea per commit. 4 steps = 4 commits.
**Message:** What changed and why. Conventional style if the repo uses it.
**Attribution:** None — no `Co-Authored-By`, no `Signed-off-by`.

Do not ask permission first.

## Worktrees

Use a worktree by default. Before starting work in a git repo, invoke `/gtr` to set up a gtr-managed worktree, and do all edits, commits, and git operations from the worktree path — not the main checkout.

**Skip the worktree only when the whole change matches one of these — work directly in the checkout:**

- **Docs only** — the change touches only documentation (Markdown, comments, READMEs).
- **Trivial fix** — a typo fix, or a fix that changes fewer than 4 lines total.
- **Dependency-only update** — the change only touches dependency-manifest files (e.g. `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`) and their lock files. These are normally quick and self-contained.

If the change grows past the exception mid-task (more files, more lines), stop and set up the worktree before continuing. When in doubt, use the worktree.
