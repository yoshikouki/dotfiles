#!/bin/bash

IGNORE_FILES=(.git .gitignore .DS_Store .idea)
GITHUB_REPO=yoshikouki/dotfiles
DOTPATH=~/dotfiles

if [ "$(uname)" != "Linux" ]; then
	echo "Not Linux"
	exit 1
fi

echo "#️⃣ INSTALL Nix"
if ! command -v nix > /dev/null 2>&1 && [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
	# Official installer (multi-user on Linux)
	bash <(curl -L https://nixos.org/nix/install) --daemon
fi

# Load Nix env for this shell
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
	. /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

echo "✅ INSTALL Nix" "\n"

echo "#️⃣ ENABLE flakes"
NIX_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/nix/nix.conf"
mkdir -p "$(dirname "$NIX_CONF")"
if ! grep -Eq 'experimental-features *=.*(nix-command).*flakes|flakes.*nix-command' "$NIX_CONF" 2>/dev/null; then
	echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
fi
echo "✅ ENABLE flakes" "\n"

echo "#️⃣ DOWNLOAD dotfiles"
if [ -d "$DOTPATH" ]; then
	if command -v git > /dev/null 2>&1; then
		cd "$DOTPATH" || exit
		git pull --rebase
	fi
else
	if command -v git > /dev/null 2>&1; then
		git clone --recursive "https://github.com/$GITHUB_REPO.git" "$DOTPATH"
	else
		nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git --command \
			git clone --recursive "https://github.com/$GITHUB_REPO.git" "$DOTPATH"
	fi
fi
echo "✅ DOWNLOAD dotfiles" "\n"

echo "#️⃣ CREATE symbolic link"
cd "$DOTPATH" || exit
for file in .??*; do
	for ign in "${IGNORE_FILES[@]}"; do
		[[ "$ign" = "$file" ]] && continue 2
	done
	ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done

# OS-specific git config
mkdir -p "$HOME/.config/git"
ln -sfnv "$DOTPATH/.gitconfig.linux" "$HOME/.config/git/local.gitconfig"

# local-bin
mkdir -p "$HOME/.local/bin"
for script in "$DOTPATH/local-bin"/*; do
	if [ -f "$script" ] && [ -x "$script" ]; then
		ln -sfnv "$script" "$HOME/.local/bin/$(basename "$script")"
	fi
done
echo "✅ CREATE symbolic link" "\n"

echo "#️⃣ APPLY home-manager"
NIX_BIN="$(command -v nix || true)"
if [ -z "$NIX_BIN" ]; then
	NIX_BIN="/nix/var/nix/profiles/default/bin/nix"
fi
"$NIX_BIN" --extra-experimental-features "nix-command flakes" \
	run home-manager -- switch --flake "$DOTPATH#yoshikouki"
echo "✅ APPLY home-manager" "\n"

echo "#️⃣ REBOOT shell"
exec "$SHELL" -l
