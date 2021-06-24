# ####################
# Prezto の設定ファイルを読み込む
#
source "$HOME/.zprezto/init.zsh"
[ -f ~/.zshrc.local ] && source ~/.zshrc.local


# ####################
# 基本設定
#
## 色を使用出来るようにする
autoload -Uz colors
colors
## ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups     # ignore duplication command history list
## 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
### ここで指定した文字は単語区切りとみなされる
### / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
## zsh-completions(補完機能)の設定
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
autoload -U compinit
compinit -u
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                           /usr/sbin /usr/bin \
                                           /sbin /bin \
                                           /usr/X11R6/bin
## ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
## エディタをVimで固定
EDITOR=vim
VISUAL=vim
## viins (zsh の入力方式) のEmacs風拡張
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line
bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^Y'  yank


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
# setopt auto_cd
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


# ####################
# キーバインド
#
## Peco コマンドヒストリー
bindkey '^r' peco-select-history
## Peco Git リポジトリ
bindkey '^g' peco-src
## Peco ディレクトリヒストリー
bindkey '^x' peco-cdr
## Peco ブランチ切り替え
bindkey '^b' peco-branch
## Peco リポジトリアクセス
bindkey '^o' open-git-remote


# ####################
# エイリアス
#
## ターミナル再起動
alias relogin='exec $SHELL -l'
## K8s でクラスタのご操作を防ぐラッパー（P山さん作）
alias kc='kubectl-cluster-caution'
alias d='docker'
alias dc='docker compose' # sorry ex-dc...
alias rm_docker_images='docker images -qf dangling=true | xargs docker rmi'
alias rm_docker_containers='docker ps -aqf status=exited | xargs docker rm -v' # rm with volumes
alias rm_docker_volumes='docker volume ls -qf dangling=true | xargs docker volume rm'
alias rm_docker_compose_containers='docker-compose rm -fv'
## 便利コマンド
alias ll='ls -l'
alias la='ls -al'
alias la.='ls -al .??*'
alias be='bundle exec'
alias mkdir='mkdir -p'
## git
alias gc='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull origin HEAD'
alias gpl-r='git pull --rebase origin HEAD'
alias gp='git push origin HEAD'
## やばいやつは確認する
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
## sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
## C で標準出力をクリップボードにコピーする
## mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
# if which pbcopy >/dev/null 2>&1 ; then
#     # Mac
#     alias -g C='| tee>(pbcopy)'
# elif which xsel >/dev/null 2>&1 ; then
#     # Linux
#     alias -g C='| xsel --input --clipboard'
# elif which putclip >/dev/null 2>&1 ; then
#     # Cygwin
#     alias -g C='| putclip'
# fi
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
# peco
#
## git repository を検索
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
### bindkey '^g' peco-src

## command histroy を検索
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
### bindkey '^r' peco-select-history

## 移動したディレクトリ履歴から検索 search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}
## search a destination from cdr list and cd the destination
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
### bindkey '^x' peco-cdr

## ブランチ切り替え
function peco-branch() {

    # commiterdate:relativeを commiterdate:localに変更すると普通の時刻表示
    local selected_line="$(git for-each-ref --format='%(refname:short) | %(committerdate:relative) | %(committername) | %(subject)' --sort=-committerdate refs/heads refs/remotes \
        | column -t -s '|' \
        | grep -v 'origin' \
        | peco \
        | head -n 1 \
        | awk '{print $1}')"
    if [ -n "$selected_line" ]; then
        BUFFER="git checkout ${selected_line}"
        CURSOR=$#BUFFER
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-branch
# bindkey '^b' peco-branch

## リポジトリへのアクセス
function open-git-remote() {
  git rev-parse --git-dir >/dev/null 2>&1
  if [[ $? == 0 ]]; then
    git config --get remote.origin.url | sed -e 's#ssh://git@#https://#g' -e 's#git@#https://#g' -e 's#.com:#.com/#g' | xargs open
  else
    echo ".git not found.\n"
  fi
}
zle -N open-git-remote
# bindkey '^o' open-git-remote


# ####################
# anyenv
#
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
## Go
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
## pyenv
export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
## php
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export PATH="/usr/local/opt/bzip2/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/libiconv/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/libiconv/lib"
export CPPFLAGS="-I/usr/local/opt/libiconv/include"
export PATH="/usr/local/opt/krb5/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/krb5/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
## rbenv
eval export PATH="/Users/yoshikouki/.anyenv/envs/rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
source '/Users/yoshikouki/.anyenv/envs/rbenv/libexec/../completions/rbenv.zsh'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}


# ####################
# PostgreSQL
#
export PGDATA=/usr/local/var/postgres


# ####################
# MySQL Gem インストールエラーの対応
#
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"


# ####################
# iTerm2 の shell を統合
#
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/yoshikouki/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
