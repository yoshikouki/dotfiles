#!/bin/zsh

IGNORE_FILES=(.git .gitignore .DS_Store .idea)
GITHUB_REPO=yoshikouki/dotfiles
DOTPATH=~/dotfiles

if [ "$(uname)" != "Darwin" ]; then
    echo "Not macOS"
    exit 1
fi

echo "#️⃣ INSTALL Homebrew"
if ! command -v brew > /dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "✅ INSTALL Homebrew"

echo "#️⃣ DOWNLOAD dotfiles"
if [ -d "$DOTPATH" ]; then
    cd "$DOTPATH" && git pull --rebase
else
    git clone --recursive "https://github.com/$GITHUB_REPO.git" "$DOTPATH"
fi
echo "✅ DOWNLOAD dotfiles"

echo "#️⃣ CREATE symbolic link"
cd "$DOTPATH" || exit
for file in .??*; do
    for ign in "${IGNORE_FILES[@]}"; do
        [[ "$ign" = "$file" ]] && continue 2
    done
    ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done
mkdir -p "$HOME/.config/git"
ln -sfnv "$DOTPATH/.gitconfig.macos" "$HOME/.config/git/local.gitconfig"
ln -sfnv "$DOTPATH/nvim" "$HOME/.config/nvim"
ln -sfnv "$DOTPATH/yazi" "$HOME/.config/yazi"
mkdir -p "$HOME/.local/bin"
for script in "$DOTPATH/local-bin"/*; do
    [ -f "$script" ] && [ -x "$script" ] && ln -sfnv "$script" "$HOME/.local/bin/$(basename "$script")"
done
echo "✅ CREATE symbolic link"

echo "#️⃣ INSTALL Homebrew packages"
brew bundle --global
echo "✅ INSTALL Homebrew packages"

echo "#️⃣ INSTALL mise"
if ! command -v mise > /dev/null 2>&1; then
    curl https://mise.run | sh
fi
echo "✅ INSTALL mise"

echo "#️⃣ INSTALL runtimes via mise"
export PATH="$HOME/.local/bin:$PATH"
mise trust "$DOTPATH/.mise.toml"
mise install
echo "✅ INSTALL runtimes via mise"

echo "#️⃣ REBOOT shell"
exec "$SHELL" -l
