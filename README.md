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
sh ~/dotfiles/bin/install.linux.sh
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
