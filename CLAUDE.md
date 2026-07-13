# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A [chezmoi](https://www.chezmoi.io/) dotfiles repository. Chezmoi manages dotfiles by maintaining a source directory (this repo) and applying them to the home directory via `chezmoi apply`. Files are not edited directly in `~` — changes go here first, then applied.

## Chezmoi file naming conventions

Chezmoi encodes file attributes in source filenames:

| Prefix/suffix | Meaning |
|---|---|
| `dot_` | Becomes `.` in the target (e.g. `dot_zshenv` → `~/.zshenv`) |
| `private_` | Target file gets mode `0600` |
| `executable_` | Target file gets mode `0755` |
| `symlink_` | Target is a symlink |
| `empty_` | Target is an empty file |
| `.tmpl` suffix | Processed as a Go template before applying |

Files in `private_dot_config/` map to `~/.config/`.

## Templates

Files ending in `.tmpl` are Go templates. Template data comes from two sources:

- `.chezmoi.toml.tmpl` — the chezmoi config file template, renders to `~/.config/chezmoi/chezmoi.toml`
- `.chezmoidata.toml` — static key/value data available in all templates (e.g. `bat_light_theme`, `visidata_dark_theme`, `claude_light_theme`)

The rendered config sets `data.email`, `data.work`, `data.launch_tmux`, `data.npmtoken`. Reference these in templates as `.email`, `.work`, etc.

The `settings.json.tmpl` for Claude reads `$XDG_DATA_HOME/theme_mode` at apply time to set light/dark theme.

## Key workflows

**Apply dotfiles to home:**
```sh
chezmoi apply       # alias: ca
```

**Check what would change:**
```sh
chezmoi status      # alias: cs
chezmoi diff        # alias: cdf
```

**Edit a managed file** (opens in editor, applies on save):
```sh
chezmoi edit ~/.config/git/config
```

**Re-add a file** (sync home → source after editing in place):
```sh
chezmoi re-add ~/.config/zsh/0002-aliases.sh   # alias: cr
```

**Jump to source dir:**
```sh
cd $(chezmoi source-path)   # alias: ccs
```

## Structure

- `dot_local/bin/` — scripts installed to `~/.local/bin` and `~/.local/bin/work`; `work/` contains work-specific tooling
- `private_dot_config/zsh/` — zsh config, loaded numerically by `dot_zshrc` (`for sh in $ZDOTDIR/[0-9]*-*sh; do source "$sh"; done`)
- `private_dot_config/git/` — git config (template), aliases, and global ignore
- `private_dot_config/claude/` — Claude Code settings template and statusline script
- `private_dot_config/hammerspoon/` — Hammerspoon Lua config (window management, keybindings)
- `private_dot_config/kitty/` — Kitty terminal config
- `private_dot_config/nvim/` — Neovim config
- `private_dot_config/tmux/` — tmux config
- `private_dot_config/lf/` — lf file manager config
- `dot_agents/skills/` — Claude Code custom skills
- `.chezmoidata.toml` — non-secret template variables (themes, flags)
- `.chezmoiremove` — paths chezmoi will delete from the home dir on apply

## Zsh config load order

Files in `private_dot_config/zsh/` are sourced in numeric prefix order. Key files:

- `zshenv.tmpl` → `~/.config/zsh/zshenv` — XDG dirs, WSL detection, env vars (sourced before interactive check)
- `path.zsh` — `$PATH` setup: `$XDG_BIN_HOME` (`~/.local/bin`), Homebrew, cargo, go, gem, libpq, dotnet, Android SDK
- `0002-aliases.sh` — chezmoi aliases (`ca`, `cs`, `cr`, `cdf`, `ccs`), editor, gtr aliases (`wt`, `wtl`, `wtd`, `wtn`)
- `0010-antidote.sh` — loads antidote plugin manager
- `0600-dir-aliases.zsh` — `eza`/`ls` aliases, cdpath setup, named directory aliases

## Secrets and sensitive data

Secrets are **not** stored in this repo. The `.chezmoidata.toml` holds only non-sensitive defaults (`npmtoken = ""`). Actual secrets are fetched at apply time via:
- `lp-*` scripts (LastPass)
- `op-*` scripts (1Password)
- `keychain-secret` (macOS Keychain)

## `.chezmoiignore` vs `.chezmoiremove`

- `.chezmoiignore` — files in the source dir that chezmoi should not manage
- `.chezmoiremove` — paths in the home dir that chezmoi will actively delete on apply (stale dotfiles from previous configs)
