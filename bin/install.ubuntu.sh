DOTPATH="$HOME/dotfiles"

sudo apt update -y && sudo apt upgrade -y

# Tools
sudo apt install -y \
  curl \
  wget \
  git \
  unzip \
  fzf

# SSH
sudo apt install -y openssh-server
sudo service ssh restart

# fish https://fishshell.com/
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish
echo /usr/local/bin/fish | sudo tee -a /etc/shells
fish
chsh -s (which fish)
exec $SHELL -l

## fisher https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

## tide (theme) https://github.com/IlanCosman/tide
fisher install IlanCosman/tide@v6
tide configure \
  --auto \
  --style=Rainbow \
  --prompt_colors='True color' \
  --show_time='24-hour format' \
  --rainbow_prompt_separators=Vertical \
  --powerline_prompt_heads=Round \
  --powerline_prompt_tails=Round \
  --powerline_prompt_style='Two lines, character' \
  --prompt_connection=Solid \
  --powerline_right_prompt_frame=No \
  --prompt_connection_andor_frame_color=Darkest \
  --prompt_spacing=Sparse \
  --icons='Many icons' \
  --transient=No

# fzf
sudo apt install -y fzf
fisher install jethrokuan/fzf
# Legacy keybindings are kept by default, but these have conflict with key bindings in Fish 2.4.0.
set -U FZF_LEGACY_KEYBINDINGS 0
echo 'set -U FZF_LEGACY_KEYBINDINGS 0' >> cat ~/.config/fish/config.fish
exec $SHELL -l

# asdf https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
source ~/.asdf/asdf.fish
echo 'source ~/.asdf/asdf.fish' >> cat ~/.config/fish/config.fish
exec $SHELL -l

# ghq https://github.com/x-motemen/ghq?tab=readme-ov-file#installation
asdf plugin add ghq
asdf install ghq latest
## https://github.com/decors/fish-ghq?tab=readme-ov-file
fisher install decors/fish-ghq

# dotfiles
git clone https://github.com/yoshikouki/dotfiles.git $DOTPATH
ln -sfnv "$DOTPATH/.gitconfig" "$HOME/.gitconfig"
ln -sfnv "$DOTPATH/.gitignore_global" "$HOME/.gitignore_global"
