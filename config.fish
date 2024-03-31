# Legacy keybindings are kept by default, but these have conflict with key bindings in Fish 2.4.0.
set -U FZF_LEGACY_KEYBINDINGS 0
# NVIDIA GPU for WSL2
set PATH /usr/lib/wsl/lib $PATH

if status is-interactive
    # Commands to run in interactive sessions can go here
end

source ~/.asdf/asdf.fish
