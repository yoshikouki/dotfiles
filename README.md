# dotfiles

## macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yoshikouki/dotfiles/main/bin/install.mac.sh)"
```

or

```bash
git clone https://github.com/yoshikouki/dotfiles.git ~/dotfiles
sh ~/dotfiles/bin/install.mac.sh
```

## macOS (Nix / nix-darwin + home-manager)

前提: Nix をインストール済み（nix-command と flakes を有効化）。

```bash
git clone https://github.com/yoshikouki/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix run github:LnL7/nix-darwin -- switch --flake .#mac
```

補足:
- Apple Silicon 前提のため、Intel Mac は `flake.nix` の `system` を `x86_64-darwin` に変更してください。
- `home-manager` で `config.fish` / `nvim` / `local-bin` をリンクします。
- 初回実行時に `flake.lock` が生成されます。

## Ubuntu

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yoshikouki/dotfiles/main/bin/install.ubuntu.sh)"
```

or

```bash
git clone https://github.com/yoshikouki/dotfiles.git ~/dotfiles
sh ~/dotfiles/bin/install.ubuntu.sh
```

### What's installed

- **Shell**: Zsh (set as default)
- **Tools**: curl, wget, git, unzip, fzf
- **Version manager**: mise
- **Repository manager**: ghq
- **SSH server**: openssh-server
