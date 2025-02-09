{ pkgs, inputs, username, ... }: {
  imports = [
    inputs.hyprland.nixosModules.default
    # inputs.catppuccin.nixosModules.catppuccin
  ];
  programs.dconf.enable = true;

  services.getty.autologinUser = "${username}";
  services.displayManager = {
    # autoLogin = {
    #   enable = true;
    #   user = "${username}";
    # };
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland = { enable = true; };
      # package = pkgs.kdePackages.sddm;
    };
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
