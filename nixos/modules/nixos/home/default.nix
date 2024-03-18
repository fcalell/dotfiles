{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ];
  home.packages = [ pkgs.google-chrome pkgs.xfce.thunar ];
}
