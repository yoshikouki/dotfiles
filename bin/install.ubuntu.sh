#!/bin/bash
set -euo pipefail

DOTPATH="$HOME/dotfiles"

sudo apt update -y && sudo apt upgrade -y

# Tools
sudo apt install -y \
  curl \
  wget \
  git \
  unzip \
  fzf \
  zsh \
  neovim

# dotfiles
if [ ! -d "$DOTPATH" ]; then
  git clone https://github.com/yoshikouki/dotfiles.git "$DOTPATH"
fi
ln -sfnv "$DOTPATH/.gitconfig" "$HOME/.gitconfig"
ln -sfnv "$DOTPATH/.gitignore_global" "$HOME/.gitignore_global"
ln -sfnv "$DOTPATH/.zshrc" "$HOME/.zshrc"
ln -sfnv "$DOTPATH/.zprofile" "$HOME/.zprofile"
ln -sfnv "$DOTPATH/.zlogin" "$HOME/.zlogin"
ln -sfnv "$DOTPATH/.zlogout" "$HOME/.zlogout"

# Neovim
mkdir -p "$HOME/.config"
ln -sfnv "$DOTPATH/nvim" "$HOME/.config/nvim"

# local-bin
mkdir -p "$HOME/.local/bin"
for script in "$DOTPATH/local-bin"/*; do
  if [ -f "$script" ] && [ -x "$script" ]; then
    ln -sfnv "$script" "$HOME/.local/bin/$(basename "$script")"
  fi
done

# SSH
sudo apt install -y openssh-server
sudo service ssh restart

# Zsh
if ! grep -q "$(which zsh)" /etc/shells; then
  echo "$(which zsh)" | sudo tee -a /etc/shells
fi
chsh -s "$(which zsh)"

# fzf key bindings
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  mkdir -p "$HOME/.zsh"
  ln -sfnv /usr/share/doc/fzf/examples/key-bindings.zsh "$HOME/.zsh/fzf-key-bindings.zsh"
fi

# mise https://mise.jdx.dev/getting-started.html
if ! command -v mise &> /dev/null; then
  curl https://mise.run | sh
fi
eval "$(~/.local/bin/mise activate bash)"

# ghq https://github.com/x-motemen/ghq
mise use -g ghq@latest

# Cleanup
sudo apt autoremove -y
sudo apt clean

echo "Setup complete! Please restart your shell or run: exec zsh -l"
