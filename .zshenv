#
# Defines environment variables.
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# 文字コードを UTF-8 に指定
export LANG=ja_JP.UTF-8

# Home Manager session variables
if [ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# ~/.local/bin をPATHに追加
export PATH="$HOME/.local/bin:$PATH"

# Load local secrets (not tracked by git)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
