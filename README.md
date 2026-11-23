# dotfiles

macOS development environment configuration files and setup scripts.

## Structure

- `setup.sh` — Interactive setup entrypoint
- `scripts/link.sh` — Create symlinks from this repository into `$HOME` (backs up existing files; supports `--dry-run`)
- `scripts/macos.sh` — Apply macOS `defaults` settings (pass `--reset-dock` to also clear Dock pinned apps)
- `Brewfile` — Homebrew taps, formulae, and casks
- `.config/fish/` — Fish shell config (`config.fish`) and Fisher plugin list (`fish_plugins`)
- `.config/mise/config.toml` — Language runtimes & CLI tools managed by `mise`
- `.gitconfig` / `.gitignore_global` — Shared Git settings (machine-specific keys go in `~/.gitconfig.local`)
- `.zshrc` / `.zprofile` / `.zshenv` — Minimal Zsh setup

## Usage

```bash
git clone https://github.com/hi120ki/dotfiles.git ~/src/github.com/hi120ki/dotfiles
cd ~/src/github.com/hi120ki/dotfiles

# Interactive menu
./setup.sh

# Or run specific steps directly
./setup.sh link
./setup.sh brew fish tools

# Preview symlinks without modifying files
./scripts/link.sh --dry-run
```

## Secretive (SSH Commit Signing)

This repository configures Git to sign commits and tags with SSH (`gpg.format = ssh`) via [Secretive](https://github.com/maxgoedjen/secretive). Because each Mac's Secure Enclave generates a unique key, keep machine-specific signing settings outside this repository:

1. Create a key in **Secretive** and add its public key to GitHub (both **Authentication Key** and **Signing Key**).
2. Create `~/.gitconfig.local`:
   ```ini
   [user]
       signingkey = ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/<KEY_ID>.pub
   ```
3. Create `~/.config/git/allowed_signers` for local signature verification (`git log --show-signature`):
   ```text
   <your-email> <key-type> <public-key>
   ```
