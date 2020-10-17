#!/bin/bash

FILES='.??*'
IGNORE_FILES=(.git .gitignore .DS_Store)
GITHUB_URL=https://github.com/yoshikouki/dotfiles
DOTPATH=~/.dotfiles

has_command() {
  if type "$1" > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

echo 'Start to deploy dotfiles to home directory.'

# HTTP経由でのインストールを実装する
echo '---------- Download dotfiles ----------'
## git が使える場合
if has_command "git";then
  echo 'use git'
  git clone --recursive "$GITHUB_URL.git" "$DOTPATH"

## curl / wget が使える場合
elif has_command "curl" || has_command "wget"; then
  tarball="$GITHUB_URL/archive/master.tar.gz"
  if has_command "curl"; then
    echo 'use curl'
    curl -L "$tarball"
  elif has_command "wget"; then
    echo 'use wget'
    wget -O - "$tarball"
  fi | tar zxv
  mv -f dotfiles-master "$DOTPATH"

# どちらもない場合は終了する
else
  echo "curl or wget required"
  exit
fi

## ~/.dotfiles があるか確認
cd "$DOTPATH" || { echo "not found: $DOTPATH"; exit 1; }
echo '---------- Downloaded ----------'

# ドットファイルのシンボリックリンクをホームディレクトリに配置する
echo '---------- Create symbolic link  ----------'
for file in $FILES; do
  for ign in "${IGNORE_FILES[@]}"; do
    [[ "$ign" = "$file" ]] && continue 2
  done

  ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
echo '---------- Created ----------'
