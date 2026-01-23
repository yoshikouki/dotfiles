#!/bin/zsh

IGNORE_FILES=(.git .gitignore .DS_Store .idea)
GITHUB_REPO=yoshikouki/dotfiles
DOTPATH=~/dotfiles

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS"
	exit 1
fi

echo "#️⃣ INSTALL Nix"
if ! command -v nix > /dev/null 2>&1 && [ ! -x /nix/var/nix/profiles/default/bin/nix ]; then
	# Official installer (multi-user on macOS)
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
for file in .??*; do
	for ign in "${IGNORE_FILES[@]}"; do
		[[ "$ign" = "$file" ]] && continue 2
	done
	ln -sfnv "$DOTPATH/$file" "$HOME/$file"
done

# OS-specific git config
mkdir -p "$HOME/.config/git"
ln -sfnv "$DOTPATH/.gitconfig.macos" "$HOME/.config/git/local.gitconfig"
echo "✅ CREATE symbolic link" "\n"

echo "#️⃣ APPLY nix-darwin"
NIX_BIN="$(command -v nix || true)"
if [ -z "$NIX_BIN" ]; then
	NIX_BIN="/nix/var/nix/profiles/default/bin/nix"
fi
sudo "$NIX_BIN" --extra-experimental-features "nix-command flakes" \
	run nix-darwin/master#darwin-rebuild -- switch --flake "$DOTPATH#mac"
echo "✅ APPLY nix-darwin" "\n"

echo "#️⃣ REBOOT shell"
exec "$SHELL" -l
