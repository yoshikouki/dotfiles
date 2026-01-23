#!/bin/zsh

IGNORE_FILES=(.git .gitignore .DS_Store .idea)
GITHUB_REPO=yoshikouki/dotfiles
DOTPATH=~/dotfiles

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

echo "#️⃣ INSTALL homebrew"
if type "brew" > /dev/null 2>&1; then
  echo "✅ brew is already installed."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "✅ brew has been installed."
fi
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

# ドットファイルのシンボリックリンクをホームディレクトリに配置する
echo "#️⃣ CREATE symbolic link"
for file in .??*; do
  for ign in "${IGNORE_FILES[@]}"; do
    [[ "$ign" = "$file" ]] && continue 2
  done
  ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
ln -sfnv "$DOTPATH/config.fish" "$HOME/.config/fish/config.fish"

# OS-specific git config
mkdir -p "$HOME/.config/git"
ln -sfnv "$DOTPATH/.gitconfig.macos" "$HOME/.config/git/local.gitconfig"

# mise config
mkdir -p "$HOME/.config/mise"
ln -sfnv "$DOTPATH/mise.toml" "$HOME/.config/mise/config.toml"
echo "✅ CREATE symbolic link" "\n"

# mise https://mise.jdx.dev/getting-started.html
echo "#️⃣ INSTALL mise and tools"
if ! command -v mise &> /dev/null; then
  brew install mise
fi
mise trust "$DOTPATH/mise.toml"
mise install
echo "✅ INSTALL mise and tools" "\n"

# ターミナルを再起動する
echo "#️⃣ REBOOT shell"
exec "$SHELL" -l
echo "✅ REBOOT shell" "\n"

echo "#️⃣ INSTALL packages and applications"
./install_applications.sh
echo "✅ INSTALL packages and applications" "\n"

# echo "#️⃣ SETUP Prezto"
# if [[ ! -d ~/.zprezto ]]; then
#   git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"

#   # 既存の zsh 設定ファイルをバックアップ
#   cd "$HOME" || exit 1
#   BUCKUP_DIR="$HOME/backup-zsh-$(date '+%Y%m%d%H%M%S')" && mkdir "$BUCKUP_DIR" && \
#   mv zshmv .zlogin .zlogout .zprofile .zshenv .zshrc "$BUCKUP_DIR"
#   cd "$DOTPATH" || exit 1

#   for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
#     ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
#   done
# fi
# echo "✅ SETUP Prezto" "\n"
