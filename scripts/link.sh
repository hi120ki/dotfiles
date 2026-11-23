#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

link_file() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "[warn] source not found, skipping: $src"
    return 0
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "[ok] already linked: $dst -> $src"
    return 0
  fi

  if [[ "$DRY_RUN" == true ]]; then
    echo "[dry-run] link: $dst -> $src"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup
    backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    echo "[backup] moving existing $dst -> $backup"
    mv "$dst" "$backup"
  fi

  ln -s "$src" "$dst"
  echo "[link] $dst -> $src"
}

# Shell & Git
link_file "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$REPO_DIR/.gitignore_global" "$HOME/.gitignore_global"
link_file "$REPO_DIR/.zshrc" "$HOME/.zshrc"
link_file "$REPO_DIR/.zprofile" "$HOME/.zprofile"
link_file "$REPO_DIR/.zshenv" "$HOME/.zshenv"

# XDG config (~/.config)
link_file "$REPO_DIR/.config/fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "$REPO_DIR/.config/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
link_file "$REPO_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

echo "[done] dotfiles symlink setup complete."
