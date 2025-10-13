#!/usr/bin/env bash
# Install mise-managed tools (Node.js, pnpm, uv, etc.)

set -e

echo "📦 Installing mise tools..."

# Check if mise is available
if ! command -v mise &>/dev/null; then
    echo "⚠ mise not found, skipping tool installation"
    exit 0
fi

# Install global tools defined in mise config
mise install

echo "✅ Mise tools installed!"
echo ""
echo "Installed versions:"
mise list
