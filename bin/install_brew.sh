#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

# brew がなければインストール
if ! type "brew" > /dev/null 2>&1; then
    echo "Install brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅ brew has been installed."
fi
