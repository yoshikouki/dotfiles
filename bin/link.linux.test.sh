#!/bin/bash
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf -- "$test_dir"' EXIT
export DOTFILES_TARGET_HOME="$test_dir/home"
mkdir -p "$DOTFILES_TARGET_HOME/.config/git"
printf 'local shell\n' > "$DOTFILES_TARGET_HOME/.zshrc"
printf 'private\n' > "$DOTFILES_TARGET_HOME/.zshenv.local"
printf 'local git\n' > "$DOTFILES_TARGET_HOME/.config/git/local.gitconfig"
bash "$repo_dir/bin/install.linux.sh" --dry-run >/dev/null
[[ ! -L "$DOTFILES_TARGET_HOME/.zshrc" ]]
bash "$repo_dir/bin/install.linux.sh" --config-only
[[ "$(readlink "$DOTFILES_TARGET_HOME/.zshrc")" == "$repo_dir/.zshrc" ]]
[[ "$(cat "$DOTFILES_TARGET_HOME/.zshenv.local")" == private ]]
[[ "$(cat "$DOTFILES_TARGET_HOME/.config/git/local.gitconfig")" == 'local git' ]]
[[ ! -e "$DOTFILES_TARGET_HOME/.git" && ! -e "$DOTFILES_TARGET_HOME/.github" ]]
backup_count="$(find "$DOTFILES_TARGET_HOME/.local/state/dotfiles" -name .zshrc | wc -l)"
[[ "$backup_count" -eq 1 ]]
[[ "$(cat "$DOTFILES_TARGET_HOME"/.local/state/dotfiles/before-link.*/.zshrc)" == 'local shell' ]]
bash "$repo_dir/bin/install.linux.sh" --config-only
[[ "$(find "$DOTFILES_TARGET_HOME/.local/state/dotfiles" -name .zshrc | wc -l)" -eq 1 ]]
printf 'Linux configuration restore: preservation, allowlist and idempotence passed.\n'
