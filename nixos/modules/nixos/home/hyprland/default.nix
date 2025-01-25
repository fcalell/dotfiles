{ pkgs, inputs, ... }: {
  imports = [ ./config.nix ./waybar ./mako ./fuzzel ];
  home.packages = with pkgs; [ grim slurp wl-clipboard ];
  wayland.windowManager.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload =
        [ "${../../../../assets/wallpapers/feet-on-the-dashboard.png}" ];
      wallpaper =
        [ ",${../../../../assets/wallpapers/feet-on-the-dashboard.png}" ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "${../../../../assets/wallpapers/feet-on-the-dashboard.png}";
      };
    };
  };
  # home.sessionVariables = {
  #   GDK_BACKEND = "wayland";
  #   ANKI_WAYLAND = "1";
  #   DIRENV_LOG_FORMAT = "";
  #   WLR_DRM_NO_ATOMIC = "1";
  #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #   QT_QPA_PLATFORM = "xcb";
  #   QT_QPA_PLATFORMTHEME = "qt5ct";
  #   QT_STYLE_OVERRIDE = "kvantum";
  #   MOZ_ENABLE_WAYLAND = "1";
  #   WLR_BACKEND = "vulkan";
  #   WLR_RENDERER = "vulkan";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   XDG_SESSION_TYPE = "wayland";
  #   SDL_VIDEODRIVER = "wayland";
  #   CLUTTER_BACKEND = "wayland";
  # };
}
