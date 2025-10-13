#!/usr/bin/env bash
# Setup lazygit config symlink (macOS only)
# macOS lazygit looks in ~/Library/Application Support/lazygit
# but we want to use the XDG location ~/.config/lazygit

set -e
LAZYGIT_APP_SUPPORT="$HOME/Library/Application Support/lazygit"
LAZYGIT_CONFIG="$HOME/.config/lazygit"

# Create the Application Support directory if it doesn't exist
mkdir -p "$LAZYGIT_APP_SUPPORT"

# Remove existing config.yml if it's a regular file (not a symlink)
if [ -f "$LAZYGIT_APP_SUPPORT/config.yml" ] && [ ! -L "$LAZYGIT_APP_SUPPORT/config.yml" ]; then
    echo "Backing up existing lazygit config..."
    mv "$LAZYGIT_APP_SUPPORT/config.yml" "$LAZYGIT_APP_SUPPORT/config.yml.backup"
fi

# Create symlink
if [ ! -L "$LAZYGIT_APP_SUPPORT/config.yml" ]; then
    echo "🔗 Creating symlink for lazygit config..."
    ln -sf "$LAZYGIT_CONFIG/config.yml" "$LAZYGIT_APP_SUPPORT/config.yml"
    echo "✅ Lazygit config symlinked to ~/.config/lazygit/config.yml"
else
    echo "✅ Lazygit config symlink already exists"
fi

echo "✅ Lazygit setup complete"
