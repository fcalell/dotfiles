{ config, ... }: {
  imports = [ ./style.nix ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile.waybar = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/nixos/home/hyprland/waybar/config";
  };

}
