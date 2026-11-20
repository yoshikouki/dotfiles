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
# Event Inbox can tell their work from the operator's. `agent-github-token`
# reads the cached token; the gh wrapper refreshes it on every call.
agent_github_identity() {
  # Never trace the token, even under `zsh -x`.
  setopt localoptions noxtrace
  local token
  if ! token="$(agent-github-token)"; then
    print -u2 "warning: no GitHub App token for agents; GitHub writes from this shell act as the operator"
    return 1
  fi
  export GH_TOKEN="$token"
  export GIT_AUTHOR_NAME="yoshikouki-agents[bot]"
  export GIT_AUTHOR_EMAIL="359006158+yoshikouki-agents[bot]@users.noreply.github.com"
  export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
}
if [[ -n "$T3CODE_THREAD_ID" ]]; then
  agent_github_identity
fi
unfunction agent_github_identity

# Load local secrets (not tracked by git)
if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
