#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step_xcode() {
  echo "[i] Installing Xcode Command Line Tools..."
  xcode-select --install || true
}

step_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "[i] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  echo "[i] Running brew bundle..."
  brew bundle --file="$REPO_DIR/Brewfile"
}

step_link() {
  bash "$REPO_DIR/scripts/link.sh"
}

step_macos() {
  read -r -p "Also clear Dock persistent apps? (y/N): " reset_dock
  if [[ "$reset_dock" =~ ^[Yy]$ ]]; then
    bash "$REPO_DIR/scripts/macos.sh" --reset-dock
  else
    bash "$REPO_DIR/scripts/macos.sh"
  fi
}

step_fish() {
  local fish_bin
  fish_bin="$(command -v fish || echo /opt/homebrew/bin/fish)"
  if [[ ! -x "$fish_bin" ]]; then
    echo "[error] fish not found. Run step 2 (Homebrew) first."
    return 1
  fi

  if ! grep -qx "$fish_bin" /etc/shells; then
    echo "[i] Adding $fish_bin to /etc/shells..."
    echo "$fish_bin" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$SHELL" != "$fish_bin" ]]; then
    echo "[i] Changing default shell to $fish_bin..."
    chsh -s "$fish_bin"
  fi

  echo "[i] Installing Fisher & syncing plugins from fish_plugins..."
  "$fish_bin" -c '
    if not functions -q fisher
      curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
      fisher install jorgebucaran/fisher
    end
    fisher update
  '
}

step_tools() {
  if [[ ! -d "$HOME/.cargo" ]]; then
    echo "[i] Installing rustup..."
    curl -fsSL https://sh.rustup.rs | sh -s -- -y
  fi

  if [[ ! -x "$HOME/.local/bin/mise" ]]; then
    echo "[i] Installing mise..."
    curl -fsSL https://mise.jdx.dev/install.sh | sh
  fi
  echo "[i] Installing runtimes & tools via mise..."
  "$HOME/.local/bin/mise" install
}

step_manual_checklist() {
  cat <<'EOF'

=== Manual Setup Checklist ===
1. Secretive (SSH keys & Git commit signing):
   - Launch Secretive and create a Secure Enclave key.
   - Register the public key on GitHub as both an Authentication Key and a Signing Key.
   - Create ~/.gitconfig.local:
       [user]
           signingkey = ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/<KEY_ID>.pub
   - Create ~/.config/git/allowed_signers:
       <email> <public-key-type> <public-key-data>

2. Keyboard & IME:
   - System Settings -> Keyboard -> Keyboard Shortcuts -> Modifier Keys -> Caps Lock to Control
   - Configure Google Japanese Input

3. iTerm2:
   - Appearance -> General -> Theme: Minimal
   - Appearance -> Dimming: 10
   - Set Nerd Font (SauceCodePro Nerd Font) and import profile if needed

4. GitHub CLI, VS Code & Cloud CLIs:
   - gh auth login
   - VS Code: Sign in with GitHub to enable Settings Sync
   - gcloud init (as needed)
EOF
}

step_reset_launchpad() {
  defaults write com.apple.dock ResetLaunchPad -bool true
  killall Dock || true
}

show_menu() {
  echo "=== macOS dotfiles setup ==="
  echo "1. Install Xcode Command Line Tools"
  echo "2. Install Homebrew & packages (Brewfile)"
  echo "3. Symlink dotfiles (scripts/link.sh)"
  echo "4. Apply macOS defaults (scripts/macos.sh)"
  echo "5. Setup fish shell & Fisher plugins"
  echo "6. Install runtimes & tools (rustup, mise)"
  echo "7. Show manual setup checklist (Secretive, Keyboard, iTerm2)"
  echo "8. Reset Launchpad"
  echo "q. Quit"
}

run_choice() {
  case "$1" in
    1|xcode) step_xcode ;;
    2|brew) step_homebrew ;;
    3|link) step_link ;;
    4|macos) step_macos ;;
    5|fish) step_fish ;;
    6|tools) step_tools ;;
    7|checklist) step_manual_checklist ;;
    8|launchpad) step_reset_launchpad ;;
    q|Q) exit 0 ;;
    *) echo "Invalid choice: $1"; exit 1 ;;
  esac
}

if [[ $# -gt 0 ]]; then
  for arg in "$@"; do
    run_choice "$arg"
  done
else
  show_menu
  read -r -p "Please choose (1-8, q): " choice
  run_choice "$choice"
fi
