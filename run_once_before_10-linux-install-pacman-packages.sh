#!/usr/bin/env bash
# Install paru (AUR helper) and packages via pacman (Linux only)

set -euo pipefail

echo "📦 Installing packages via pacman..."

# Update package database
sudo pacman -Sy

# Install official packages
if [ -f "$HOME/.config/packages.txt" ]; then
    # Filter out empty lines and comments, check if there are any packages
    PACKAGES=$(grep -v '^#' "$HOME/.config/packages.txt" | grep -v '^[[:space:]]*$' || true)
    if [ -n "$PACKAGES" ]; then
        echo "$PACKAGES" | sudo pacman -S --needed -
        echo "✓ Official packages installed"
    else
        echo "⚠ No packages to install in packages.txt"
    fi
else
    echo "⚠ packages.txt not found"
fi

# Install paru if not already present
if ! command -v paru &>/dev/null; then
    echo "🔧 Installing paru (AUR helper)..."

    # Clone and build paru
    TEMP_DIR=$(mktemp -d)

    if git clone https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"; then
        cd "$TEMP_DIR/paru"

        if makepkg -si --noconfirm; then
            echo "✓ paru installed successfully"
        else
            echo "⚠ Failed to build paru, skipping AUR packages"
            cd "$HOME"
            rm -rf "$TEMP_DIR"
            exit 0
        fi

        # Clean up
        cd "$HOME"
        rm -rf "$TEMP_DIR"
    else
        echo "⚠ Failed to clone paru repository, skipping AUR packages"
        rm -rf "$TEMP_DIR"
        exit 0
    fi
else
    echo "✓ paru already installed"
fi

# Install AUR packages with paru
if [ -f "$HOME/.config/packages-aur.txt" ]; then
    echo "📦 Installing AUR packages via paru..."
    # Filter out empty lines and comments, check if there are any packages
    AUR_PACKAGES=$(grep -v '^#' "$HOME/.config/packages-aur.txt" | grep -v '^[[:space:]]*$' || true)
    if [ -n "$AUR_PACKAGES" ]; then
        echo "$AUR_PACKAGES" | paru -S --needed -
        echo "✓ AUR packages installed"
    else
        echo "⚠ No AUR packages to install in packages-aur.txt"
    fi
else
    echo "⚠ packages-aur.txt not found"
fi

echo "✓ Package installation complete"
