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

For non-trivial changes to a git repo, use gtr to create and manage a worktree before touching any files. A change is non-trivial if it adds or removes behavior, or would benefit from being independently reviewable. Skip it for single-file typo fixes, config value tweaks, copy edits, or anything you'd describe as "obvious."

Before starting non-trivial work, invoke `/gtr` to set up the worktree. Do all edits, commits, and git operations from the worktree path — not the main checkout.
