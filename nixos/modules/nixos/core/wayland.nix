{ pkgs, inputs, ... }: {
  imports = [ inputs.hyprland.nixosModules.default ];
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.defaultSession = "hyprland";
  programs.hyprland.enable = true;
  xdg = {
    # autostart.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
    };
  };
  environment = {
    variables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    };
  };
}