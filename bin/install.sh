#!/bin/bash

dotfiles_dir=$(cd "$(dirname "$0")"/../ || return; pwd)

## Create symlink to home directory
echo 'Start to deploy dotfiles to home directory.'
echo '---------- Linked ----------'
for file in .??*
do
    if [ "$file" == ".git" ] \
    || [ "$file" == ".gitignore" ] \
    || [ "$file" == ".DS_Store" ]; then
      continue
    fi
    
    ln -sfnv "$dotfiles_dir/$file" "$HOME/$file"
done
echo '---------- Done Linked ----------'
