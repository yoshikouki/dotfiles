# Repository Guidelines

## Project Structure & Module Organization
- `bin/`: bootstrap scripts for macOS/Linux, app installs, and macOS defaults.
- `local-bin/`: small CLI helpers that are symlinked into `~/.local/bin`.
- `nvim/`: Neovim config in Lua. Core config lives in `nvim/lua/config`, plugins in `nvim/lua/plugins`.
- Root dotfiles: `.zshrc`, `.gitconfig*`, `.Brewfile`, `.mise.toml`, `.vimrc`, `loop-keybinds.json`.

## Build, Test, and Development Commands
- `bin/install.mac.sh`: bootstrap macOS (packages, symlinks, runtimes).
- `bin/install.linux.sh`: bootstrap Linux (packages, symlinks, runtimes).
- `bin/install_applications.sh`: optional app installs.
- `bin/macos-defaults.sh`: apply macOS defaults.
- `make applications` and `make macos`: wrappers used by CI; update `Makefile` and `.github/workflows/ci.yml` together if scripts change.

## Coding Style & Naming Conventions
- Lua is formatted with Stylua (`nvim/stylua.toml`): 2-space indentation, 120-column width. Run `stylua nvim` after edits.
- Shell scripts in `bin/` use `#!/bin/bash` and tab indentation; keep the existing style consistent.
- Naming: platform scripts follow `install.<platform>.sh`, and Neovim plugin files are kebab-case (e.g., `vscode-style.lua`).

## Testing Guidelines
There is no unit test suite. Validate changes by running the relevant install script on a clean VM or container. CI runs `make install`, `make macos`, and `make applications` on macOS; keep those targets green.

## Commit & Pull Request Guidelines
- Commit messages generally follow Conventional Commits: `type(scope): summary` (e.g., `feat(zsh): ...`, `fix(nvim): ...`).
- Keep summaries short; Japanese summaries are acceptable if consistent with nearby history.
- PRs should include a brief summary, target OS, and the commands you ran (e.g., `bin/install.mac.sh`). Note any changes that affect symlinks or modify system defaults.

## Configuration & Safety Notes
Install scripts modify shell defaults, install packages, and create symlinks for dotfiles. Review scripts before running on a primary machine.

## Public Repo Safety Checklist

This repository is **public**. Before every commit, verify staged changes contain none of the following:

1. **Secrets** — API keys, tokens, passwords, private credentials
   ```bash
   git diff --staged | grep -iE "(api[_-]?key|token|password|secret|credential)\s*[=:]\s*\S"
   ```
2. **Hardcoded home paths** — `/home/<user>/` or `/Users/<user>/` embedded in config files
   ```bash
   git diff --staged | grep -E "/(home|Users)/[a-zA-Z0-9_-]+"
   ```
3. **Company-internal info** — internal hostnames, domains, or project names not meant to be public
4. **Unintended files** — logs, screenshots, or editor artifacts not covered by `.gitignore`

### Known Accepted Exceptions

These exist intentionally and are not security issues:
- `.gitconfig`: `git.pepabo.com` credential helper entry
- `.gitconfig`: `user.email = yoshikouki@gmail.com`
