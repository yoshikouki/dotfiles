#!/bin/bash

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS"
	exit 1
fi

# brew がなければインストール
if ! type "brew" > /dev/null 2>&1; then
    echo "Install brew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# ~/.Brewfile を基に依存をインストール
brew bundle --global
