{ pkgs, ... }: {
  imports = [ ./addons ./gtk ./hyprland ];
  home.packages = [ pkgs.xfce.thunar ];
}
