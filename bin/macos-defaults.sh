#!/bin/zsh
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
	echo "Not macOS!"
	exit 1
fi

# Keyboard ===================================================

# キーリピートの高速化
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Caps Lock を Control として扱う
hidutil property --set '{
  "UserKeyMapping": [
    {
      "HIDKeyboardModifierMappingSrc": 0x700000039,
      "HIDKeyboardModifierMappingDst": 0x7000000E0
    }
  ]
}'

# Spotlight / Raycast ========================================

# Keyboard shortcuts =========================================

hotkeys_plist="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:nabled" "$hotkeys_plist" 2>/dev/null || true

disable_symbolic_hotkey() {
	local key_id="$1"
	local value

	value="$(defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys 2>/dev/null | awk -v id="$key_id" '
		$1 == id {
			in_key = 1
		}
		in_key && /value =/ {
			in_value = 1
		}
		in_value {
			print
		}
		in_value && /^[[:space:]]*};/ {
			exit
		}
	')"

	if [ -n "$value" ]; then
		defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$key_id" "{ enabled = 0; $value }"
	else
		defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$key_id" "{ enabled = 0; }"
	fi
}

# 以下のキーボードショートカットをオフにする
# 52: Dockを自動的に表示/非表示のオン・オフ
# 32, 34: Mission Control
# 33, 35: アプリケーションウィンドウ
# 79-82: コンテクストメニュー
# 60: 前の入力ソースを選択
# 61: 入力メニューの次ソースを選択
# 64: Spotlight検索を表示
# 65: Finderの検索ウィンドウを表示
for key_id in 52 32 34 33 35 79 80 81 82 60 61 64 65; do
	disable_symbolic_hotkey "$key_id"
done

# F1, F2などのキーを標準ファンクションキーとして使用
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Trackpad / Mouse ===========================================

# トラックパッド速度、マウス速度
defaults write -g com.apple.trackpad.scaling -float 3
defaults write -g com.apple.mouse.scaling -float 5

# 三本指ドラッグ
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# ナチュラルスクロール、タップでクリック、右クリック
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write NSGlobalDomain ContextMenuGesture -int 1

# Dock =======================================================

# Dock の中身を全消し
defaults write com.apple.dock persistent-apps -array

# Dock を自動的に隠す、サイズ調整、最近使ったアプリ非表示
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock show-recents -bool false

# Finder =====================================================

# 隠しファイル表示、拡張子表示、パスバー/ステータスバー表示
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder の検索をカレントディレクトリ優先にする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# USB やネットワークストレージに .DS_Store を作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Apply ======================================================

for app in \
	"Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &>/dev/null || true
done

killall cfprefsd &>/dev/null || true

echo "macOS defaults applied. Some keyboard and trackpad settings may require logout or reboot."
