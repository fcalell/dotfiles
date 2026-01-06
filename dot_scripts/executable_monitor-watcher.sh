socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    if echo "$line" | grep -q "monitoradded\|monitorremoved"; then
        sleep 1
        if hyprctl monitors | grep -q "HDMI-A-1"; then
            # External monitor connected - disable laptop screen
            hyprctl keyword monitor "DP-2,disable"
            hyprctl keyword monitor "HDMI-A-1,preferred,auto,1"
        else
            # No external monitor - enable laptop screen
            hyprctl keyword monitor "DP-2,preferred,auto,1"
        fi
    fi
done
