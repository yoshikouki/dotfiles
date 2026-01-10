# ~/.local/bin スクリプト用 wrapper 関数 (fish)
# cd を必要とするスクリプトをシェル関数として提供

# g - ghq リポジトリに cd
function g
    set -l dir (~/.local/bin/g)
    if test -n "$dir"
        cd "$dir"
    end
end

# y - yazi で cd
function y
    set -l dir (~/.local/bin/y $argv)
    if test -n "$dir"
        cd "$dir"
    end
end
