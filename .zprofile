# Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"

# ==============================================================================
# Login shell environment
# ==============================================================================
# NOTE: zsh の login shell (zsh -l) は .zprofile を読むが、非インタラクティブだと
# .zshrc は読まれない。PATH に必要なものはここにも入れる。

# --- Homebrew shellenv ---
# macOS (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Linuxbrew
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Keep local wrappers and mise-managed runtimes ahead of Homebrew/system tools
# in login shells. Homebrew's shellenv prepends its own bin directories.
path=(
  "$HOME/.local/bin"
  "$HOME/.local/share/mise/shims"
  ${path:#"$HOME/.local/bin"}
  ${path:#"$HOME/.local/share/mise/shims"}
)
export PATH

# Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
