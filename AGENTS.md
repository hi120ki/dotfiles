# AGENTS.md

Guidelines for AI agents working in this repository.

## Overview

This is a **public** macOS dotfiles repository (`hi120ki/dotfiles`). It manages shell/tool configuration files, a `Brewfile`, and reproducible macOS setup scripts.

## Repository Structure

- `setup.sh` — Interactive & CLI setup entrypoint
- `scripts/link.sh` — Symlinks dotfiles into `$HOME` (with backups and `--dry-run`)
- `scripts/macos.sh` — Applies macOS `defaults` settings (`--reset-dock` optional)
- `Brewfile` — Homebrew taps, formulae, and casks
- `.config/fish/` — `config.fish` and `fish_plugins` (Fisher)
- `.config/mise/config.toml` — Language runtimes and global CLI packages
- `.gitconfig`, `.gitignore_global` — Shared Git config (SSH signing via Secretive)
- `.zshrc`, `.zprofile`, `.zshenv` — Minimal Zsh configuration
- `.github/workflows/lint.yml` — CI lint workflow

## Public Repository & Security Rules

- **Never commit secrets or personal data**: no API keys, tokens, private keys, SSH host configs, personal email addresses (only GitHub noreply email is allowed in `.gitconfig`), internal/workplace branch names, VPN configs, or MDM/corporate apps.
- **No hardcoded user paths**: always use `$HOME` or `~` instead of `/Users/<username>`.
- **Keep machine-local Git signing settings out of git**: `user.signingkey` belongs in `~/.gitconfig.local` and public keys/emails belong in `~/.config/git/allowed_signers`.
- **Do not touch `$HOME` directly** unless explicitly requested by the user.

## Coding & Workflow Conventions

- **Shell scripts (`setup.sh`, `scripts/*.sh`)**:
  - Use `#!/usr/bin/env bash` and `set -euo pipefail`.
  - Must pass `shellcheck -S style` and `bash -n` with zero warnings.
  - Keep scripts idempotent and safe to re-run; guard destructive actions behind explicit flags or prompts.
- **Fish & Zsh configs**:
  - Guard optional tools and sockets (`if command -sq ...`, `if test -d ...`, `if test -S ...`).
  - Must pass `fish -n` and `zsh -n`.
- **GitHub Actions (`.github/workflows/*.yml`)**:
  - **Always pin actions to full commit SHAs with a version comment** (e.g., `uses: actions/checkout@<40-char-sha> # vX.Y.Z`), matching `pinact` format.
  - Specify minimal `permissions` (e.g., `contents: read`).

## Verification

Before finishing changes, run:

```bash
shellcheck -S style setup.sh scripts/*.sh
bash -n setup.sh scripts/*.sh
fish -n .config/fish/config.fish
zsh -n .zshrc .zprofile .zshenv
./scripts/link.sh --dry-run
```
