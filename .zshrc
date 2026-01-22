# ####################
# 基本設定
#
## 文字コードを UTF-8 に指定
export LANG=ja_JP.UTF-8
## zsh 補完
autoload -Uz compinit && compinit -u
## 色を使用出来るようにする
autoload -Uz colors && colors
## ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
## 単語の区切り文字を指定する
autoload -Uz select-word-style && select-word-style default
### ここで指定した文字は単語区切りとみなされる
### / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path \
  /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin \
  /sbin /bin \
  /usr/X11R6/bin
## ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# ####################
# オプション設定
#
## 日本語ファイル名を表示可能にする
setopt print_eight_bit
## beep を無効にする
setopt no_beep
## Ctrl+Dでzshを終了しない
setopt ignore_eof
## '#' 以降をコメントとして扱う
setopt interactive_comments
## ディレクトリ名だけでcdする
setopt auto_cd
## cd したら自動的にpushdする
setopt auto_pushd
### 重複したディレクトリを追加しない
setopt pushd_ignore_dups
## 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
## ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
## 高機能なワイルドカード展開を使用する
setopt extended_glob
# ignore duplication command history list
setopt hist_ignore_dups

# ####################
# エイリアス
#
## ターミナル再起動
alias relogin='exec $SHELL -l'
## 便利コマンド
alias ls="ls -FG"
alias ll='ls -l'
alias la='ls -al'
alias la.='ls -al .??*'
alias mkdir='mkdir -p'
## やばいやつは確認する
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
## sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
## git
alias gc='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull origin HEAD'
alias gpl-r='git pull --rebase origin main'
alias gp='git push origin HEAD'
alias gcm='git commit -m'
alias gcm-e='git commit --allow-empty -m'
## docker
alias d='docker'
alias dc='docker compose' # sorry ex-dc...
alias rm_docker_images='docker images -qf dangling=true | xargs docker rmi'
alias rm_docker_containers='docker ps -aqf status=exited | xargs docker rm -v' # rm with volumes
alias rm_docker_volumes='docker volume ls -qf dangling=true | xargs docker volume rm'
alias rm_docker_compose_containers='docker-compose rm -fv'
## K8s でクラスタのご操作を防ぐラッパー（P山さん作）
alias kc='kubectl-cluster-caution'
## その他
alias be='bundle exec'
## OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# ####################
# fzf / 便利コマンド
#

## command histroy を検索
function fzf-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        fzf --reverse --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N fzf-select-history

# ####################
# asdf
#
. "$HOME/.asdf/asdf.sh"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# ####################
# プラグイン
#
# homebrew setup for M1 macOS
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # MacPorts
  export PATH="/opt/local/bin:$PATH"
  ## zsh-completions(補完機能)の設定
  if [ -e "$(brew --prefix)/share/zsh-completions" ]; then
    FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
  fi
fi

# fzf key-bindings (Ubuntu)
if [ -f "$HOME/.zsh/fzf-key-bindings.zsh" ]; then
  source "$HOME/.zsh/fzf-key-bindings.zsh"
fi

bindkey '^r' fzf-select-history

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yoshikouki/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yoshikouki/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yoshikouki/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yoshikouki/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/yoshikouki/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/yoshikouki/.bun/_bun" ] && source "/Users/yoshikouki/.bun/_bun"
export PATH="$HOME/.local/bin:$PATH"

source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script

. "$HOME/.turso/env"

# zoxide (cd replacement)
eval "$(zoxide init zsh --cmd cd)"
