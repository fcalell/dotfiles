{ pkgs, ... }: {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    udiskie
    hyprpolkitagent
  ];

  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    exec-once = [
      # "systemctl --user import-environment &"
      # "hash dbus-update-activation-environment 2>/dev/null &"
      # "dbus-update-activation-environment --systemd &"
      # "nm-applet &"
      "systemctl --user enable --now hyprpolkitagent.service"
      "udiskie"
      "wl-paste --primary --watch wl-copy --primary --clear"
      # "wpaperd &"
      # "swaybg -m fill -i ~/nixos/modules/common/home/stylix/wallpapers/feet-on-the-dashboard.png &"
      # "sleep 1 && swaylock"
      # "hyprctl setcursor Catppuccin-Mocha-Dark-Cursors 24"
      # "waybar &"
      # "mako &"
      # "easyeffects --gapplication-service" # Starts easyeffects in the background
    ];
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 2;
      mouse_refocus = false;
      float_switch_override_focus = 0;
      numlock_by_default = true;
      accel_profile = "flat";
      sensitivity = 0;
      touchpad = { natural_scroll = 1; };
    };

    general = {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 1;
      "col.active_border" = "$lavender";
      "col.inactive_border" = "$overlay0";
      layout = "master";
      no_focus_fallback = true;
    };

    decoration = {
      rounding = 0;
      # dim_inactive = true;
      shadow = { enabled = false; };
      blur = { enabled = false; };
    };

    animations = {
      enabled = true;
      bezier = [ "linear, 0.0, 0.0, 1, 1" ];
      animation = [
        "borderangle, 1, 50, linear, loop"
        "workspaces,1,0.8,default"
        "windows,0,0.5,default"
        "fade,0,0.5,default"
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

    bindm = [ "SUPER,mouse:272,movewindow" "SUPER,mouse:273,resizewindow" ];

    bind = [
      "SUPER,Q,killactive,"
      ''SUPER,P,exec, grim -g "$(slurp)" - | wl-copy -t image/png''
      "SUPER,RETURN,exec,fuzzel"
      "SUPER,F,fullscreen"

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

    ];

    windowrule = [
      # Window rules
      "tile,title:^(kitty)$"
      "float,title:^(fly_is_kitty)$"
      # "tile,^(Spotify)$"
      # "tile,^(neovide)$"
      # "tile,^(wps)$"
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
      "float,title:^(Android Emulator)"
      "float,title:^(Emulator)"
    ];
  };
}
