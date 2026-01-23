# dotfiles

Declarative dotfiles management using Nix (nix-darwin + home-manager).

## Requirements

- Nix (installed automatically by install scripts)
- Supported platforms:
  - macOS (Apple Silicon)
  - Ubuntu/Linux (aarch64)

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

## What's included

### System Configuration (macOS only)
- **Package manager**: nix-darwin
- **Shell**: Zsh (system default)

### User Environment (macOS & Linux)
Managed by home-manager:

- **CLI Tools**: fd, fzf, ghq, ripgrep, jq, bat, delta, eza
- **Languages**: Go, Node.js, Ruby, Python, Bun, Rust
- **TUI Apps**: lazygit, tmux, yazi, zoxide
- **Editors**: Neovim
- **Service CLIs**: GitHub CLI (gh)
- **Config files**: .zshrc, .gitconfig, nvim, local-bin

## Updating

### macOS
```bash
darwin-rebuild switch --flake ~/dotfiles#mac
```

### Ubuntu / Linux
```bash
home-manager switch --flake ~/dotfiles#yoshikouki
```

## Notes

- Apple Silicon (aarch64) is the default architecture. For Intel Mac, change `system` in `flake.nix` to `x86_64-darwin`.
- Initial run generates `flake.lock` file.
- Dotfiles symlinks are created automatically by install scripts.
