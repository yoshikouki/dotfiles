# Repository Guidelines

## Project Structure & Module Organization
- `bin/`: bootstrap scripts for macOS/Linux, app installs, and macOS defaults.
- `local-bin/`: small CLI helpers that are symlinked into `~/.local/bin`.
- `nvim/`: Neovim config in Lua. Core config lives in `nvim/lua/config`, plugins in `nvim/lua/plugins`.
- `yazi/`: Yazi file manager config; plugins are recorded in `yazi/package.toml`.
- `nix/` and `flake.nix`: Lix, nix-darwin and Home Manager configuration for macOS and Raspberry Pi OS. See `nix/README.md`.
- Root dotfiles: `.zshrc`, `.gitconfig*`, `.Brewfile`, `.vimrc`, `loop-keybinds.json`.
- `mise/`: global runtime configuration and lockfile, symlinked into `~/.config/mise/`.
- `CLAUDE.md`: notes for Claude Code; it defers to the safety checklist in this file.

## Build, Test, and Development Commands
- `bin/install.mac.sh`: bootstrap macOS (packages, symlinks, runtimes).
- `bin/install.linux.sh`: bootstrap Linux (packages, symlinks, runtimes).
- `bin/install_applications.sh`: optional app installs.
- `bin/macos-defaults.sh`: apply macOS defaults.
- `make applications` and `make macos`: wrappers used by CI; update `Makefile` and `.github/workflows/ci.yml` together if scripts change.

## Coding Style & Naming Conventions
- Lua is formatted with Stylua (`nvim/stylua.toml`): 2-space indentation, 120-column width. Run `stylua nvim` after edits.
- Shell scripts in `bin/` use `#!/bin/bash`, except `bin/install.mac.sh` and `bin/macos-defaults.sh`, which use `#!/bin/zsh`. Indent with tabs (`install.mac.sh` uses four spaces); keep the existing style of each file consistent.
- Naming: platform scripts follow `install.<platform>.sh`, and Neovim plugin files are kebab-case (e.g., `vscode-style.lua`).

## Testing Guidelines
The only automated test is `bin/link.linux.test.sh`, which verifies the Linux symlink restore in a temporary home directory. CI (`.github/workflows/ci.yml`) has two jobs: `build` runs `make install`, `make macos`, and `make applications` on macOS; `linux-config` runs `bash -n` over the Linux scripts and then `bin/link.linux.test.sh` on Ubuntu. Keep both jobs green. Everything else is validated by running the relevant install script on a clean VM or container.

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
- `.gitconfig`: `user.email = yoshikouki@gmail.com`
