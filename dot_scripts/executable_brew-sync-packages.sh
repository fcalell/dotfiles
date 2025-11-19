set -euo pipefail

echo "Installing packages via Homebrew..."
PACKAGE_LIST="$HOME/.config/packages-homebrew.txt"

if [ ! -f "$PACKAGE_LIST" ]; then
  echo "⚠ Package list not found: $PACKAGE_LIST"
  exit 1
fi

# Install packages using brew bundle
brew bundle --file="$PACKAGE_LIST"

echo "✓ Homebrew packages installed"
