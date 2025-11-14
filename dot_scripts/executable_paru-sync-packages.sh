set -euo pipefail

echo "Installing packages via paru (AUR)..."

PACKAGE_LIST="$HOME/.config/packages-aur.txt"

if [ ! -f "$PACKAGE_LIST" ]; then
  echo "⚠ Package list not found: $PACKAGE_LIST"
  exit 1
fi

paru -S --needed - < "$PACKAGE_LIST"

echo "✓ AUR packages installed"
