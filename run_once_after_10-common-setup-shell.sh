#!/usr/bin/env bash
# Setup shell environment (cross-platform base)

set -euo pipefail

echo "🐚 Setting up shell..."

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    echo "✓ Default shell set to zsh"
else
    echo "✓ zsh is already the default shell"
fi

# Install Zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    echo "Installing Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    if git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
        echo "✓ Zinit installed"
    else
        echo "⚠ Failed to install Zinit"
        exit 1
    fi
else
    echo "✓ Zinit already installed"
fi

echo "✓ Shell setup complete"
