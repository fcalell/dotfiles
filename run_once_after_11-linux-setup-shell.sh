#!/usr/bin/env bash
# Setup Linux-specific shell services

set -euo pipefail

# Enable systemd user services for Hyprland (if needed)
if command -v hyprland &>/dev/null; then
    echo "Enabling systemd user services..."
    systemctl --user enable --now pipewire.service || echo "⚠ Failed to enable pipewire.service"
    systemctl --user enable --now pipewire-pulse.service || echo "⚠ Failed to enable pipewire-pulse.service"
    systemctl --user enable --now wireplumber.service || echo "⚠ Failed to enable wireplumber.service"
    echo "✓ Systemd services setup complete"
fi
