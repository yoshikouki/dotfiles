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

## 移動したディレクトリ履歴から検索 search a destination from cdr list
function fzf-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  fzf --reverse --query "$LBUFFER"
}
## search a destination from cdr list and cd the destination
function fzf-cdr() {
  local destination="$(fzf-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N fzf-cdr

## git repository を検索
function fzf-src () {
  local selected_dir=$(ghq list -p | fzf --reverse --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-src

## git branch 切り替え
function fzf-branch() {
    # commiterdate:relativeを commiterdate:localに変更すると普通の時刻表示
    local selected_line="$(git for-each-ref --format='%(refname:short) | %(committerdate:relative) | %(committername) | %(subject)' --sort=-committerdate refs/heads refs/remotes \
        | column -t -s '|' \
        | grep -v 'origin' \
        | fzf --reverse \
        | head -n 1 \
        | awk '{print $1}')"
    if [ -n "$selected_line" ]; then
        BUFFER="git checkout ${selected_line}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-branch

## git リポジトリへのアクセス
function open-git-remote() {
  git rev-parse --git-dir >/dev/null 2>&1
  if [[ $? == 0 ]]; then
    git config --get remote.origin.url | sed -e 's#ssh://git@#https://#g' -e 's#git@#https://#g' -e 's#.com:#.com/#g' | xargs open
  else
    echo ".git not found.\n"
  fi
}
zle -N open-git-remote

## Docker ログイン・ログ・削除
function fzf-docker-login() {
    local cid=$(docker ps | grep -v 'CONTAINER ID' | fzf --reverse --query "$LBUFFER" | cut -d ' ' -f1)
    if [ -n "$cid" ]; then
      BUFFER="docker exec -it $(echo $cid) /bin/bash"
      CURSOR=$#BUFFER
      zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-docker-login

function fzf-docker-log() {
    local cid=$(docker ps | grep -v 'CONTAINER ID' | fzf --reverse --query "$LBUFFER" | cut -d ' ' -f1)
    if [ -n "$cid" ]; then
      BUFFER="docker logs -f $(echo $cid)"
      CURSOR=$#BUFFER
      zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-docker-log

function fzf-docker-delete() {
    local cid=$(docker ps | grep -v 'CONTAINER ID' | fzf --reverse --query "$LBUFFER" | cut -d ' ' -f1)
    if [ -n "$cid" ]; then
      BUFFER="docker rm -f $(echo $cid)"
      CURSOR=$#BUFFER
      zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-docker-delete

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
bindkey '^x' fzf-cdr
bindkey '^g' fzf-src
bindkey '^b' fzf-branch
bindkey '^o' open-git-remote
bindkey '^te' fzf-docker-login
bindkey '^tl' fzf-docker-log
bindkey '^td' fzf-docker-delete

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
