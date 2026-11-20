#
# Defines environment variables.
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# 文字コードを UTF-8 に指定
export LANG=ja_JP.UTF-8
if [[ "$LC_CTYPE" == "UTF-8" ]]; then
  export LC_CTYPE="$LANG"
fi

export DISABLE_TELEMETRY=1

# mise shims (for non-interactive shells like editors/IDEs)
export PATH="$HOME/.local/share/mise/shims:$PATH"

# ~/.local/bin をPATHに追加
export PATH="$HOME/.local/bin:$PATH"

# npm global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# Bun global packages
for bun_bin in "${BUN_INSTALL:-${XDG_CACHE_HOME:-$HOME/.cache}/.bun}/bin" "$HOME/.bun/bin"; do
  if [ -d "$bun_bin" ]; then
    case ":$PATH:" in
      *":$bun_bin:"*) ;;
      *) export PATH="$PATH:$bun_bin" ;;
    esac
  fi
done
unset bun_bin

# Load local secrets (not tracked by git)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
