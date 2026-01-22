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
  zsh

# dotfiles
if [ ! -d "$DOTPATH" ]; then
  git clone https://github.com/yoshikouki/dotfiles.git "$DOTPATH"
fi
ln -sfnv "$DOTPATH/.gitconfig" "$HOME/.gitconfig"
ln -sfnv "$DOTPATH/.gitignore_global" "$HOME/.gitignore_global"
ln -sfnv "$DOTPATH/.zshrc" "$HOME/.zshrc"

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
  ln -sfnv /usr/share/doc/fzf/examples/key-bindings.zsh "$HOME/.zsh/fzf-key-bindings.zsh"
fi

# asdf https://asdf-vm.com/guide/getting-started.html
ASDF_VERSION="v0.14.0"
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch "$ASDF_VERSION"
fi

# ghq https://github.com/x-motemen/ghq
source "$HOME/.asdf/asdf.sh"
if ! asdf plugin list | grep -q ghq; then
  asdf plugin add ghq
fi
asdf install ghq latest
asdf global ghq latest

echo "Setup complete! Please restart your shell or run: exec zsh -l"
