#!/bin/bash
set -euo pipefail

if [[ "$(uname)" != Linux ]]; then
	echo 'Not Linux' >&2
	exit 1
fi
mode="${1:-install}"
case "$mode" in
	install|--config-only|--dry-run) ;;
	*) echo "Usage: $0 [--config-only|--dry-run]" >&2; exit 2 ;;
esac

# A checkout is the installation source. A downloaded bootstrap uses ~/dotfiles.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-}")" && pwd)"
if [[ -f "$script_dir/link.linux.sh" ]]; then
	dotfiles_dir="$(cd "$script_dir/.." && pwd)"
else
	dotfiles_dir="$HOME/dotfiles"
	if [[ ! -d "$dotfiles_dir/.git" ]]; then
		if [[ "$mode" != install ]]; then
			echo 'Clone dotfiles before a configuration-only or dry run.' >&2
			exit 1
		fi
		git clone --recursive https://github.com/yoshikouki/dotfiles.git "$dotfiles_dir"
	fi
fi
if [[ "$mode" == --dry-run ]]; then
	exec bash "$dotfiles_dir/bin/link.linux.sh" --dry-run
fi
if [[ "$mode" == --config-only ]]; then
	exec bash "$dotfiles_dir/bin/link.linux.sh"
fi

# Host-wide upgrades and removals belong to personal-infra maintenance.
sudo apt-get update
sudo apt-get install -y build-essential curl git zsh
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
	chsh -s "$(command -v zsh)"
fi
if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
bash "$dotfiles_dir/bin/link.linux.sh"
brew bundle --file="$dotfiles_dir/.Brewfile"
ya pkg install
if [[ ! -x "$HOME/.local/bin/mise" ]]; then
	curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"
mise install
printf 'Configuration installed from %s. Start a new login shell.\n' "$dotfiles_dir"
