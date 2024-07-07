{
  imports = [ ./style.nix ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 35;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [ ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "pulseaudio" "clock" ];
        clock = {
          format = "󰥔  {:%a, %d %b, %I:%M %p}";
          tooltip = "true";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = "   {:%d/%m}";
        };
        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "α";
            "2" = "β";
            "3" = "γ";
            "4" = "δ";
            urgent = "";
            active = "";
            default = "";
            sort-by-number = true;
          };
        };
        memory = {
          format = "󰍛 {}%";
          format-alt = "󰍛 {used}/{total} GiB";
          interval = 5;
        };
        cpu = {
          format = "󰻠 {usage}%";
          format-alt = "󰻠 {avg_frequency} GHz";
          interval = 5;
        };
        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀 100% ";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 0% ";
        };
        tray = {
          icon-size = 20;
          spacing = 8;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
          scroll-step = 5;
          on-click = "pavucontrol";
        };
      };
    };
  };
}
