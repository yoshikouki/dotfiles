#
# Defines environment variables.
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# 文字コードを UTF-8 に指定
export LANG=ja_JP.UTF-8

# mise shims (for non-interactive shells like editors/IDEs)
export PATH="$HOME/.local/share/mise/shims:$PATH"

# ~/.local/bin をPATHに追加
export PATH="$HOME/.local/bin:$PATH"

# npm global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# Load local secrets (not tracked by git)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
