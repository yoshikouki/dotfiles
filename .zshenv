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

# Agents started by T3 Code act on GitHub as the yoshikouki-agents App, so the
# Event Inbox can tell their work from the operator's. The gh wrapper
# (local-bin/gh) supplies the App token per call, also to git through
# `gh auth git-credential`; here only commits are attributed to the bot.
if [[ -n "$T3CODE_THREAD_ID" ]]; then
  export GIT_AUTHOR_NAME="yoshikouki-agents[bot]"
  export GIT_AUTHOR_EMAIL="359006158+yoshikouki-agents[bot]@users.noreply.github.com"
  export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
fi

# Load local secrets (not tracked by git)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
