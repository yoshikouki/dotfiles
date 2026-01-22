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
    set -l normal (set_color normal)
    set -l dim (set_color --dim)
    set -l bold (set_color --bold)
    set -l cyan (set_color cyan)
    set -l blue (set_color blue)
    set -l now (date "+%Y-%m-%d %H:%M")
    set -l host (hostname)

    echo "$bold$cyan""fish"$normal"  $dim$now$normal"
    echo "  $bold$USER$normal@$bold$host$normal  $blue"(prompt_pwd)"$normal"
    echo "  type: "$dim"help$normal""  |  "$dim"exit$normal""  |  "$dim"fish_key_bindings$normal"
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

# asdf
if test -f ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
end

# Add: Ensure asdf paths are prepended to PATH so they take precedence over system Ruby
if functions -q fish_add_path
    # fish >= 3.2 では fish_add_path が利用可能
    fish_add_path --prepend $HOME/.asdf/shims $HOME/.asdf/bin
else
    # 旧バージョンの fish 向けフォールバック
    if not contains -- $HOME/.asdf/shims $PATH
        set -gx PATH $HOME/.asdf/shims $HOME/.asdf/bin $PATH
    end
end

# Go
source ~/.asdf/plugins/golang/set-env.fish
set -gx PATH ~/.local/bin $PATH

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
