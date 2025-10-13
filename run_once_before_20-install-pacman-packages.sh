#!/usr/bin/env bash
# Install packages via pacman (Linux only)

set -e

echo "📦 Installing packages via pacman..."

# Update package database
sudo pacman -Sy

# Install official packages
if [ -f "$HOME/.config/packages.txt" ]; then
    sudo pacman -S --needed - < "$HOME/.config/packages.txt"
    echo "✓ Official packages installed"
else
    echo "⚠ packages.txt not found"
fi

# Install AUR packages with paru
if command -v paru &>/dev/null; then
    if [ -f "$HOME/.config/packages-aur.txt" ]; then
        echo "📦 Installing AUR packages via paru..."
        paru -S --needed - < "$HOME/.config/packages-aur.txt"
        echo "✓ AUR packages installed"
    else
        echo "⚠ packages-aur.txt not found"
    fi
else
    echo "⚠ paru not found, skipping AUR packages"
fi

echo "✓ Package installation complete"
