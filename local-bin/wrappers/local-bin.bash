# ~/.local/bin スクリプト用 wrapper 関数 (bash)
# cd を必要とするスクリプトをシェル関数として提供

# g - ghq リポジトリに cd
g() {
    local dir
    dir=$(~/.local/bin/g)
    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}

# y - yazi で cd
y() {
    local dir
    dir=$(~/.local/bin/y "$@")
    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}
