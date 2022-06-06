#!/bin/zsh

FILES='.??*'
IGNORE_FILES=(.git .gitignore .DS_Store .idea)
GITHUB_REPO=yoshikouki/dotfiles
DOTPATH=~/dotfiles

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

echo "#️⃣ INSTALL homebrew"
./install_brew.sh
echo "✅ INSTALL homebrew" "\n"

echo "#️⃣ DOWNLOAD dotfiles"
# git がない場合はインストール
if ! type "git" > /dev/null 2>&1; then
  echo "Install git..."
  brew install git      
fi
if [ -d "$DOTPATH" ]; then
  cd "$DOTPATH" || exit
  git pull
else
  git clone --recursive "https://github.com/$GITHUB_REPO.git" "$DOTPATH"
fi
echo "✅ DOWNLOAD dotfiles" "\n"

echo "#️⃣ SETUP Prezto"
if [[ ! -d ~/.zprezto ]]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"

  # 既存の zsh 設定ファイルをバックアップ
  cd "$HOME" || exit 1
  BUCKUP_DIR="$HOME/backup-zsh-$(date '+%Y%m%d%H%M%S')" && mkdir "$BUCKUP_DIR" && \
  mv zshmv .zlogin .zlogout .zprofile .zshenv .zshrc "$BUCKUP_DIR"
  cd "$DOTPATH" || exit 1

  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi
echo "✅ SETUP Prezto" "\n"

# ドットファイルのシンボリックリンクをホームディレクトリに配置する
echo "#️⃣ CREATE symbolic link"
for file in $FILES; do
  for ign in "${IGNORE_FILES[@]}"; do
    [[ "$ign" = "$file" ]] && continue 2
  done
  ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
echo "✅ CREATE symbolic link" "\n"

# ターミナルを再起動する
echo "#️⃣ REBOOT shell"
exec "$SHELL" -l
echo "✅ REBOOT shell" "\n"

echo "#️⃣ INSTALL packages and applications"
./install_applications.sh
echo "✅ INSTALL packages and applications" "\n"
