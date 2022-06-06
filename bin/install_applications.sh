#!/bin/bash

DOTPATH=~/dotfiles

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

echo "#️⃣ INSTALL packages and applications"
if type "brew" > /dev/null 2>&1; then
	echo "✅ brew is already installed."
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "✅ brew has been installed."
fi

if [[ -d ~/.Brewfile ]]; then
	echo "~/.Brewfile is already created"
else
	ln -sfnv "$DOTPATH/.Brewfile" ~/.Brewfile
	echo "Created ~/.Brewfile"
fi
# ~/.Brewfile を基に依存をインストール
brew bundle --global
echo "✅ INSTALL packages and applications" "\n"
