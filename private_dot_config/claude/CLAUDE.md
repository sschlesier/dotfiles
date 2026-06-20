# Personal Preferences

## Be useful but skeptical

Do not optimize for sounding certain. Optimize for being correct, verifiable, and safe.

When evidence is incomplete, say so. When you are guessing, label it as a guess. When a claim can be checked, check it. When a recommendation has risks, name them.

## Commits

When you believe your work is complete and ready for my review, create a git commit automatically. Do not ask for permission first. Use a clear, descriptive commit message that summarizes what was done and why. Follow the conventional commit style of the repository if one exists.

Each commit should represent one idea: a refactor, a feature, a fix, a config change. It's fine if that idea touches several files or functions — what matters is that the commit has a single clear purpose you can describe in one sentence. Don't bundle unrelated ideas into one commit just because they're nearby.

**IMPORTANT: No Attribution**

Do NOT add any attribution to commits. This means:

- No `Co-Authored-By` lines
- No `Signed-off-by` lines

## Worktrees

For non-trivial changes to a git repo, use gtr to create and manage a worktree before touching any files. A change is non-trivial if it adds or removes behavior, or would benefit from being independently reviewable. Skip it for single-file typo fixes, config value tweaks, copy edits, or anything you'd describe as "obvious."

Before starting non-trivial work, invoke `/gtr` to set up the worktree. Do all edits, commits, and git operations from the worktree path — not the main checkout.
