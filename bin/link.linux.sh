#!/bin/bash
set -euo pipefail

# Only user configuration belongs here; never glob hidden files or credentials.
dotfiles_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
target_home="${DOTFILES_TARGET_HOME:-$HOME}"
dry_run=false
case "${1:-}" in
	--dry-run) dry_run=true ;;
	'') ;;
	*) echo "Usage: $0 [--dry-run]" >&2; exit 2 ;;
esac
backup_dir=''
link_config() {
	local source="$dotfiles_dir/$1" relative="$2" target="$target_home/$2"
	if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
		return
	fi
	if $dry_run; then
		printf 'Link %s -> %s (preserve any existing destination)\n' "$target" "$source"
		return
	fi
	if [[ -e "$target" || -L "$target" ]]; then
		if [[ -z "$backup_dir" ]]; then
			mkdir -p "$target_home/.local/state/dotfiles"
			backup_dir="$(mktemp -d "$target_home/.local/state/dotfiles/before-link.XXXXXXXX")"
			printf 'Preserving previous configuration in %s\n' "$backup_dir"
		fi
		mkdir -p "$(dirname "$backup_dir/$relative")"
		mv -- "$target" "$backup_dir/$relative"
	fi
	mkdir -p "$(dirname "$target")"
	ln -s -- "$source" "$target"
}
for name in .Brewfile .gitconfig .gitignore_global .vimrc .zlogin .zlogout .zprofile .zshenv .zshrc; do
	link_config "$name" "$name"
done
link_config nvim .config/nvim
link_config yazi .config/yazi
link_config mise/config.toml .config/mise/config.toml
link_config mise/mise.lock .config/mise/mise.lock
for script in "$dotfiles_dir"/local-bin/*; do
	[[ -f "$script" && -x "$script" ]] || continue
	link_config "local-bin/$(basename "$script")" ".local/bin/$(basename "$script")"
done
if ! $dry_run && [[ ! -e "$target_home/.config/git/local.gitconfig" && ! -L "$target_home/.config/git/local.gitconfig" ]]; then
	mkdir -p "$target_home/.config/git"
	cp "$dotfiles_dir/.gitconfig.linux" "$target_home/.config/git/local.gitconfig"
fi
