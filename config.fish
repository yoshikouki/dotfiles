# Legacy keybindings are kept by default, but these have conflict with key bindings in Fish 2.4.0.
set -U FZF_LEGACY_KEYBINDINGS 0
# NVIDIA GPU for WSL2
set PATH /usr/lib/wsl/lib $PATH
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (/opt/homebrew/bin/brew shellenv)
end

function fish_greeting
end

# MacPorts
if functions -q fish_add_path
    fish_add_path --prepend /opt/local/bin
else
    if not contains -- /opt/local/bin $PATH
        set -gx PATH /opt/local/bin $PATH
    end
end

# https://github.com/tsub/fish-fzf-git-recent-branch
bind \cb fzf_git_recent_branch

# pnpm
set -gx PNPM_HOME "/Users/yoshikouki/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Load wrapper functions for ~/.local/bin scripts
if test -f ~/.local/bin/wrappers/local-bin.fish
    source ~/.local/bin/wrappers/local-bin.fish
end

# mise (自動でactivateされる)
set -gx PATH ~/.local/bin $PATH
if type -q mise
    mise activate fish | source
else if test -x /opt/homebrew/bin/mise
    /opt/homebrew/bin/mise activate fish | source
else if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

set -gx PATH "/Users/yoshikouki/.local/bin" $PATH

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# The next line updates PATH for the Google Cloud SDK.
if test -f '/Users/yoshikouki/google-cloud-sdk/path.fish.inc'
    source '/Users/yoshikouki/google-cloud-sdk/path.fish.inc'
end


source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script

# Added by Antigravity
fish_add_path /Users/yoshikouki/.antigravity/antigravity/bin

# Chromium Developer Tools
set -gx PATH ~/src/chromium.googlesource.com/chromium/tools/depot_tools $PATH

# zoxide: cd を置き換えつつ、z と zi も使えるようにする
zoxide init fish --cmd cd | source
alias z='__zoxide_z'
alias zi='__zoxide_zi'
