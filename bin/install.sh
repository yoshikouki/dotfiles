#!/bin/bash

FILES='.??*'
IGNORE_FILES=(.git .gitignore .DS_Store)
GITHUB_URL=github.com/yoshikouki/dotfiles
DOTPATH=~/.dotfiles

has_command() {
  if type "$1" > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

echo 'Start to deploy dotfiles to home directory.'; echo ""

# HTTP経由でのインストールを実装する
echo '---------- Download dotfiles ----------'
## git が使える場合
if has_command "git";then
  echo 'use git'
  if [ -d "$DOTPATH" ]; then
    cd "$DOTPATH" || exit
    git pull
  else
    git clone --recursive "https://$GITHUB_URL.git" "$DOTPATH"
  fi

## curl / wget が使える場合
elif has_command "curl" || has_command "wget"; then
  tarball="$GITHUB_URL/archive/main.zip"
  if has_command "curl"; then
    echo 'use curl'
    curl -L "$tarball"
  elif has_command "wget"; then
    echo 'use wget'
    wget -O - "$tarball"
  fi | tar zxv -C ~/
  mv -iT ~/dotfiles-main "$DOTPATH"

# どちらもない場合は終了する
else
  echo "[ERROR] curl or wget required"
  exit
fi

## ~/.dotfiles があるか確認
cd "$DOTPATH" || { echo "[ERROR] not found: $DOTPATH"; exit 1; }
echo "---------- Downloaded ----------"; echo ""

# ドットファイルのシンボリックリンクをホームディレクトリに配置する
echo '---------- Create symbolic link  ----------'
for file in $FILES; do
  for ign in "${IGNORE_FILES[@]}"; do
    [[ "$ign" = "$file" ]] && continue 2
  done

  ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
echo '---------- Created ----------'
