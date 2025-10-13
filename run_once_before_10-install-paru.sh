#!/usr/bin/env bash
# Install paru (AUR helper) on Arch Linux

set -e

echo "🔧 Installing paru (AUR helper)..."

# Check if paru is already installed
if command -v paru &>/dev/null; then
    echo "✓ paru already installed"
    exit 0
fi

# Install dependencies
sudo pacman -S --needed --noconfirm base-devel git

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
