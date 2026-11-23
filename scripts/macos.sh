#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "[error] This script is for macOS only."
  exit 1
fi

RESET_DOCK=false
if [[ "${1:-}" == "--reset-dock" ]]; then
  RESET_DOCK=true
fi

echo "[i] Dock Settings"
defaults write com.apple.dock springboard-columns -int 12
defaults write com.apple.dock tilesize -int 30
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 85
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock minimize-to-application -bool false
defaults write com.apple.dock launchanim -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool false
if [[ "$RESET_DOCK" == true ]]; then
  echo "[i] Clearing Dock persistent apps (--reset-dock)"
  defaults write com.apple.dock persistent-apps -array
fi

echo "[i] Hot Corners (Mission Control on all corners)"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

echo "[i] Window Manager Settings"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager GloballyEnabled -bool false

echo "[i] Finder Settings"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder AppleShowAllFiles -string "TRUE"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXPreferredSearchViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
chflags nohidden "$HOME/Library"

echo "[i] Trackpad & Mouse Settings"
# Tap to click (built-in & Bluetooth)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Secondary click: bottom-right corner only (disable two-finger right-click)
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool false

# Scroll direction (disable natural scroll) & disable swipe navigation
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false

# Tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.0
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.0

echo "[i] UI & Menu Bar Settings"
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false
defaults -currentHost write com.apple.controlcenter Sound -int 18
defaults -currentHost write com.apple.controlcenter Bluetooth -int 8
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool false
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool true

echo "[i] Activity Monitor Settings"
# Show CPU usage in Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

echo "[i] Hide terminal login message"
touch "$HOME/.hushlogin"

echo "[i] Restarting Finder & Dock"
killall Finder || true
killall Dock || true

echo "[done] macOS defaults applied. Some settings (e.g. trackpad/scroll) may require logging out and back in."
