{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ./streamrip ./udiskie.nix ];
  home.packages = with pkgs; [
    google-chrome
    xfce.thunar
    onlyoffice-bin
    vlc
    nicotine-plus
  ];
}
