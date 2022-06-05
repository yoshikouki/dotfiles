#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

./install_brew.sh

# ~/.Brewfile を基に依存をインストール
brew bundle --global
