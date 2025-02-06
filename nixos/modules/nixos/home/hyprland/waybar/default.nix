{ config, ... }: {
  imports = [ ./style.nix ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config.jsonc" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/nixos/home/hyprland/waybar/config/config.jsonc";
  };

  xdg.configFile."waybar/style.css" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/modules/nixos/home/hyprland/waybar/config/style.css";
  };
}
