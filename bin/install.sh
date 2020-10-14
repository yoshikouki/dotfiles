#!/bin/bash

dotfiles_dir=$(cd "$(dirname "$0")"/../ || return; pwd)
files='.??*'
ignore_files=(.git .gitignore .DS_Store)

## Create symlink to home directory
echo 'Start to deploy dotfiles to home directory.'
echo '---------- Linked ----------'

for file in $files
do
  if [[ "${ignore_files[@]}" =~ $file ]]; then
    continue
  fi

  ln -sfnv "$dotfiles_dir/$file" "$HOME/$file"
done
echo '---------- Done Linked ----------'
