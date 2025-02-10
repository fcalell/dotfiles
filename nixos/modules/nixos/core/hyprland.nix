{ pkgs, inputs, username, ... }:
let
  login-script = pkgs.pkgs.writeShellScriptBin "session" ''
    echo "======================================"
    echo "   Welcome! Please select a session:  "
    echo "======================================"
    echo "1) hyprland"
    echo "2) steamos"
    echo ""

    # Loop until a valid option is provided
    while true; do
        read -rp "Enter your choice (1 or 2): " choice
        case $choice in
            1)
                echo "Launching hyprland..."
                exec hyprland
                ;;
            2)
                echo "Launching steamos..."
                exec steamos
                ;;
            *)
                echo "Invalid option. Please enter 1 or 2."
                ;;
        esac
    done
  '';

in {
  imports = [
    inputs.hyprland.nixosModules.default
    # inputs.catppuccin.nixosModules.catppuccin
  ];
  programs.dconf.enable = true;

  services.getty = { autologinUser = "${username}"; };
  # services.displayManager = {
  #   autoLogin = {
  #     enable = true;
  #     user = "${username}";
  #   };
  #   defaultSession = "hyprland-uwsm";
  #   sddm = {
  #     enable = true;
  #     wayland = { enable = true; };
  #   };
  # };
  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal ];
  environment = {
    # variables = {
    #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # };
    systemPackages = [ login-script ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    };
  };
}
