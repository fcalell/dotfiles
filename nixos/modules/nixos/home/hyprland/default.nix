{ pkgs, ... }: {
  imports = [
    ./config.nix
    ./waybar
    #./dunst 
  ];
  home.packages = with pkgs; [
    swaybg
    wl-clipboard
    glib
    wayland
    direnv
    grim
    slurp
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun";
      allow_images = true;
    };
  };
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;
  };
  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    ANKI_WAYLAND = "1";
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORM = "xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
