#!/bin/bash

FILES='.??*'
IGNORE_FILES=(.git .gitignore .DS_Store)
GITHUB_URL=github.com/yoshikouki/dotfiles
DOTPATH=~/dotfiles
TMPFILE=~/dotfiles.zip

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
  if [ -d "$DOTPATH" ] && [ -e "$DOTPATH/.git" ] ; then
    cd "$DOTPATH" || exit
    git pull
  else
    mv "$DOTPATH" "$DOTPATH-$( date '+%Y%m%d-%H%M%S' ).backup"
    git clone --recursive "https://$GITHUB_URL.git" "$DOTPATH"
  fi

## curl / wget が使える場合
elif has_command "curl" || has_command "wget"; then
  # 既存の dotfiles は名前を変更する
  if [[ -d "$DOTPATH" ]]; then
    mv "$DOTPATH" "$DOTPATH-$( date '+%Y%m%d-%H%M%S' ).backup"
  fi
  tarball="$GITHUB_URL/archive/main.zip"
  if has_command "curl"; then
    echo 'use curl'
    curl -L "$tarball" -o "$TMPFILE"
  elif has_command "wget"; then
    echo 'use wget'
    wget "$tarball" -O "$TMPFILE"
  fi
  unzip -o "$TMPFILE" -d ~/
  mv ~/dotfiles-main "$DOTPATH"

# どちらもない場合は終了する
else
  echo "[ERROR] curl or wget required"
  exit
fi

## ~/dotfiles があるか確認
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
