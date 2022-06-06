#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

echo "#️⃣ INSTALL packages and applications"
bin/install_brew.sh
if [[ ! -d ~/.Brewfile ]]; then
  ln -sfnv .Brewfile ~/.Brewfile
fi
# ~/.Brewfile を基に依存をインストール
brew bundle --global
echo "✅ INSTALL packages and applications" "\n"
