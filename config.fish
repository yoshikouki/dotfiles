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

# ghq 検索
function g
  set repo_name (ghq list | fzf --reverse +m)
  if test -n "$repo_name"
    cd (ghq root)/$repo_name
  end
end

# ブランチ検索
function b
  set branch (git branch --sort=-committerdate | fzf --reverse)
  if test -n "$branch"
    git switch (echo $branch | sed 's/^[ *]*//')
  end
end

# ブランチ作成
function c
  if test (count $argv) -eq 0
    read -P "branch name: " branch_name
  else
    set branch_name $argv[1]
  end
  if test -n "$branch_name"
    git switch -c $branch_name
  else
    echo "Branch name is required."
  end
end

# yazi
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	set -l target (test (count $argv) -gt 0; and echo $argv; or echo ".")
	command yazi $target --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
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

# cdx function
function cdx
  if test "$argv[1]" = "update"
    npm install -g @openai/codex@latest
  else
    codex \
    --dangerously-bypass-approvals-and-sandbox \
    -c model_reasoning_summary_format=experimental \
    --search $argv
  end
end

source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script

# Added by Antigravity
fish_add_path /Users/yoshikouki/.antigravity/antigravity/bin

# Chromium Developer Tools
set -gx PATH ~/src/chromium.googlesource.com/chromium/tools/depot_tools $PATH

# Claude Code
set -U ENABLE_TOOL_SEARCH true

# Add this to the end of your config file:
zoxide init fish | source

