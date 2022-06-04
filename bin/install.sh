#!/bin/bash

FILES='.??*'
IGNORE_FILES=(.git .gitignore .DS_Store .idea)
GITHUB_REPO=yoshikouki/dotfiles
DOTPATH=~/dotfiles

# コマンドがインストールされていれば true
is_exists() {
  if type "$1" > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# ####################
# インストールコマンド
#
# git がない場合はインストール
if ! is_exists "git"; then
  case "$(uname)" in
    # Linux の場合
    *'Linux'*)
      if [[ -f /etc/os-release ]]; then
          sudo apt install git
      fi
      ;;
    # Mac の場合
    *'Darwin'*)
      # brew がなければインストール
      if ! is_exists "brew"; then
        echo "Install brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew install git
      ;;
    # 例外
    *)
      e_error "このOSでは使えません"
      exit 1
      ;;
  esac
fi
echo 'Start to deploy dotfiles to home directory.'; echo ""

# HTTP経由でのインストールを実装する
echo '---------- Download dotfiles ----------'
if [ -d "$DOTPATH" ]; then
  cd "$DOTPATH" || exit
  git pull
else
  git clone --recursive "https://github.com/$GITHUB_REPO.git" "$DOTPATH"
fi
## ~/dotfiles があるか確認
cd "$DOTPATH" || { echo "[ERROR] not found: $DOTPATH"; exit 1; }
echo "---------- Downloaded ----------"; echo ""

# Prezto をインストールする
if [[ ! -d ~/.zprezto ]]; then
  echo "---------- Install Prezto ----------";
  git clone \
    --recursive https://github.com/sorin-ionescu/prezto.git \
    "$HOME/.zprezto"
  echo "---------- Installed Prezto ----------"; echo ""

  # 既存の zsh 設定ファイルをバックアップ
  cd "$HOME" || exit 1
  BUCKUP_DIR="$HOME/backup-zsh-$(date "+%Y%m%d%H%M%S")" \
  && mkdir "$BUCKUP_DIR" \
  && mv zshmv .zlogin .zlogout .zprofile .zshenv .zshrc "$BUCKUP_DIR"
  cd "$DOTPATH" || exit 1
fi

# ドットファイルのシンボリックリンクをホームディレクトリに配置する
echo '---------- Create symbolic link  ----------'
for file in $FILES; do
  for ign in "${IGNORE_FILES[@]}"; do
    [[ "$ign" = "$file" ]] && continue 2
  done
  ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
echo '---------- Created ----------'

# ターミナルを再起動する
exec "$SHELL" -l
