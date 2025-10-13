#!/usr/bin/env bash
# Install paru (AUR helper) and packages via pacman (Linux only)

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

# Install paru if not already present
if ! command -v paru &>/dev/null; then
    echo "🔧 Installing paru (AUR helper)..."

    # Clone and build paru
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm

    # Clean up
    cd ~
    rm -rf "$TEMP_DIR"

    echo "✓ paru installed successfully"
else
    echo "✓ paru already installed"
fi

# Install AUR packages with paru
if [ -f "$HOME/.config/packages-aur.txt" ]; then
    echo "📦 Installing AUR packages via paru..."
    paru -S --needed - < "$HOME/.config/packages-aur.txt"
    echo "✓ AUR packages installed"
else
    echo "⚠ packages-aur.txt not found"
fi

echo "✓ Package installation complete"
