#!/bin/bash

DOTPATH="$HOME/dotfiles"

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# fish https://fishshell.com/
brew install fish
mkdir -p "$HOME/.config/fish"
ln -sfnv "$DOTPATH/config.fish" "$HOME/.config/fish/config.fish"
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
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
brew install fzf
fisher install PatrickF1/fzf.fish
exec $SHELL -l

# ghq https://github.com/x-motemen/ghq?tab=readme-ov-file#installation
## https://github.com/decors/fish-ghq?tab=readme-ov-file
fisher install decors/fish-ghq

# https://github.com/tsub/fish-fzf-git-recent-branch
fisher install tsub/fish-fzf-git-recent-branch
bind \cb fzf_git_recent_branch
echo 'bind \cb fzf_git_recent_branch' >> cat ~/.config/fish/config.fish
