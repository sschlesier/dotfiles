# npm-audit

Analyze and resolve npm audit vulnerabilities in this project, one at a time.

## Step 1 — Baseline

Run `npm audit` and capture the full output. Report a summary table:
- How many vulnerabilities, by severity
- Which are auto-fixable (no breaking changes) vs. which require `--force` (breaking semver bump)
- Any that are dev-only (appear only in devDependencies subtree)

Do not analyze any individual vulnerability yet. Just show the table.

## Step 2 — Apply safe auto-fixes

If there are any vulnerabilities fixable via `npm audit fix` (no breaking changes), apply them now — no need to pause for review since npm itself guarantees these are non-breaking. Run `npm audit fix` until it stabilizes (re-run if it fixes something), then run `npm audit` again to see what remains. Commit the result.

List the remaining vulnerabilities by name only — do not analyze them yet.

Then **STOP and ask the user which vulnerability to tackle first.**

## Step 3 — Analyze ONE vulnerability at a time

Work on exactly one vulnerability per iteration. Do not move to the next until the user explicitly says to proceed.

### 3a. Explain why it can't auto-fix
State clearly: what package is vulnerable, what the current version is, what version fixes it, and why npm won't apply it automatically (e.g. major semver bump, or no fix exists upstream).

### 3b. Research the breaking changes
Using web search or the package's GitHub releases/CHANGELOG, identify every breaking change between the currently installed version and the fix version. Focus on:
- Removed APIs or config options
- Changed default behaviors
- Dropped runtime/peer dependency versions
- Renamed exports or changed module formats

Do not guess. If you haven't checked the CHANGELOG or release notes, say so and check them.

### 3c. Assess impact on this codebase
Check `package.json` for the affected package and any packages that depend on it. Search the source files for usage of any removed or changed APIs. Be specific:
- Which breaking changes apply to this project (with file:line references)
- Which breaking changes do NOT apply (with a brief reason)
- Overall risk: **safe to upgrade** / **needs code changes** / **blocked by a deeper dep**

### 3d. Propose a course of action
Recommend one of:
1. **Upgrade now** — if no breaking changes affect this codebase; provide the exact `npm install pkg@version` command
2. **Upgrade with changes** — if breaking changes apply but are small; show exactly what code needs to change alongside the upgrade command
3. **Ignore/defer** — if the fix requires a breaking upgrade that is too risky or blocked, or no fix exists upstream; explain specifically why the attack vector doesn't reach this codebase

**STOP. Present this analysis and wait for the user to approve or redirect before doing anything.**

Once the user approves, apply the agreed action and commit it. Then ask which vulnerability to tackle next.

## Step 4 — Ignoring a vulnerability with npm-audit-resolver

If the user decides to defer or ignore a vulnerability:

1. Check whether `npm-audit-resolver` is installed globally:
   ```
   resolve-audit --version
   ```
   If not: `npm install -g npm-audit-resolver`

2. Run the interactive resolver:
   ```
   resolve-audit
   ```
   Options:
   - **ignore** — permanent (or expiring) ignore recorded in `audit-resolve.json`
   - **remind in 24h (postpone)** — 24-hour deferral; CI passes today

3. Commit `audit-resolve.json`:
   ```
   git add audit-resolve.json
   git commit -m "chore: audit-resolve — ignore <advisory> (<reason>)"
   ```

**When to ignore vs. upgrade:**
- Ignore when: the vulnerable code path is unreachable in production (dev-only dep, feature of the library you don't use, or trusted input only).
- Upgrade when: you can do so safely or with small, low-risk changes.
- Never ignore critical/high severity in a production dependency without documenting exactly why the attack vector doesn't apply.

## Step 5 — Final CI gate

Once all vulnerabilities are either fixed or recorded in `audit-resolve.json`, run:
```
npx check-audit
```

This is what CI runs. It exits 0 only if every `npm audit` finding has a valid, non-expired decision in `audit-resolve.json`. If it exits 1, return to Step 3 for the remaining item.

Report the final result to the user.
