# dotfiles

Dotfiles managed with Nix on macOS, with a legacy Homebrew bootstrap and mise runtimes.

## Supported platforms

- macOS (Apple Silicon)
- Ubuntu/Linux

## Nix on macOS

The new Mac configuration uses Lix, nix-darwin for macOS preferences, and
Home Manager for common CLI tools, Git and shell configuration. See
[nix/README.md](nix/README.md) for build, apply and update commands.

The Homebrew bootstrap below remains the legacy installation path.

## Installation

### macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yoshikouki/dotfiles/main/bin/install.mac.sh)"
```

or

```bash
git clone https://github.com/yoshikouki/dotfiles.git ~/dotfiles
sh ~/dotfiles/bin/install.mac.sh
```

### Ubuntu / Linux

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yoshikouki/dotfiles/main/bin/install.linux.sh)"
```

or

```bash
git clone https://github.com/yoshikouki/dotfiles.git ~/dotfiles
bash ~/dotfiles/bin/install.linux.sh
```

## What the install scripts do

1. Install Homebrew (macOS) / apt prerequisites + Linuxbrew (Linux)
2. Symlink dotfiles into `$HOME` (`.zshrc`, `.gitconfig`, `nvim/`, `yazi/`, `local-bin/` scripts, etc.)
3. Create `~/.config/git/local.gitconfig` from the OS template (machine-specific git settings, not tracked)
4. Install packages from `.Brewfile` (`brew bundle --global`)
5. Install the standalone [mise](https://mise.jdx.dev/) binary and language runtimes (`~/.config/mise/config.toml`: Go, Node.js, npm, Ruby, Python, Bun, Rust)

## What's included

- **Shell**: Zsh (`.zshrc`, `.zshenv`, `.zprofile`) with Homebrew-installed plugins
- **Git**: `.gitconfig` (+ delta, difftastic), `.gitignore_global`
- **Editors**: Neovim (LazyVim), `.vimrc`
- **TUI / CLI**: yazi, lazygit, tmux, fzf, ripgrep, etc. (see `.Brewfile`)
- **Scripts**: `local-bin/` → symlinked into `~/.local/bin`

## Maintenance

Node.js follows the current LTS release. Other language runtimes use supported
stable series; review series changes explicitly. The mise lockfile records the
resolved versions for both Linux arm64 and macOS arm64. Nix-managed macOS installs
update mise through Home Manager, rather than `mise self-update`.

```bash
# Re-apply symlinks / packages / runtimes
make install

# Install GUI applications only
make applications

# Apply macOS system defaults
make macos

# Update Homebrew packages to match .Brewfile
brew bundle --global

# Update mise itself and all runtimes within their configured release series
mise self-update --yes --no-plugins
mise upgrade
```

## Restore Linux user configuration

Use one checkout as the source, normally `~/dotfiles`. The Linux installer uses
its own checkout; it does not pull or switch another checkout during installation.
Host services and OS upgrades belong to `personal-infra`. The installer installs
only its apt prerequisites, without `upgrade`, `autoremove` or `autoclean`.

```bash
git -C ~/dotfiles pull --ff-only origin main
bash ~/dotfiles/bin/install.linux.sh --dry-run
bash ~/dotfiles/bin/install.linux.sh --config-only
# Install packages and runtimes as well, on the new host:
bash ~/dotfiles/bin/install.linux.sh
```

Configuration-only mode needs Bash and standard Linux tools, and performs no
package installation or service operation. It links an explicit list of public
configuration and helpers. Existing independent files, directories and different
symlinks are moved to `~/.local/state/dotfiles/before-link.*` before replacement.
Repeated runs leave matching links alone. `DOTFILES_TARGET_HOME` selects an
alternate configuration destination for staging and tests.

Keep `.zshenv.local`, `.zshrc.local`, local Git credentials, SSH keys and application
authentication outside this repository. They are not copied into Git or overwritten.
If local overrides duplicate managed configuration, reconcile them separately.
Optional Grok, Turso and OpenClaw integrations load only when installed;
this does not install or start those applications.

Run `bash bin/link.linux.test.sh` for preservation and idempotence checks in a
temporary destination. `make install` selects Linux or macOS from `uname`.
Homebrew casks and Xcode tools are restricted to macOS; service CLIs use mise.

The `bird` helper reads credentials from an external `BIRD_CONFIG` file (default
`~/.config/bird/config.json5`) or existing environment variables. Its underlying
CLI is selected by `BIRD_REAL_BIN`; credentials and that configuration file are
never installed from this repository.
