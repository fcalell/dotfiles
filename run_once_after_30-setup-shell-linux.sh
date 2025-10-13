#!/usr/bin/env bash
# Setup Linux-specific shell services

set -e

# Enable systemd user services for Hyprland (if needed)
if command -v hyprland &>/dev/null; then
    echo "Enabling systemd user services..."
    systemctl --user enable --now pipewire.service
    systemctl --user enable --now pipewire-pulse.service
    systemctl --user enable --now wireplumber.service
    echo "✓ Systemd services enabled"
fi
