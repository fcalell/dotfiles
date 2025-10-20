#!/usr/bin/env bash
# Install packages via Homebrew (macOS only)

set -euo pipefail

echo "🍺 Installing packages via Homebrew..."

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install packages from Brewfile
if [ -f "$HOME/.config/Brewfile" ]; then
    brew bundle --file="$HOME/.config/Brewfile"
    echo "✓ Homebrew packages installed"
else
    echo "⚠ Brewfile not found at ~/.config/Brewfile"
fi

echo "✓ Package installation complete"
