#!/bin/zsh

if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"
	exit 1
fi

# キーリピートの高速化
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# マウスの速度を速める
defaults write -g com.apple.trackpad.scaling 3
defaults write -g com.apple.mouse.scaling 5

## 三本指でドラッグ
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# スクロールバーの常時表示
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# 自動大文字の無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# クラッシュレポートの無効化
defaults write com.apple.CrashReporter DialogType -string "none"

# 時計アイコンクリック時にOSやホスト名ipを表示する
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

## ウィンドウサイズを調整する際の加速再生
defaults write -g NSWindowResizeTime -float 0.001

# ターミナルでUTF-8のみを使用する
defaults write com.apple.terminal StringEncodings -array 4

# ターミナル終了時のプロンプトを非表示にする
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

## DNSを指定してネットが早くなってほしい。IPv4とIPv6
networksetup -setdnsservers Wi-Fi 8.8.4.4 8.8.8.8 2001:4860:4860::8844 2001:4860:4860::8888

# Dock ======================================================

# すべての（デフォルトの）アプリアイコンをDockから消去する
defaults write com.apple.dock persistent-apps -array

# Finder ======================================================

# デフォルトで隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles -bool true

# 全ての拡張子のファイルを表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

## Finder のタイトルバーにフルパスを表示する
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true    

# 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 検索時にデフォルトでカレントディレクトリを検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# USBやネットワークストレージに.DS_Storeファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ボリュームマウント時に自動的にFinderを表示
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Safari ======================================================

# Enable the `Develop`, `Debug` menu and the `Web Inspector`
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# アドレスバーに表示されるURLを全表示
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# AppStore ======================================================

# WebKitデベロッパーツールを有効にする
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# デバッグメニューを有効にする
defaults write com.apple.appstore ShowDebugMenu -bool true

# 自動更新チェックを有効にする
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# 毎日アプリケーションのアップデートを確認する
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# アプリケーションのアップデートをバックグラウンドでダウンロードする
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# システムデータファイルとセキュリティ更新プログラムをインストールする
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# 他のMacで購入したアプリを自動的にダウンロードする
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# アプリケーションの自動更新を有効化
defaults write com.apple.commerce AutoUpdate -bool true

# 再起動が必要なアプリケーションの場合自動で再起動を有効化する
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# 再起動

for app in \
    "Dock" \
	"Finder" \
	"Google Chrome" \
	"Safari" \
	"SystemUIServer" \
	"Terminal" \
    ; do
	killall "${app}" &> /dev/null
done
