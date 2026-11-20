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
# Event Inbox can tell their work from the operator's. The token comes from
# `bun cli github token` in yoshikouki/agent, which caches it with its expiry.
agent_github_identity() {
  # Never trace the token, even under `zsh -x`.
  setopt localoptions noxtrace
  zmodload -F zsh/datetime p:EPOCHSECONDS 2>/dev/null
  local cache="$HOME/.cache/agent/github-app-token" line expiry token rest
  if [[ -r "$cache" ]] && IFS= read -r line < "$cache" && [[ "$line" == *' '* ]]; then
    expiry="${line%% *}"
    token="${line#* }"
    if [[ "$expiry" != <-> || -z "$token" || "$token" == *[[:space:]]* ]] ||
      (( expiry <= EPOCHSECONDS + 900 )); then
      token=""
    fi
  fi
  if [[ -z "$token" ]]; then
    token="$(bun --silent --cwd "$HOME/src/github.com/yoshikouki/agent" cli github token 2>/dev/null)"
    [[ "$token" == *[[:space:]]* ]] && token=""
  fi
  if [[ -z "$token" ]]; then
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
