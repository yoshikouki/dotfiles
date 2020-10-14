#!/bin/bash

dotfiles_dir=$(cd "$(dirname "$0")"/../ || return; pwd)
files='.??*'
ignore_files=(.git .gitignore .DS_Store)

## Create symlink to home directory
echo 'Start to deploy dotfiles to home directory.'
echo '---------- Linked ----------'

for file in $files
do
  for ign in "${ignore_files[@]}"
  do
    if [ "$ign" = "$file" ]
    then
      continue 2
    fi
  done

  ln -sfnv "$dotfiles_dir/$file" "$HOME/$file"
done
echo '---------- Done Linked ----------'
