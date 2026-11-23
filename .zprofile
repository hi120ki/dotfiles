# Docker Desktop
if [ -d "$HOME/.docker/bin" ]; then
  export PATH="$PATH:$HOME/.docker/bin"
fi

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# local bin
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
