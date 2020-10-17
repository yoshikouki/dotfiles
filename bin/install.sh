#!/bin/bash

FILES='.??*'
IGNORE_FILES=(.git .gitignore .DS_Store)
DOTPATH=~/.dotfiles

echo 'Start to deploy dotfiles to home directory.'

# ドットファイルのシンボリックリンクをホームディレクトリに配置する
echo '---------- Create symbolic link  ----------'
for file in $FILES; do
  for ign in "${IGNORE_FILES[@]}"; do
    [[ "$ign" = "$file" ]] && continue 2
  done

  ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
echo '---------- Created ----------'
