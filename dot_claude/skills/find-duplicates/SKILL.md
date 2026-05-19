---
name: find-duplicates
description: Use when the user wants to find duplicate or copy-pasted code in a repo using jscpd. Runs jscpd with AI-optimized output, groups findings by theme, and guides the user through deciding what to refactor.
allowed-tools: Bash, Read, Write
---

You are running a duplicate code review using jscpd. Follow these steps in order.

## Step 1: Check jscpd is available

Run `jscpd --version`. If the command fails, stop and tell the user:

> jscpd is not installed. Install it with: `brew install jscpd`

Do not proceed until it is available.

## Step 2: Check for existing config

Look for `.jscpd.json` in the current directory. If it exists, read it — you will use it as the base configuration and merge your additions rather than overriding it.

## Step 3: Propose paths to exclude

Scan the repo structure to identify directories and patterns that should be excluded from duplicate detection. Common candidates:

- `node_modules/`, `vendor/`, `bower_components/` — dependencies
- `dist/`, `build/`, `out/`, `.next/`, `.nuxt/`, `.svelte-kit/` — build artifacts
- `coverage/`, `.nyc_output/` — test coverage output
- `generated/`, `__generated__/`, `*.generated.*` — auto-generated files
- `**/*.min.js`, `**/*.min.css` — minified files
- `**/__snapshots__/` — Jest/Vitest snapshots
- `tmp/`, `temp/`, `.cache/` — temporary files
- `public/`, `static/` — static assets (if not source code)
- `migrations/` — database migrations (often similar by design)

Run `find . -maxdepth 3 -type d | head -80` (or equivalent) to discover the actual directory structure, then tailor the exclusion list to what is actually present.

Present a concise list of what you plan to exclude and why. Ask the user to confirm or adjust before running jscpd.

**Merge with any `ignore` already defined in `.jscpd.json`.**

## Step 4: Run jscpd

Build the command using these defaults (override with values from existing `.jscpd.json` where applicable):

- `--min-tokens 100` — skip trivially small blocks
- `--min-lines 10` — skip trivially short blocks
- `--reporters ai` — token-efficient LLM-optimized output
- `--gitignore` — respect .gitignore automatically
- `--ignore "..."` — the confirmed exclusion list from Step 3
- Target: the source root (default `.`, or ask user if unclear)

Example:
```bash
jscpd . \
  --min-tokens 100 \
  --min-lines 10 \
  --reporters ai \
  --gitignore \
  --ignore "node_modules,dist,build,**/*.min.js"
```

Run the command and capture the output. If jscpd exits with a non-zero code but still produces output, treat that as a soft warning (duplication above threshold), not a fatal error.

## Step 5: Analyze and group findings

Read the ai reporter output. Group the duplicate pairs into thematic clusters — patterns that represent the same kind of problem. Examples of clusters:

- **Error handling boilerplate** — same try/catch or error response shape repeated across files
- **Data transformation** — same mapping/normalization logic in multiple places
- **Test setup** — repeated beforeEach / fixture construction
- **API call patterns** — same fetch/axios wrapper repeated
- **Validation logic** — same field validation rules duplicated
- **Config/constants** — same literals or config objects repeated

For each cluster, summarize:
- What the pattern is (one sentence)
- How many times it appears and in which files
- Rough effort to extract (low / medium / high)
- Impact if extracted (how much code would be consolidated)

If total duplication is low (< 5% or fewer than 5 clone pairs), say so clearly and confirm whether the user still wants to proceed.

## Step 6: Ask which cluster to tackle

Present the grouped clusters as a ranked list (highest-impact / easiest first). Ask the user which cluster they want to address.

Do not start refactoring until the user picks a cluster.

## Step 7: Tackle the chosen cluster

Once the user selects a cluster:

1. Read the relevant files to understand the full context of the duplicated code.
2. Propose a concrete refactoring approach (extract function, shared module, HOC, base class, etc.) with a suggested name and file location.
3. Confirm the approach with the user before writing any code.
4. Implement the refactoring.
5. After completing the cluster, ask if the user wants to continue with another cluster or stop.

## Notes

- Always prefer the `ai` reporter over `json` or `console` — it is purpose-built for LLM pipelines and reduces token usage significantly.
- If the repo has a `.jscpd.json` with `reporters`, `minTokens`, or `minLines` already set, respect those values rather than overriding them with defaults.
- The goal is to surface *meaningful* duplication worth refactoring — not to achieve zero duplication. Some repetition (migrations, test structure, generated stubs) is intentional.
