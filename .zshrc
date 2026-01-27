# ==============================================================================
# Zsh Configuration
# ==============================================================================
# このファイルはインタラクティブシェルの起動時に読み込まれる
# 設定は以下の順序で構成されている：
#   1. 環境変数・基本設定
#   2. Zsh コア設定（補完・色・単語区切り）
#   3. ヒストリ設定
#   4. オプション設定
#   5. エイリアス
#   6. 関数
#   7. キーバインド
#   8. 外部ツール（バージョン管理・パッケージマネージャー）
#   9. サービス連携・その他
# ==============================================================================


# ==============================================================================
# 1. 環境変数・基本設定
# ==============================================================================
# システム全体で使用される基本的な環境変数を設定
# 注: 環境変数の設定は .zshenv で行われます


# ==============================================================================
# 2. Zsh コア設定
# ==============================================================================
# Zsh の基本機能を有効化

# 補完システムの初期化（-u: 安全でないディレクトリの警告を抑制）
autoload -Uz compinit && compinit -u

# プロンプトなどで色を使用可能にする
autoload -Uz colors && colors

# プロンプト設定（tide スタイル 2行）
# 1行目: ユーザー@ホスト パス (gitブランチ)
# 2行目: プロンプト記号
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST

PROMPT='
%F{cyan}%m%f %F{blue}%~%f %F{yellow}${vcs_info_msg_0_}%f
%F{magenta}$%f '

# 単語区切りスタイルの設定
# select-word-style: Ctrl+W などで単語単位の操作を行う際の区切り方を制御
autoload -Uz select-word-style && select-word-style default
# 以下の文字を単語の区切りとして扱う（/ を含めることで Ctrl+W でパス1階層分削除可能）
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified


# ==============================================================================
# 3. 補完設定
# ==============================================================================
# タブ補完の動作をカスタマイズ

# 小文字入力で大文字にもマッチ（case-insensitive）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# sudo の後でもコマンド補完を有効に
zstyle ':completion:*:sudo:*' command-path \
  /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin \
  /sbin /bin \
  /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


# ==============================================================================
# 4. ヒストリ設定
# ==============================================================================
# コマンド履歴の保存と検索の設定

HISTFILE=~/.zsh_history
HISTSIZE=1000000          # メモリ上に保持する履歴数
SAVEHIST=1000000          # ファイルに保存する履歴数


# ==============================================================================
# 5. オプション設定 (setopt)
# ==============================================================================
# Zsh の動作をカスタマイズする各種オプション

# --- 表示・入出力 ---
setopt print_eight_bit    # 日本語ファイル名を正しく表示
setopt no_beep            # ビープ音を無効化
setopt ignore_eof         # Ctrl+D でシェルを終了しない

# --- コマンドライン編集 ---
setopt interactive_comments  # '#' 以降をコメントとして扱う（コマンドラインでも）
setopt extended_glob         # 拡張グロブ（**/, (#i) など）を有効化

# --- ディレクトリ移動 ---
setopt auto_cd            # ディレクトリ名だけで cd
setopt auto_pushd         # cd 時に自動で pushd（cd - で戻れる）
setopt pushd_ignore_dups  # pushd で重複を追加しない

# --- ヒストリ ---
setopt hist_ignore_dups       # 直前と同じコマンドは履歴に追加しない
setopt hist_ignore_all_dups   # 重複するコマンドは古い方を削除
setopt hist_reduce_blanks     # 余分な空白を削除して保存


# ==============================================================================
# 6. エイリアス
# ==============================================================================
# よく使うコマンドの短縮形

# --- シェル操作 ---
alias relogin='exec $SHELL -l'  # 設定を再読み込み

# --- ファイル操作（基本） ---
alias ls='eza'            # モダンな ls 代替（eza）
alias ll='eza -l'         # 詳細表示
alias la='eza -la'        # 隠しファイル含む詳細表示
alias lt='eza -T'         # ツリー表示
alias mkdir='mkdir -p'    # 親ディレクトリも作成

# --- ファイル表示 ---
alias cat='bat --paging=never'  # シンタックスハイライト付き cat

# --- 安全対策（確認プロンプト） ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- sudo でエイリアスを有効化 ---
# sudo の後にスペースを入れることで、続くコマンドもエイリアス展開される
alias sudo='sudo '

# --- Git ---
alias gc='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull origin HEAD'
alias gpl-r='git pull --rebase origin main'
alias gp='git push origin HEAD'
alias gcm='git commit -m'
alias gcm-e='git commit --allow-empty -m'

