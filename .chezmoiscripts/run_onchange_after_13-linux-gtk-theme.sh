#!/usr/bin/env bash
# Configure GTK theme settings via gsettings

set -euo pipefail

# Only run on Linux systems with gsettings available
if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v gsettings &>/dev/null; then
    echo "Configuring GTK theme..."
    gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    echo "✓ GTK theme configured"
else
    echo "⚠ Skipping GTK theme configuration (not Linux or gsettings not found)"
fi
