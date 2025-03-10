{ ... }: {
  imports = [ ./config.nix ./waybar ./mako ./fuzzel ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd = { variables = [ "--all" ]; };
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
    enable = false;
    settings = {
      background = {
        path = "${../../../../assets/wallpapers/feet-on-the-dashboard.png}";
      };
    };
  };
  programs.wlogout = { enable = true; };
  programs.imv.enable = true;
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
