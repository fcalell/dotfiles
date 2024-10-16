{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    exec-once = [
      # "systemctl --user import-environment &"
      # "hash dbus-update-activation-environment 2>/dev/null &"
      # "dbus-update-activation-environment --systemd &"
      # "nm-applet &"
      "wl-paste --primary --watch wl-copy --primary --clear"
      "wpaperd &"
      # "swaybg -m fill -i ~/nixos/modules/common/home/stylix/wallpapers/feet-on-the-dashboard.png &"
      # "sleep 1 && swaylock"
      # "hyprctl setcursor Catppuccin-Mocha-Dark-Cursors 24"
      "waybar &"
      # "mako &"
      # "easyeffects --gapplication-service" # Starts easyeffects in the background
    ];
    general = {
      gaps_in = 3;
      gaps_out = 5;
      border_size = 3;
      "col.active_border" = "$accent";
      # "col.inactive_border" = "${tokyonight_background}";
      layout = "master";
      no_focus_fallback = true;
    };
    decoration = {
      rounding = 12;
      shadow_ignore_window = true;
      drop_shadow = false;
      blur = { enabled = false; };
    };
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 0;
      mouse_refocus = false;
      numlock_by_default = true;
      accel_profile = "flat";
      sensitivity = 0;
      touchpad = { natural_scroll = 1; };
    };
    animations = {
      enabled = false;
      bezier = [
        "pace,0.46, 1, 0.29, 0.99"
        "overshot,0.13,0.99,0.29,1.1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
      ];
      animation = [
        "windowsIn,1,6,md3_decel,slide"
        "windowsOut,1,6,md3_decel,slide"
        "windowsMove,1,6,md3_decel,slide"
        "fade,1,10,md3_decel"
        "workspaces,1,9,md3_decel,slide"
        "workspaces, 1, 6, default"
        "specialWorkspace,1,8,md3_decel,slide"
        "border,1,10,md3_decel"
      ];
    };

    misc = {
      vfr =
        true; # misc:no_vfr -> misc:vfr. bool, heavily recommended to leave at default on. Saves on CPU usage.
      vrr =
        0; # misc:vrr -> Adaptive sync of your monitor. 0 (off), 1 (on), 2 (fullscreen only). Default 0 to avoid white flashes on select hardware.
      middle_click_paste = false;
      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
    };

    master = { mfact = 0.5; };

    bind = [
      "SUPER,Q,killactive,"
      "ALT, Tab, cyclenext,"
      ''SUPER,P,exec, grim -g "$(slurp)" - | wl-copy -t image/png''

      # "SUPER,M,exit,"
      # "SUPER,S,togglefloating,"
      # "SUPER,g,togglegroup"
      # "SUPER,tab,changegroupactive"
      # "SUPER,P,pseudo,"

      # Vim binds
      "SUPER,h,movefocus,l"
      "SUPER,l,movefocus,r"
      "SUPER,k,movefocus,u"
      "SUPER,j,movefocus,d"

      "SUPER,left,movefocus,l"
      "SUPER,down,movefocus,r"
      "SUPER,up,movefocus,u"
      "SUPER,right,movefocus,d"

      "SUPER,1,workspace,1"
      "SUPER,2,workspace,2"
      "SUPER,3,workspace,3"
      "SUPER,4,workspace,4"
      "SUPER,mouse_down,workspace,e-1"
      "SUPER,mouse_up,workspace,e+1"

      "SUPER SHIFT, H, movewindow, l"
      "SUPER SHIFT, L, movewindow, r"
      "SUPER SHIFT, K, movewindow, u"
      "SUPER SHIFT, J, movewindow, d"
      "SUPER SHIFT, left, movewindow, l"
      "SUPER SHIFT, right, movewindow, r"
      "SUPER SHIFT, up, movewindow, u"
      "SUPER SHIFT, down, movewindow, d"

      "SUPER CTRL, h, resizeactive,-30 0"
      "SUPER CTRL, l, resizeactive,30 0"
      "SUPER CTRL, k, resizeactive,0 -30"
      "SUPER CTRL, j, resizeactive,0 30"

      "SUPER SHIFT, 1, movetoworkspacesilent, 1"
      "SUPER SHIFT, 2, movetoworkspacesilent, 2"
      "SUPER SHIFT, 3, movetoworkspacesilent, 3"
      "SUPER SHIFT, 4, movetoworkspacesilent, 4"

      "SUPER,RETURN,exec,fuzzel"
    ];

    windowrule = [
      # Window rules
      "tile,title:^(kitty)$"
      "float,title:^(fly_is_kitty)$"
      "tile,^(Spotify)$"
      # "tile,^(neovide)$"
      "tile,^(wps)$"
    ];

    windowrulev2 = [
      "float,class:^(fuzzel)$"
      "float,class:^(pavucontrol)$"
      "float,class:^(file_progress)$"
      "float,class:^(confirm)$"
      "float,class:^(dialog)$"
      "float,class:^(download)$"
      "float,class:^(notification)$"
      "float,class:^(error)$"
      "float,class:^(confirmreset)$"
      "float,title:^(Open File)$"
      "float,title:^(branchdialog)$"
      "float,title:^(Confirm to replace files)$"
      "float,title:^(File Operation Progress)$"
      "float,title:^(mpv)$"
      "opacity 1.0 1.0,class:^(wofi)$"
    ];
  };
}