# --- Docker ---
alias d='docker'
alias dc='docker compose'
alias rm_docker_images='docker images -qf dangling=true | xargs docker rmi'
alias rm_docker_containers='docker ps -aqf status=exited | xargs docker rm -v'
alias rm_docker_volumes='docker volume ls -qf dangling=true | xargs docker volume rm'
alias rm_docker_compose_containers='docker-compose rm -fv'

# --- Kubernetes ---
# クラスタ誤操作防止ラッパー
alias kc='kubectl-cluster-caution'

# --- Package Management ---
alias pkg-update='brew update && brew upgrade && mise upgrade'

# --- その他 ---
alias be='bundle exec'

# --- OS 別設定 ---
case ${OSTYPE} in
  darwin*)
    # macOS
    export CLICOLOR=1
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    ;;
  linux*)
    # Linux (no additional settings needed with eza)
    ;;
esac


# ==============================================================================
# 7. 関数
# ==============================================================================
# カスタム関数の定義

# fzf を使ったコマンド履歴検索
# Ctrl+R で起動し、インクリメンタルに履歴を検索
function fzf-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"  # macOS には tac がないので tail -r で代用
  fi
  BUFFER=$(\history -n 1 | \
    eval $tac | \
    fzf --reverse --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N fzf-select-history

# ghq リポジトリ検索・移動
# fzf で ghq 管理下のリポジトリを選択し、そのディレクトリに移動
function g() {
  local repo=$(ghq list | fzf --reverse +m)
  if [ -n "$repo" ]; then
    cd "$(ghq root)/$repo"
  fi
}

# git ブランチ検索・切り替え
# fzf でローカルブランチを選択し、git switch で切り替え
function b() {
  local branch=$(git branch --sort=-committerdate | fzf --reverse)
  if [ -n "$branch" ]; then
    git switch "$(echo "$branch" | sed 's/^[ *]*//')"
  fi
}

# git ブランチ作成
# 引数またはプロンプトでブランチ名を入力し、新しいブランチを作成して切り替え
function c() {
  local branch_name
  if [ $# -eq 0 ]; then
    printf "branch name: "
    read branch_name
  else
    branch_name="$1"
  fi

  if [ -n "$branch_name" ]; then
    git switch -c "$branch_name"
  else
    echo "Branch name is required."
    return 1
  fi
}

# yazi ファイルマネージャー
# 終了後に選択したディレクトリに cd
function y() {
  local tmp=$(mktemp -t "yazi-cwd.XXXXXX")
  local target="${1:-.}"
  yazi "$target" --cwd-file="$tmp"
  local cwd=$(cat "$tmp")
  rm -f "$tmp"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd"
  fi
}


# ==============================================================================
# 8. キーバインド
# ==============================================================================
# カスタムキーバインドの設定

# Ctrl+R: fzf による履歴検索
bindkey '^r' fzf-select-history


# ==============================================================================
# 9. 外部ツール - バージョン管理
# ==============================================================================

# --- mise (runtime version manager) ---
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi


# ==============================================================================
# 9.5. WSL2 NVIDIA GPU
# ==============================================================================
# WSL2環境でNVIDIA GPUを使用する場合のライブラリパス

if grep -qi microsoft /proc/version 2>/dev/null; then
  export PATH="/usr/lib/wsl/lib:$PATH"
fi


# ==============================================================================
# 10. 外部ツール - パッケージマネージャー
# ==============================================================================

# --- Homebrew ---
# CLI tools and GUI applications are managed by Homebrew
# macOS: /opt/homebrew
# Linux: /home/linuxbrew/.linuxbrew

# macOS (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # MacPorts との共存
  export PATH="/opt/local/bin:$PATH"
fi

# Linuxbrew
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- fzf キーバインド (Ubuntu) ---
# Ubuntu では fzf のキーバインドを別ファイルから読み込む
if [ -f "$HOME/.zsh/fzf-key-bindings.zsh" ]; then
  source "$HOME/.zsh/fzf-key-bindings.zsh"
fi


# ==============================================================================
# 11. サービス連携・その他
# ==============================================================================
# 各種クラウドサービスやツールとの連携設定

# --- Google Cloud SDK ---
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# --- Turso (SQLite エッジデータベース) ---
if [ -f "$HOME/.turso/env" ]; then
  . "$HOME/.turso/env"
fi

# --- Safe-chain ---
if [ -f "$HOME/.safe-chain/scripts/init-posix.sh" ]; then
  source "$HOME/.safe-chain/scripts/init-posix.sh"
fi

# --- zoxide (スマート cd) ---
# cd コマンドを zoxide で置き換え、よく使うディレクトリに素早く移動
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
