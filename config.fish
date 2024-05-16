# Legacy keybindings are kept by default, but these have conflict with key bindings in Fish 2.4.0.
set -U FZF_LEGACY_KEYBINDINGS 0
# NVIDIA GPU for WSL2
set PATH /usr/lib/wsl/lib $PATH

if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (/opt/homebrew/bin/brew shellenv)
end

source ~/.asdf/asdf.fish

# https://github.com/tsub/fish-fzf-git-recent-branch
bind \cb fzf_git_recent_branch

# pnpm
set -gx PNPM_HOME "/Users/yoshikouki/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
