# ####################
# Prezto の設定ファイルを読み込む
#
source "$HOME/.zprezto/init.zsh"


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
## スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
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


# ####################
# エイリアス
#
## ターミナル再起動
alias relogin='exec $SHELL -l'
## K8s でクラスタのご操作を防ぐラッパー（P山さん作）
alias kc='kubectl-cluster-caution'
## 便利コマンド
alias ll='ls -l'
alias la='ls -al'
alias la.='ls -al .??*'
alias be='bundle exec'
alias mkdir='mkdir -p'
## やばいやつは確認する
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
## sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
## C で標準出力をクリップボードにコピーする
## mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi
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

# ####################
# Go
#
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# ####################
# anyenv
#
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

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

# ####################
# 2020-10-18 Prezto 導入に伴いコメントアウト
# # プロンプト表示設定
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' formats '[%b]'
# zstyle ':vcs_info:*' actionformats '[%b|%a]'
# precmd () {
#   # 1行あける
#   print
#   # カレントディレクトリ
#   local left=' %{\e[38;5;2m%}(%~)%{\e[m%}'
#   # バージョン管理されてた場合、ブランチ名
#   vcs_info
#   local right="%{\e[38;5;32m%}${vcs_info_msg_0_}%{\e[m%}"
#   # スペースの長さを計算
#   # テキストを装飾する場合、エスケープシーケンスをカウントしないようにします
#   local invisible='%([BSUbfksu]|([FK]|){*})'
#   local leftwidth=${#${(S%%)left//$~invisible/}}
#   local rightwidth=${#${(S%%)right//$~invisible/}}
#   local padwidth=$(($COLUMNS - ($leftwidth + $rightwidth) % $COLUMNS))

#   print -P $left${(r:$padwidth:: :)}$right
# }
# ## ユーザ名@ホスト名
# PROMPT='> '
# # PROMPT='%n %# '
# # 現在時刻
# # RPROMPT=$'%{\e[38;5;251m%}%D{%b %d}, %*%{\e[m%}'
# # TMOUT=1
# # TRAPALRM() {
# #   zle reset-prompt
# # }
##### ここまでプロンプト表示設定 #####
