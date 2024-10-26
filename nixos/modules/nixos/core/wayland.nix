{ pkgs, inputs, ... }: {
  imports = [ inputs.hyprland.nixosModules.default ];
  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      wayland = true;
    };
  };
  programs.dconf.enable = true;
  programs.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
    };
    terminal-exec = {
      enable = true;
      settings = { default = [ "kitty.desktop" ]; };
    };
  };
  environment = {
    # variables = {
    #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # };
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    };
  };
}
