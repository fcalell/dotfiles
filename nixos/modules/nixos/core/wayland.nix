{ pkgs, inputs, ... }: {
  imports = [ inputs.hyprland.nixosModules.default ];
  services.xserver.displayManager.gdm.wayland = true;
  services.displayManager.defaultSession = "hyprland";
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  xdg = {
    # autostart.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
    };
  };
  # environment = {
  #   variables = {
  #     QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #     QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #   };
  #   sessionVariables = {
  #     NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
  #   };
  # };
}
