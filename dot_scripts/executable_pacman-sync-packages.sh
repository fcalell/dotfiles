set -euo pipefail

echo "Installing packages via pacman..."

PACKAGE_LIST="$HOME/.config/packages-pacman.txt"

if [ ! -f "$PACKAGE_LIST" ]; then
  echo "⚠ Package list not found: $PACKAGE_LIST"
  exit 1
fi

# Update package database and system (avoid partial upgrades)
sudo pacman -Syu --noconfirm

sudo pacman -S --needed - < "$PACKAGE_LIST"

echo "✓ Pacman packages installed"
