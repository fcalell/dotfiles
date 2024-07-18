{ pkgs, ... }: {
  imports = [ ./gtk ./hyprland ./streamrip ];
  home.packages = with pkgs; [
    google-chrome
    xfce.thunar
    onlyoffice-bin
    vlc
    nicotine-plus
  ];
}
