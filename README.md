# dotfiles

Dotfiles managed with symbolic links, Homebrew, and mise.

## Supported platforms

- macOS (Apple Silicon)
- Ubuntu/Linux

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
5. Install language runtimes via [mise](https://mise.jdx.dev/) (`.mise.toml`: Go, Node.js, Ruby, Python, Bun, Rust)

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
```
